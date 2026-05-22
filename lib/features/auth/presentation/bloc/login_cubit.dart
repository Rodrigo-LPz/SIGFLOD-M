import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/session_service.dart';
import '../../data/repositories/user_firestore_repository.dart';
import '../../domain/models/app_user_model.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({UserRole initialRole = UserRole.logopeda})
    : super(LoginState(selectedRole: initialRole));

  // Almacena la referencia al servicio de autenticación.
  final AuthService _authService = AuthService.instance;

  // Almacena la referencia al repositorio de usuarios de Firestore.
  final UserFirestoreRepository _userRepository =
      UserFirestoreRepository.instance;

  // Actualiza el email en el estado al detectar cambios en el campo.
  void emailChanged(String value) {
    emit(state.copyWith(email: value, clearError: true));
  }

  // Actualiza la contraseña en el estado al detectar cambios en el campo.
  void passwordChanged(String value) {
    emit(state.copyWith(password: value, clearError: true));
  }

  // Actualiza la aceptación de términos en el estado.
  void toggleTerms(bool value) {
    emit(state.copyWith(acceptedTerms: value, clearError: true));
  }

  // Valida el formulario y ejecuta el proceso de autenticación con Firebase.
  Future<void> submit() async {
    if (!state.isEmailValid) {
      emit(state.copyWith(error: 'Introduce un correo electrónico válido.'));
      return;
    }

    if (!state.isPasswordValid) {
      emit(
        state.copyWith(
          error: 'La contraseña debe tener al menos 6 caracteres.',
        ),
      );
      return;
    }

    if (!state.acceptedTerms) {
      emit(
        state.copyWith(
          error: 'Debes aceptar los términos y la política de privacidad.',
        ),
      );
      return;
    }

    emit(state.copyWith(isSubmitting: true, clearError: true));

    try {
      // Autentica las credenciales contra Firebase Authentication.
      final credential = await _authService.signInWithEmailAndPassword(
        email: state.email.trim(),
        password: state.password.trim(),
      );

      final uid = credential.user?.uid;
      if (uid == null) {
        emit(
          state.copyWith(
            isSubmitting: false,
            error: 'No se pudo obtener la sesión del usuario.',
          ),
        );
        return;
      }

      // Recupera el perfil completo del usuario desde Firestore.
      final appUser = await _userRepository.getByUid(uid);

      if (appUser == null) {
        await _authService.signOut();
        emit(
          state.copyWith(
            isSubmitting: false,
            error: 'No se encontró el perfil del usuario en el sistema.',
          ),
        );
        return;
      }

      // Valida que el rol del perfil coincida con el rol seleccionado.
      if (appUser.role != state.selectedRole) {
        await _authService.signOut();
        emit(
          state.copyWith(
            isSubmitting: false,
            error: 'Las credenciales no corresponden al perfil seleccionado.',
          ),
        );
        return;
      }

      // Refresca el estado del usuario para conocer su flag de verificación actual.
      await _authService.reloadCurrentUser();

      // Exige que los familiares tengan su correo electrónico verificado.
      final firebaseUser = _authService.currentUser;
      if (appUser.role == UserRole.familiar &&
          firebaseUser != null &&
          !firebaseUser.emailVerified) {
        await _authService.signOut();
        emit(
          state.copyWith(isSubmitting: false, error: '__EMAIL_NOT_VERIFIED__'),
        );
        return;
      }

      // Registra el usuario activo en el servicio global de sesión.
      SessionService.instance.setUser(appUser);

      emit(state.copyWith(isSubmitting: false, isSuccess: true));
    } on FirebaseAuthException catch (e) {
      // Traduce el código de error de Firebase a un mensaje en español.
      emit(
        state.copyWith(isSubmitting: false, error: _mapFirebaseError(e.code)),
      );
    } catch (_) {
      // Captura cualquier error inesperado no contemplado anteriormente.
      emit(
        state.copyWith(
          isSubmitting: false,
          error: 'Ha ocurrido un error inesperado. Inténtalo de nuevo.',
        ),
      );
    }
  }

  // Mapea los códigos de error de Firebase a mensajes comprensibles.
  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No existe una cuenta con este correo electrónico.';
      case 'wrong-password':
        return 'La contraseña introducida es incorrecta.';
      case 'invalid-email':
        return 'El formato del correo electrónico no es válido.';
      case 'user-disabled':
        return 'Esta cuenta ha sido deshabilitada.';
      case 'too-many-requests':
        return 'Demasiados intentos fallidos. Inténtalo más tarde.';
      case 'invalid-credential':
        return 'Credenciales incorrectas. Verifica tu correo y contraseña.';
      default:
        return 'Error de autenticación. Inténtalo de nuevo.';
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_state.dart';


class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  void usernameChanged(String value) {
    emit(
      state.copyWith(
        username: value,
        clearError: true,
      ),
    );
  }

  void passwordChanged(String value) {
    emit(
      state.copyWith(
        password: value,
        clearError: true,
      ),
    );
  }

  void toggleTerms(bool value) {
    emit(
      state.copyWith(
        acceptedTerms: value,
        clearError: true,
      ),
    );
  }

  Future<void> submit() async {
    if (!state.isUsernameValid) {
      emit(
        state.copyWith(
          error: 'Debe introducir un nombre de usuario válido.',
        ),
      );
      return;
    }

    if (!state.isPasswordValid) {
      emit(
        state.copyWith(
          error: 'La contraseña debe tener al menos 4 caracteres.',
        ),
      );
      return;
    }

    if (!state.acceptedTerms) {
      emit(
        state.copyWith(
          error: 'Debe aceptar los términos y la política de privacidad.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isSubmitting: true,
        clearError: true,
      ),
    );

    await Future.delayed(const Duration(seconds: 1));

    emit(
      state.copyWith(
        isSubmitting: false,
        clearError: true,
      ),
    );
  }
}
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  void emailChanged(String value) {
    emit(state.copyWith(email: value));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value));
  }

  void toggleTerms(bool value) {
    emit(state.copyWith(acceptedTerms: value));
  }

  void submit() {
    if (!state.acceptedTerms) {
      emit(state.copyWith(error: 'Debe aceptar los términos'));
      return;
    }

    // Aquí luego irá la lógica real
    emit(state.copyWith(isSubmitting: true));

    Future.delayed(const Duration(seconds: 1), () {
      emit(state.copyWith(isSubmitting: false));
    });
  }
}
part of 'login_cubit.dart';

class LoginState extends Equatable {
  final String email;
  final String password;
  final bool acceptedTerms;
  final bool isSubmitting;
  final String? error;

  const LoginState({
    this.email = '',
    this.password = '',
    this.acceptedTerms = false,
    this.isSubmitting = false,
    this.error,
  });

  LoginState copyWith({
    String? email,
    String? password,
    bool? acceptedTerms,
    bool? isSubmitting,
    String? error,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      acceptedTerms: acceptedTerms ?? this.acceptedTerms,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
    );
  }

  @override
  List<Object?> get props =>
      [email, password, acceptedTerms, isSubmitting, error];
}
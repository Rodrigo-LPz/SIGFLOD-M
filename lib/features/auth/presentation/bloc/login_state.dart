part of 'login_cubit.dart';


class LoginState extends Equatable {
  final String username;
  final String password;
  final bool acceptedTerms;
  final bool isSubmitting;
  final String? error;

  const LoginState({
    this.username = '',
    this.password = '',
    this.acceptedTerms = false,
    this.isSubmitting = false,
    this.error,
  });

  bool get isUsernameValid => username.trim().isNotEmpty;

  bool get isPasswordValid => password.trim().length >= 4;

  bool get canSubmit =>
      isUsernameValid &&
      isPasswordValid &&
      acceptedTerms &&
      !isSubmitting;

  LoginState copyWith({
    String? username,
    String? password,
    bool? acceptedTerms,
    bool? isSubmitting,
    String? error,
    bool clearError = false,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      acceptedTerms: acceptedTerms ?? this.acceptedTerms,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [
    username,
    password,
    acceptedTerms,
    isSubmitting,
    error,
  ];
}
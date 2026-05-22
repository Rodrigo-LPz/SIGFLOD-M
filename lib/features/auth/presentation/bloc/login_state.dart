part of 'login_cubit.dart';

class LoginState extends Equatable {
  final String email;
  final String password;
  final bool acceptedTerms;
  final bool isSubmitting;
  final bool isSuccess;
  final String? error;
  final UserRole selectedRole;

  const LoginState({
    this.email = '',
    this.password = '',
    this.acceptedTerms = false,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.error,
    this.selectedRole = UserRole.logopeda,
  });

  // Valida que el email tenga formato correcto.
  bool get isEmailValid =>
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.trim());

  // Valida que la contraseña cumpla el mínimo exigido por Firebase.
  bool get isPasswordValid => password.trim().length >= 6;

  // Determina si el formulario está listo para enviarse.
  bool get canSubmit =>
      isEmailValid && isPasswordValid && acceptedTerms && !isSubmitting;

  LoginState copyWith({
    String? email,
    String? password,
    bool? acceptedTerms,
    bool? isSubmitting,
    bool? isSuccess,
    String? error,
    bool clearError = false,
    UserRole? selectedRole,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      acceptedTerms: acceptedTerms ?? this.acceptedTerms,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      error: clearError ? null : (error ?? this.error),
      selectedRole: selectedRole ?? this.selectedRole,
    );
  }

  @override
  List<Object?> get props => [
    email,
    password,
    acceptedTerms,
    isSubmitting,
    isSuccess,
    error,
    selectedRole,
  ];
}

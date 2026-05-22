import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/utils/input_formatters.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../invitations/data/repositories/invitation_firestore_repository.dart';
import '../../data/repositories/user_firestore_repository.dart';

// Pantalla de registro para familiares con código de invitación.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controladores de los campos del formulario de registro.
  final _firstNameController = TextEditingController();
  final _firstSurnameController = TextEditingController();
  final _secondSurnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _invitationCodeController = TextEditingController();

  // Indica si el proceso de registro está actualmente en curso.
  bool _isSubmitting = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _firstSurnameController.dispose();
    _secondSurnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _invitationCodeController.dispose();
    super.dispose();
  }

  // Comprueba todos los campos, crea la cuenta y vincula al paciente.
  Future<void> _register() async {
    final t = AppLocalizations.of(context)!;

    final firstName = _firstNameController.text.trim();
    final firstSurname = _firstSurnameController.text.trim();
    final secondSurname = _secondSurnameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final invitationCode = _invitationCodeController.text.trim().toUpperCase();

    // Comprueba que todos los campos obligatorios estén informados.
    if (firstName.isEmpty ||
        firstSurname.isEmpty ||
        secondSurname.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        invitationCode.isEmpty) {
      _showSnack(t.errorAllFieldsRequired);
      return;
    }

    // Verifica el formato básico del correo electrónico.
    if (!email.contains('@') || !email.contains('.')) {
      _showSnack(t.errorInvalidEmail);
      return;
    }

    // Exige una longitud mínima razonable para la contraseña.
    if (password.length < 6) {
      _showSnack(t.errorShortPassword);
      return;
    }

    // Comprueba que las dos contraseñas introducidas coincidan.
    if (password != confirmPassword) {
      _showSnack(t.errorPasswordMismatch);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Verifica que el código de invitación existe en Firestore.
      final invitation = await InvitationFirestoreRepository.instance
          .findByCode(invitationCode);

      if (invitation == null) {
        _showSnack(t.errorInvitationNotFound);
        return;
      }

      debugPrint('PASO 1: creando cuenta en Firebase Auth');

      // Crea la cuenta de Firebase Authentication con email y contraseña.
      final credential = await AuthService.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final uid = credential.user?.uid;
      if (uid == null) {
        _showSnack(t.errorUnexpected);
        return;
      }

      debugPrint('PASO 2: cuenta creada con uid $uid');

      // Construye el nombre completo a partir de las tres partes recibidas.
      final displayName = '$firstName $firstSurname $secondSurname';

      debugPrint('PASO 3: creando documento user en Firestore');

      // Crea el documento del usuario en Firestore con rol familiar.
      await UserFirestoreRepository.instance.createFamiliar(
        uid: uid,
        email: email,
        displayName: displayName,
        linkedPatientId: invitation.patientId,
      );

      debugPrint('PASO 4: documento user creado correctamente');

      // Consume la invitación para impedir su reutilización.
      await InvitationFirestoreRepository.instance.consumeInvitation(
        invitationCode,
      );

      debugPrint('PASO 5: invitación consumida correctamente');

      // Envía el correo de verificación al recién registrado.
      await AuthService.instance.sendEmailVerification();

      debugPrint('PASO 6: email de verificación enviado');

      // Cierra la sesión recién creada para forzar el flujo de verificación.
      await AuthService.instance.signOut();

      if (!mounted) return;

      // Muestra un diálogo informativo de éxito y vuelve a la pantalla anterior.
      await showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text(t.registrationSuccessTitle),
            content: Text(t.registrationSuccessMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(t.continueAction),
              ),
            ],
          );
        },
      );

      if (!mounted) return;

      // Vuelve atrás solo si la navegación lo permite todavía.
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      _showSnack(_translateAuthError(e, t));
    } catch (_) {
      _showSnack(t.errorUnexpected);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // Traduce el código de error de FirebaseAuth al mensaje localizado.
  String _translateAuthError(FirebaseAuthException e, AppLocalizations t) {
    switch (e.code) {
      case 'email-already-in-use':
        return t.errorEmailInUse;
      case 'invalid-email':
        return t.errorBadEmailFormat;
      case 'weak-password':
        return t.errorWeakPassword;
      default:
        return t.errorGenericAuth;
    }
  }

  // Muestra un mensaje breve al usuario en la parte inferior de la pantalla.
  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.createAccountTitle), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: ListView(
            children: [
              Text(
                t.createAccountSubtitle,
                style: AppTextStyles.title,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.xl),

              // Captura el nombre del nuevo usuario familiar.
              AppTextField(
                label: t.firstNameRegisterLabel,
                controller: _firstNameController,
                inputFormatters: [
                  AppInputFormatters.nameFormatter(
                    context: context,
                    errorMessage: t.errorInvalidNameChar,
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              // Captura el primer apellido del nuevo usuario familiar.
              AppTextField(
                label: t.firstSurnameLabel,
                controller: _firstSurnameController,
                inputFormatters: [
                  AppInputFormatters.nameFormatter(
                    context: context,
                    errorMessage: t.errorInvalidNameChar,
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              // Captura el segundo apellido del nuevo usuario familiar.
              AppTextField(
                label: t.secondSurnameLabel,
                controller: _secondSurnameController,
                inputFormatters: [
                  AppInputFormatters.nameFormatter(
                    context: context,
                    errorMessage: t.errorInvalidNameChar,
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),

              // Captura el correo electrónico para autenticarse posteriormente.
              AppTextField(
                label: t.emailLabel,
                hint: t.emailHint,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: AppSpacing.md),

              // Captura la contraseña que el usuario quiere establecer.
              AppTextField(
                label: t.passwordLabel,
                hint: t.passwordHint,
                controller: _passwordController,
                obscureText: true,
              ),

              const SizedBox(height: AppSpacing.md),

              // Captura la confirmación de la contraseña para evitar errores tipográficos.
              AppTextField(
                label: t.confirmPasswordLabel,
                hint: t.passwordHint,
                controller: _confirmPasswordController,
                obscureText: true,
              ),

              const SizedBox(height: AppSpacing.lg),

              // Captura el código de invitación entregado por el logopeda.
              AppTextField(
                label: t.invitationCodeLabel,
                hint: t.invitationCodeHint,
                controller: _invitationCodeController,
              ),

              const SizedBox(height: AppSpacing.xl),

              // Envía el formulario tras validar todos los campos introducidos.
              AppButton(
                label: t.registerButton,
                isLoading: _isSubmitting,
                onPressed: _isSubmitting ? null : _register,
              ),

              const SizedBox(height: AppSpacing.md),

              Text(
                t.alreadyHaveAccount,
                style: AppTextStyles.bodySecondary,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

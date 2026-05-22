import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../domain/models/app_user_model.dart';
import '../bloc/login_cubit.dart';

class LoginPage extends StatelessWidget {
  // Rol seleccionado en la pantalla anterior de selección de perfil.
  final UserRole role;

  const LoginPage({super.key, this.role = UserRole.logopeda});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(initialRole: role),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  // Muestra un diálogo modal que indica al usuario que debe verificar su correo.
  Future<void> _showEmailVerificationDialog(BuildContext context) async {
    final t = AppLocalizations.of(context)!;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(t.emailNotVerifiedTitle),
          content: Text(t.emailNotVerifiedMessage),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await AuthService.instance.sendEmailVerification();
                } catch (_) {
                  // Ignora silenciosamente si el reenvío falla por límite de Firebase.
                }
                if (!dialogContext.mounted) return;
                ScaffoldMessenger.of(
                  dialogContext,
                ).showSnackBar(SnackBar(content: Text(t.verificationSent)));
              },
              child: Text(t.resendVerification),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(t.continueAction),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listenWhen: (previous, current) =>
          previous.error != current.error ||
          previous.isSuccess != current.isSuccess,

      listener: (context, state) {
        // Navega al dashboard si el login fue exitoso.
        if (state.isSuccess) {
          Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
          return;
        }

        // Detecta el marcador interno y muestra el diálogo de verificación pendiente.
        if (state.error == '__EMAIL_NOT_VERIFIED__') {
          _showEmailVerificationDialog(context);
          return;
        }

        // Muestra el error en un SnackBar si existe.
        if (state.error != null && state.error!.isNotEmpty) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.error!)));
        }
      },

      builder: (context, state) {
        final cubit = context.read<LoginCubit>();
        final t = AppLocalizations.of(context)!;

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: AppSpacing.lg),

                  // Muestra el logo principal de la pantalla de acceso.
                  Image.asset(
                    'assets/images/sigflod_logo.png',
                    width: 300,
                    height: 300,
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  Text(t.portalTitle, style: AppTextStyles.headline),

                  const SizedBox(height: AppSpacing.xxl),

                  // Captura el correo electrónico del usuario.
                  AppTextField(
                    label: t.emailLabel,
                    hint: t.emailHint,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: cubit.emailChanged,
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Captura la contraseña del usuario.
                  AppTextField(
                    label: t.passwordLabel,
                    hint: t.passwordHint,
                    obscureText: true,
                    onChanged: cubit.passwordChanged,
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Registra la aceptación de términos y política de privacidad.
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: state.acceptedTerms,
                        onChanged: (value) {
                          cubit.toggleTerms(value ?? false);
                        },
                      ),
                      Expanded(
                        child: Text(t.acceptTerms, style: AppTextStyles.label),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Envía el formulario y desencadena el proceso de autenticación.
                  AppButton(
                    label: t.accessButton,
                    isLoading: state.isSubmitting,
                    onPressed: state.isSubmitting ? null : cubit.submit,
                  ),

                  const Spacer(),

                  Text(t.noAccountQuestion, style: AppTextStyles.bodySecondary),

                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

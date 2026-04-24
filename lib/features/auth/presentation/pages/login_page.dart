import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../bloc/login_cubit.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      // 🔹 Este filtro evita disparar el listener si el error no ha cambiado
      listenWhen: (previous, current) => previous.error != current.error,

      // 🔹 Aquí escuchamos errores del estado para mostrarlos en pantalla
      listener: (context, state) {
        // 🔹 Si hay error, mostramos un SnackBar informativo
        if (state.error != null && state.error!.isNotEmpty) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.error!),
              ),
            );
        }
      },

      // 🔹 Aquí reconstruimos la UI según el estado actual del login
      builder: (context, state) {
        // 🔹 Referencia rápida al cubit para usar sus métodos
        final cubit = context.read<LoginCubit>();

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: AppSpacing.xxl),

                  // 🔹 Logo principal de la pantalla de acceso
                  const Icon(
                    Icons.medical_services_rounded,
                    size: 80,
                    color: AppColors.primary,
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // 🔹 Título principal
                  const Text(
                    'Portal de Gestión',
                    style: AppTextStyles.headline,
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  // 🔹 Campo de usuario conectado al estado real
                  AppTextField(
                    label: 'Usuario',
                    hint: 'Ingrese su nombre de usuario...',
                    onChanged: cubit.usernameChanged,
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // 🔹 Campo de contraseña conectado al estado real
                  AppTextField(
                    label: 'Contraseña',
                    hint: 'Ingrese su contraseña...',
                    obscureText: true,
                    onChanged: cubit.passwordChanged,
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // 🔹 Casilla de aceptación de términos, ahora sí enlazada al cubit
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: state.acceptedTerms,
                        onChanged: (value) {
                          cubit.toggleTerms(value ?? false);
                        },
                      ),
                      const Expanded(
                        child: Text(
                          'Acepto los Términos de Servicio y Política de Privacidad.',
                          style: AppTextStyles.label,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // 🔹 Botón principal de acceso
                  AppButton(
                    label: 'Acceder',

                    // 🔹 Muestra estado de carga mientras se "envía" el login
                    isLoading: state.isSubmitting,

                    // 🔹 Mientras carga, anulamos el botón
                    onPressed: state.isSubmitting
                        ? null
                        : () async {
                            // 🔹 Ejecutamos la validación/envío local del cubit
                            await cubit.submit();

                            // 🔹 Si el widget ya no está montado, salimos
                            if (!context.mounted) return;

                            // 🔹 Leemos el estado actual tras el submit
                            final currentState = context.read<LoginCubit>().state;

                            // 🔹 Si no hay error y ya no está enviando, permitimos el acceso
                            if (currentState.error == null &&
                                !currentState.isSubmitting) {
                              Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.dashboard,
                              );
                            }
                          },
                  ),

                  const Spacer(),

                  // 🔹 Texto inferior auxiliar
                  const Text(
                    '¿No tienes una cuenta? Registro.',
                    style: AppTextStyles.bodySecondary,
                  ),

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
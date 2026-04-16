import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
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
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.xxl),

              // Logo
              const Icon(
                Icons.medical_services_rounded,
                size: 80,
                color: AppColors.primary,
              ),

              const SizedBox(height: AppSpacing.lg),

              const Text(
                'Portal de Gestión',
                style: AppTextStyles.headline,
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Usuario
              const AppTextField(
                label: 'Usuario',
                hint: 'Ingrese su nombre de usuario...',
              ),

              const SizedBox(height: AppSpacing.md),

              // Contraseña
              const AppTextField(
                label: 'Contraseña',
                hint: 'Ingrese su contraseña...',
                obscureText: true,
              ),

              const SizedBox(height: AppSpacing.md),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: false,
                    onChanged: (_) {},
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

              AppButton(
                label: 'Acceder',
                onPressed: () {},
              ),

              const Spacer(),

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
  }
}
import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.xxl),

              const Icon(
                Icons.medical_services_rounded,
                size: 90,
                color: AppColors.primary,
              ),

              const SizedBox(height: AppSpacing.lg),

              const Text(
                'Portal de Gestión',
                style: AppTextStyles.headline,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.xxl),

              const Text(
                'Acceder como:',
                style: AppTextStyles.title,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.lg),

              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.login,
                  );
                },
                child: const AppCard(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                    child: Center(
                      child: Text(
                        'Logopeda',
                        style: AppTextStyles.body,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.login,
                  );
                },
                child: const AppCard(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                    child: Center(
                      child: Text(
                        'Familiar',
                        style: AppTextStyles.body,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              AppButton(
                label: 'Crear cuenta',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'La creación de cuenta se implementará en una fase posterior.',
                      ),
                    ),
                  );
                },
              ),

              const Spacer(),

              const Text(
                'Desarrollado por Rodrigo López',
                style: AppTextStyles.bodySecondary,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
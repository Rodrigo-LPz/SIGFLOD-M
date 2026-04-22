import 'package:flutter/material.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';


class TemplateConfigPage extends StatelessWidget {
  const TemplateConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plantilla: Fonemas / Pronunciación'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: ListView(
          children: [
            const SizedBox(height: AppSpacing.sm),

            const Text(
              'Configuración Básica',
              style: AppTextStyles.title,
            ),

            const SizedBox(height: AppSpacing.md),

            const AppTextField(
              label: 'Nombre de la plantilla',
            ),

            const SizedBox(height: AppSpacing.md),

            const AppTextField(
              label: 'Objetivo',
            ),

            const SizedBox(height: AppSpacing.md),

            const AppTextField(
              label: 'Edad recomendada',
            ),

            const SizedBox(height: AppSpacing.lg),

            const Text(
              'Nivel',
              style: AppTextStyles.body,
            ),

            const SizedBox(height: AppSpacing.sm),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _LevelChip(label: 'Inicial'),
                _LevelChip(label: 'Medio'),
                _LevelChip(label: 'Avanzado'),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            const AppTextField(
              label: 'Observaciones',
              maxLines: 3,
            ),

            const SizedBox(height: AppSpacing.xl),

            AppButton(
              label: 'Continuar',
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.templateWords,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelChip extends StatelessWidget {
  final String label;

  const _LevelChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: AppTextStyles.bodySecondary,
      ),
    );
  }
}
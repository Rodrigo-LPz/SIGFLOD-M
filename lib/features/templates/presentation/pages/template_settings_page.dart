import 'package:flutter/material.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';


class TemplateSettingsPage extends StatelessWidget {
  const TemplateSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes Finales'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: ListView(
          children: [
            const SizedBox(height: AppSpacing.sm),

            const _CounterSetting(
              title: 'Nº de Repeticiones',
              value: '3',
            ),

            const SizedBox(height: AppSpacing.lg),

            const _SwitchSetting(
              title: 'Modo Guiado',
              value: true,
            ),

            const SizedBox(height: AppSpacing.lg),

            const _CounterSetting(
              title: 'Tiempo Límite (min)',
              value: '3',
            ),

            const SizedBox(height: AppSpacing.lg),

            const _SwitchSetting(
              title: 'Sonidos',
              value: true,
            ),

            const SizedBox(height: AppSpacing.lg),

            const _SwitchSetting(
              title: 'Retroalimentación',
              value: true,
            ),

            const SizedBox(height: AppSpacing.lg),

            const _SwitchSetting(
              title: 'Refuerzo Positivo',
              value: true,
            ),

            const SizedBox(height: AppSpacing.xl),

            AppButton(
              label: 'Previsualizar',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _CounterSetting extends StatelessWidget {
  final String title;
  final String value;

  const _CounterSetting({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.body,
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.remove_circle_outline),
            Text(
              value,
              style: AppTextStyles.title,
            ),
            const Icon(Icons.add_circle_outline),
          ],
        ),
      ],
    );
  }
}

class _SwitchSetting extends StatelessWidget {
  final String title;
  final bool value;

  const _SwitchSetting({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.body,
        ),
        Switch(
          value: value,
          onChanged: (_) {},
        ),
      ],
    );
  }
}
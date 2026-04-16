import 'package:flutter/material.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_text_field.dart';


class TemplateWordsPage extends StatelessWidget {
  const TemplateWordsPage({super.key});

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
              'Palabras',
              style: AppTextStyles.title,
            ),

            const SizedBox(height: AppSpacing.md),

            // Lista simulada de palabras
            const _WordTile(word: 'Casa'),
            const _WordTile(word: 'Zapato'),
            const _WordTile(word: 'Cantar'),
            const _WordTile(word: 'Kayak'),

            const SizedBox(height: AppSpacing.xl),

            const Text(
              'Añadir nueva palabra',
              style: AppTextStyles.body,
            ),

            const SizedBox(height: AppSpacing.sm),

            const AppTextField(
              label: 'Escriba una nueva palabra',
              hint: 'Escriba una palabra...',
            ),

            const SizedBox(height: AppSpacing.sm),

            AppButton(
              label: 'Añadir Palabra',
              onPressed: () {},
            ),

            const SizedBox(height: AppSpacing.xl),

            AppButton(
              label: 'Continuar',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _WordTile extends StatelessWidget {
  final String word;

  const _WordTile({required this.word});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
        horizontal: AppSpacing.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            word,
            style: AppTextStyles.body,
          ),
          const Icon(Icons.delete_outline),
        ],
      ),
    );
  }
}
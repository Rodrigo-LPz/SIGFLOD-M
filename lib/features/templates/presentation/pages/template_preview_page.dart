import 'package:flutter/material.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';


class TemplatePreviewPage extends StatelessWidget {
  const TemplatePreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Previsualización'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.md),

            const Text(
              'Pronunciación /C/, /K/, /Z/',
              style: AppTextStyles.title,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.xl),

            const Text(
              'Repite las palabras:',
              style: AppTextStyles.body,
            ),

            const SizedBox(height: AppSpacing.xl),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: AppSpacing.md,
                crossAxisSpacing: AppSpacing.md,
                children: const [
                  _WordCard(word: 'Casa'),
                  _WordCard(word: 'Zapato'),
                  _WordCard(word: 'Cantar'),
                  _WordCard(word: 'Kayak'),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            AppButton(
              label: 'Guardar',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _WordCard extends StatelessWidget {
  final String word;

  const _WordCard({required this.word});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Center(
        child: Text(
          word,
          style: AppTextStyles.title,
        ),
      ),
    );
  }
}
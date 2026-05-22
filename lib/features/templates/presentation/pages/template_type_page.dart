import 'package:flutter/material.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../domain/models/template_enums.dart';

class TemplateTypePage extends StatelessWidget {
  const TemplateTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.templateTypeTitle), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: ListView(
          children: [
            Text(t.templateTypeQuestion, style: AppTextStyles.title),
            const SizedBox(height: AppSpacing.lg),

            _TypeCard(
              type: TemplateType.comprehension,
              label: t.templateTypeComprehension,
            ),
            _TypeCard(type: TemplateType.motor, label: t.templateTypeMotor),
            _TypeCard(
              type: TemplateType.vocabulary,
              label: t.templateTypeVocabulary,
            ),
            _TypeCard(
              type: TemplateType.phonemes,
              label: t.templateTypePhonemes,
            ),
            _TypeCard(
              type: TemplateType.sequences,
              label: t.templateTypeSequences,
            ),
            _TypeCard(type: TemplateType.custom, label: t.templateTypeCustom),
          ],
        ),
      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  final TemplateType type;
  final String label;

  const _TypeCard({required this.type, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navega al siguiente paso pasando el código del tipo seleccionado.
        Navigator.pushNamed(
          context,
          AppRoutes.templateConfig,
          arguments: type.code,
        );
      },
      child: AppCard(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.md,
        ),
        child: Row(
          children: [
            const Icon(Icons.arrow_forward_ios, size: 18),
            const SizedBox(width: AppSpacing.md),
            Text(label, style: AppTextStyles.body),
          ],
        ),
      ),
    );
  }
}

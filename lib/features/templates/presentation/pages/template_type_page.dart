import 'package:flutter/material.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/app_card.dart';

class TemplateTypePage extends StatelessWidget {
  const TemplateTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tipo de Plantilla'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: ListView(
          children: const [
            Text(
              '¿Qué tipo de actividad quieres crear?',
              style: AppTextStyles.title,
            ),
            SizedBox(height: AppSpacing.lg),

            _TypeCard(title: 'Comprensión'),
            _TypeCard(title: 'Motora'),
            _TypeCard(title: 'Vocabulario'),
            _TypeCard(title: 'Fonemas / Pronunciación'),
            _TypeCard(title: 'Secuencias'),
            _TypeCard(title: 'Personalizado'),
          ],
        ),
      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  final String title;

  const _TypeCard({required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.templateConfig,
          arguments: title,
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
            Text(
              title,
              style: AppTextStyles.body,
            ),
          ],
        ),
      ),
    );
  }
}
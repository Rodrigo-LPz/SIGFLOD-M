import 'package:flutter/material.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';


class TemplatesPage extends StatelessWidget {
  const TemplatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plantillas'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: ListView(
          children: [
            // Botón crear nueva actividad
            AppButton(
              label: 'Crear/Añadir Nueva Actividad',
              onPressed: () {},
            ),

            const SizedBox(height: AppSpacing.xl),

            const Text(
              'Tipos de Actividad',
              style: AppTextStyles.title,
            ),

            const SizedBox(height: AppSpacing.md),

            const _TemplateCard(
              title: 'Juego de rimas',
              subtitle: 'Rimas, palabras y sílabas.',
            ),
            const _TemplateCard(
              title: 'Pronunciación',
              subtitle: 'Fonética. Control al hablar.',
            ),
            const _TemplateCard(
              title: 'Memorización',
              subtitle: 'Agilidad mental. Recuerda.',
            ),
            const _TemplateCard(
              title: 'Secuencias',
              subtitle: 'Ordena imágenes y/o palabras.',
            ),
          ],
        ),
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const _TemplateCard({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          const Icon(Icons.widgets_outlined, size: 28),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
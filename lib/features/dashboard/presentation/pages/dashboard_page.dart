import 'package:flutter/material.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SIGFLOD ⁓ Logopedia'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: ListView(
          children: [
            const SizedBox(height: AppSpacing.sm),

            // Bienvenida
            const Text(
              'Bienvenido/a Rodrigo',
              style: AppTextStyles.headline,
            ),

            const SizedBox(height: AppSpacing.xl),

            const Text(
              'Actividades Recomendadas',
              style: AppTextStyles.title,
            ),

            const SizedBox(height: AppSpacing.md),

            _ActivityCard(
              title: 'Juego de rimas',
              subtitle: 'Rimas, palabras y sílabas.',
            ),

            _ActivityCard(
              title: 'Memorización',
              subtitle: 'Agilidad mental. Recuerda.',
            ),

            _ActivityCard(
              title: 'Pronunciación',
              subtitle: 'Fonética. Control al hablar.',
            ),

            _ActivityCard(
              title: 'Secuencias',
              subtitle: 'Ordena imágenes y palabras.',
            ),

            const SizedBox(height: AppSpacing.xl),

            const Text(
              'Últimos Progresos',
              style: AppTextStyles.title,
            ),

            const SizedBox(height: AppSpacing.sm),

            _ProgressTile(
              name: 'Matías Ariel',
              detail: 'Auditado hace 2 días',
            ),

            _ProgressTile(
              name: 'Aday Perdomo',
              detail: 'Auditado hace 3 días',
            ),

            const SizedBox(height: AppSpacing.xl),

            AppButton(
              label: 'Nueva Actividad',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const _ActivityCard({
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
          const Icon(Icons.extension, size: 30),
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

class _ProgressTile extends StatelessWidget {
  final String name;
  final String detail;

  const _ProgressTile({
    required this.name,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const CircleAvatar(
        child: Icon(Icons.person),
      ),
      title: Text(
        name,
        style: AppTextStyles.body,
      ),
      subtitle: Text(
        detail,
        style: AppTextStyles.bodySecondary,
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';


class PatientDetailPage extends StatelessWidget {
  const PatientDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ficha del Paciente'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: ListView(
          children: [
            // Nombre del paciente
            const Text(
              'Aday Perdomo Rodríguez',
              style: AppTextStyles.headline,
            ),
            const SizedBox(height: AppSpacing.md),

            // Información básica
            _InfoRow(label: 'Fecha de Nacimiento', value: '22 / 09 / 2005'),
            _InfoRow(label: 'Nacionalidad', value: 'Española'),
            _InfoRow(
              label: 'Trastornos/Dificultades',
              value: 'Disgrafía, Retraso del Habla, TEL',
            ),
            _InfoRow(label: 'Enfermedades relevantes', value: 'Alergia al polvo'),
            _InfoRow(label: 'Lengua materna', value: 'Español'),

            const SizedBox(height: AppSpacing.lg),
            // Botones de acción
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppButton(
                  label: 'Añadir Imagen',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('La gestión de imágenes se implementará en una fase posterior.'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                AppButton(
                  label: 'Registrar Actividad',
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.createActivity,
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                AppButton(
                  label: 'Editar Ficha',
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.createPatient,
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // Sección Evaluación / Ejercicios
            const Text(
              'Datos Evaluación / Ejercicios',
              style: AppTextStyles.title,
            ),
            const SizedBox(height: AppSpacing.md),

            _ExerciseCard(title: 'Pronunciación', subtitle: 'Fonética. Control al hablar.'),
            _ExerciseCard(title: 'Juego de rimas', subtitle: 'Rimas, palabras y sílabas.'),
            _ExerciseCard(title: 'Memorización', subtitle: 'Agilidad mental. Recuerda.'),
            _ExerciseCard(title: 'Secuencias', subtitle: 'Ordena imágenes y/o palabras.'),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: AppTextStyles.body,
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const _ExerciseCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
          children: [
            const Icon(Icons.check_circle_outline),
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
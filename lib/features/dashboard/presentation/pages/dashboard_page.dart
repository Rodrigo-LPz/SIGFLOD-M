import 'package:flutter/material.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../activities/data/repositories/activity_memory_repository.dart';
import '../../../activities/domain/models/activity_model.dart';
import '../../../activities/presentation/pages/create_activity_page.dart';
import '../../../patients/data/repositories/patient_memory_repository.dart';
import '../../../patients/presentation/pages/patient_detail_page.dart';
import '../../../templates/data/repositories/template_memory_repository.dart';
import '../../../templates/domain/models/template_model.dart';


class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  // 🔹 Repositorio compartido de actividades
  static final ActivityMemoryRepository _activityRepository =
      ActivityMemoryRepository.instance;

  // 🔹 Repositorio compartido de pacientes
  static final PatientMemoryRepository _patientRepository = PatientMemoryRepository.instance;

  // 🔹 Repositorio compartido de plantillas
  static final TemplateMemoryRepository _templateRepository = TemplateMemoryRepository.instance;

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
              'Accesos rápidos',
              style: AppTextStyles.title,
            ),

            const SizedBox(height: AppSpacing.md),

            AppButton(
              label: 'Mis Pacientes',
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.patientsList,
                );
              },
            ),

            const SizedBox(height: AppSpacing.sm),

            AppButton(
              label: 'Plantillas',
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.templates,
                );
              },
            ),

            const SizedBox(height: AppSpacing.sm),

            AppButton(
              label: 'Nueva Actividad',
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.createActivity,
                );
              },
            ),

            const SizedBox(height: AppSpacing.xl),

            const Text(
              'Actividades Recomendadas',
              style: AppTextStyles.title,
            ),

            const SizedBox(height: AppSpacing.md),

            ValueListenableBuilder<List<TemplateModel>>(
              valueListenable: _templateRepository.templates,
              builder: (context, templates, _) {
                final recommendedTemplates = templates.take(4).toList();

                if (recommendedTemplates.isEmpty) {
                  return const Text(
                    'Todavía no hay plantillas disponibles.',
                    style: AppTextStyles.bodySecondary,
                  );
                }

                return Column(
                  children: recommendedTemplates.map((template) {
                    return _ActivityCard(
                      template: template,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateActivityPage(
                              initialTemplate: template,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: AppSpacing.xl),

            const Text(
              'Últimos Progresos',
              style: AppTextStyles.title,
            ),

            const SizedBox(height: AppSpacing.sm),

            ValueListenableBuilder<List<ActivityModel>>(
              valueListenable: _activityRepository.activities,
              builder: (context, activities, _) {
                final recentActivities = _activityRepository
                    .getRecentActivities()
                    .take(5)
                    .toList();

                if (recentActivities.isEmpty) {
                  return const Text(
                    'Todavía no hay actividades registradas.',
                    style: AppTextStyles.bodySecondary,
                  );
                }

                return Column(
                  children: recentActivities.map((activity) {
                    final patient = _patientRepository.getById(activity.patientId);

                    return _ProgressTile(
                      name: activity.patientName,
                      detail: '${activity.templateName} · ${_formatDate(activity.createdAt)}',
                      onTap: patient == null
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PatientDetailPage(
                                    patient: patient,
                                  ),
                                ),
                              );
                            },
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  static String _formatDate(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString();

    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$day/$month/$year - $hour:$minute';
  }
}

class _ActivityCard extends StatelessWidget {
  final TemplateModel template;
  final VoidCallback onTap;

  const _ActivityCard({
    required this.template,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AppCard(
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
                    template.name,
                    style: AppTextStyles.body,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    template.objective,
                    style: AppTextStyles.bodySecondary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressTile extends StatelessWidget {
  final String name;
  final String detail;
  final VoidCallback? onTap;

  const _ProgressTile({
    required this.name,
    required this.detail,
    this.onTap,
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
      onTap: onTap,
    );
  }
}
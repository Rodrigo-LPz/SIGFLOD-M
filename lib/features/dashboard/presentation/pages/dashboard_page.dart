import 'package:flutter/material.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/session_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/patient_avatar.dart';
import '../../../activities/data/repositories/activity_firestore_repository.dart';
import '../../../activities/domain/models/activity_model.dart';
import '../../../activities/presentation/pages/create_activity_page.dart';
import '../../../patients/data/repositories/patient_firestore_repository.dart';
import '../../../patients/domain/models/patient_model.dart';
import '../../../patients/presentation/pages/patient_detail_page.dart';
import '../../../templates/data/repositories/template_firestore_repository.dart';
import '../../../templates/domain/models/template_model.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static final ActivityFirestoreRepository _activityRepository =
      ActivityFirestoreRepository.instance;
  static final PatientFirestoreRepository _patientRepository =
      PatientFirestoreRepository.instance;
  static final TemplateFirestoreRepository _templateRepository =
      TemplateFirestoreRepository.instance;

  static PatientModel? _findPatient(String patientId) {
    try {
      return _patientRepository.patients.value.firstWhere(
        (p) => p.id == patientId,
      );
    } catch (_) {
      return null;
    }
  }

  static String _formatAppointmentDate(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final y = dt.year.toString();
    return '$d/$m/$y';
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.appSubtitle),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: t.logoutTooltip,
            onPressed: () async {
              await AuthService.instance.signOut();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: ListView(
          children: [
            const SizedBox(height: AppSpacing.sm),

            Text(t.welcome, style: AppTextStyles.headline),

            const SizedBox(height: AppSpacing.xl),

            Text(t.quickAccess, style: AppTextStyles.title),
            const SizedBox(height: AppSpacing.md),

            AppButton(
              label: t.myPatients,
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.patientsList),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppButton(
              label: t.templates,
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.templates),
            ),
            // Solo el logopeda puede crear nuevas actividades.
            if (SessionService.instance.canWrite) ...[
              const SizedBox(height: AppSpacing.sm),
              AppButton(
                label: t.newActivity,
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.createActivity),
              ),
            ],

            const SizedBox(height: AppSpacing.xl),

            Text(t.recommendedActivities, style: AppTextStyles.title),
            const SizedBox(height: AppSpacing.md),

            ValueListenableBuilder<List<TemplateModel>>(
              valueListenable: _templateRepository.templates,
              builder: (context, templates, _) {
                final recommended = templates.take(4).toList();

                if (recommended.isEmpty) {
                  return Text(
                    t.noTemplatesAvailable,
                    style: AppTextStyles.bodySecondary,
                  );
                }

                return Column(
                  children: recommended.map((template) {
                    return _ActivityCard(
                      template: template,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CreateActivityPage(initialTemplate: template),
                          ),
                        );
                      },
                    );
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: AppSpacing.xl),

            Text(t.latestProgress, style: AppTextStyles.title),
            const SizedBox(height: AppSpacing.sm),

            // Escucha tanto las actividades como la lista de pacientes para refrescar avatares.
            ValueListenableBuilder<List<PatientModel>>(
              valueListenable: _patientRepository.patients,
              builder: (context, patients, child) {
                return ValueListenableBuilder<List<ActivityModel>>(
                  valueListenable: _activityRepository.activities,
                  builder: (context, activities, _) {
                    final recent = _activityRepository
                        .getRecentActivities()
                        .take(5)
                        .toList();

                    if (recent.isEmpty) {
                      return Text(
                        t.noActivitiesYet,
                        style: AppTextStyles.bodySecondary,
                      );
                    }

                    return Column(
                      children: recent.map((activity) {
                        final patient = _findPatient(activity.patientId);

                        final schedule =
                            '${_formatAppointmentDate(activity.appointmentDate)} · ${activity.startTime} - ${activity.endTime}';

                        final label = activity.attended
                            ? '${activity.templateName} · $schedule'
                            : '${t.absentBadge} · $schedule';

                        return _ProgressTile(
                          patient: patient,
                          name: activity.patientName,
                          detail: label,
                          onTap: patient == null
                              ? null
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PatientDetailPage(patient: patient),
                                    ),
                                  );
                                },
                        );
                      }).toList(),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final TemplateModel template;
  final VoidCallback onTap;

  const _ActivityCard({required this.template, required this.onTap});

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
                  Text(template.name, style: AppTextStyles.body),
                  const SizedBox(height: AppSpacing.xs),
                  Text(template.objective, style: AppTextStyles.bodySecondary),
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
  final PatientModel? patient;
  final String name;
  final String detail;
  final VoidCallback? onTap;

  const _ProgressTile({
    required this.patient,
    required this.name,
    required this.detail,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: patient == null
          ? const CircleAvatar(child: Icon(Icons.person))
          : PatientAvatar(patient: patient!, radius: 20),
      title: Text(name, style: AppTextStyles.body),
      subtitle: Text(detail, style: AppTextStyles.bodySecondary),
      onTap: onTap,
    );
  }
}

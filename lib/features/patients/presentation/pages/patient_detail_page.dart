import 'package:flutter/material.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../activities/data/repositories/activity_memory_repository.dart';
import '../../../activities/domain/models/activity_model.dart';
import '../../../activities/presentation/pages/create_activity_page.dart';
import '../../domain/models/patient_model.dart';
import 'create_patient_page.dart';


// 🔹 Pantalla de detalle real del paciente
class PatientDetailPage extends StatefulWidget {
  final PatientModel patient;

  const PatientDetailPage({
    super.key,
    required this.patient,
  });

  @override
  State<PatientDetailPage> createState() => _PatientDetailPageState();
}

class _PatientDetailPageState extends State<PatientDetailPage> {
  // 🔹 Paciente actual mostrado en pantalla
  late PatientModel _patient;

  // 🔹 Repositorio compartido de actividades en memoria
  final ActivityMemoryRepository _activityRepository =
      ActivityMemoryRepository.instance;

  @override
  void initState() {
    super.initState();
    _patient = widget.patient;
  }

  // 🔹 Abre la edición del paciente y actualiza la ficha al volver
  Future<void> _editPatient() async {
    final result = await Navigator.push<PatientModel>(
      context,
      MaterialPageRoute(
        builder: (context) => CreatePatientPage(
          initialPatient: _patient,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _patient = result;
      });
    }
  }

  // 🔹 Abre el registro de actividad con este paciente ya preseleccionado
  Future<void> _openCreateActivity() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateActivityPage(
          initialPatient: _patient,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final diagnosis = _patient.diagnosis.isNotEmpty
        ? _patient.diagnosis
        : 'Sin diagnóstico inicial';

    final observations = _patient.observations.isNotEmpty
        ? _patient.observations
        : 'Sin observaciones registradas';

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _patient);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ficha del Paciente'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: ListView(
            children: [
              // 🔹 Nombre completo del paciente
              Text(
                _patient.fullName,
                style: AppTextStyles.headline,
              ),
              const SizedBox(height: AppSpacing.md),

              // 🔹 Información básica real del paciente
              _InfoRow(
                label: 'Fecha de Nacimiento',
                value: _patient.birthDate,
              ),
              _InfoRow(
                label: 'Diagnóstico inicial',
                value: diagnosis,
              ),
              _InfoRow(
                label: 'Observaciones',
                value: observations,
              ),

              const SizedBox(height: AppSpacing.lg),

              // 🔹 Botones de acción
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppButton(
                    label: 'Añadir Imagen',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'La gestión de imágenes se implementará en una fase posterior.',
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppButton(
                    label: 'Registrar Actividad',
                    onPressed: _openCreateActivity,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppButton(
                    label: 'Editar Ficha',
                    onPressed: _editPatient,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // 🔹 Historial real de actividades del paciente
              const Text(
                'Historial de Actividades',
                style: AppTextStyles.title,
              ),
              const SizedBox(height: AppSpacing.md),

              ValueListenableBuilder<List<ActivityModel>>(
                valueListenable: _activityRepository.activities,
                builder: (context, activities, _) {
                  final patientActivities = activities
                      .where((activity) => activity.patientId == _patient.id)
                      .toList();

                  if (patientActivities.isEmpty) {
                    return const Text(
                      'Este paciente todavía no tiene actividades registradas.',
                      style: AppTextStyles.bodySecondary,
                    );
                  }

                  return Column(
                    children: patientActivities
                        .map(
                          (activity) => _PatientActivityCard(
                            activity: activity,
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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

class _PatientActivityCard extends StatelessWidget {
  final ActivityModel activity;

  const _PatientActivityCard({
    required this.activity,
  });

  String _formatDate(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString();

    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$day/$month/$year - $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final detail =
        'Repeticiones: ${activity.repetitions} · Tiempo: ${activity.timeLimitMinutes} min · Guiado: ${activity.guidedMode ? 'Sí' : 'No'}';

    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.assignment_turned_in_outlined),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.templateName,
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  detail,
                  style: AppTextStyles.bodySecondary,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _formatDate(activity.createdAt),
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
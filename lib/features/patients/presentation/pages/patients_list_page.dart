import 'package:flutter/material.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../domain/models/patient_model.dart';
import '../../data/repositories/patient_memory_repository.dart';
import 'patient_detail_page.dart';


// 🔹 Pantalla reutilizable de listado de pacientes
class PatientsListPage extends StatefulWidget {
  // 🔹 Si es true, la pantalla funciona como selector y devuelve un paciente
  final bool selectionMode;

  const PatientsListPage({
    super.key,
    this.selectionMode = false,
  });

  @override
  State<PatientsListPage> createState() => _PatientsListPageState();
}

class _PatientsListPageState extends State<PatientsListPage> {
  // 🔹 Repositorio compartido de pacientes en memoria
  final PatientMemoryRepository _patientRepository = PatientMemoryRepository.instance;

  // 🔹 Abre el formulario y recoge el paciente devuelto
  Future<void> _openCreatePatient() async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.createPatient,
    );

    if (result is PatientModel) {
      _patientRepository.addPatient(result);
    }
  }

  // 🔹 Abre el detalle y, si vuelve editado, actualiza el paciente en memoria
  Future<void> _openPatientDetail(PatientModel patient) async {
    final result = await Navigator.push<PatientModel>(
      context,
      MaterialPageRoute(
        builder: (context) => PatientDetailPage(
          patient: patient,
        ),
      ),
    );

    if (result != null) {
      _patientRepository.updatePatient(result);
    }
  }

  // 🔹 Decide qué hacer al pulsar un paciente según el modo de la pantalla
  void _handlePatientTap(PatientModel patient) {
    if (widget.selectionMode) {
      Navigator.pop(context, patient);
      return;
    }

    _openPatientDetail(patient);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.selectionMode
              ? 'Seleccionar Paciente'
              : 'Lista de Pacientes',
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            // 🔹 Solo mostramos el botón de alta en el modo normal
            if (!widget.selectionMode) ...[
              AppButton(
                label: 'Añadir Paciente',
                onPressed: _openCreatePatient,
              ),
              const SizedBox(height: AppSpacing.md),
            ],

            // 🔹 Buscador (de momento solo visual)
            const AppTextField(
              label: 'Buscar paciente',
              hint: 'Buscar paciente...',
            ),

            const SizedBox(height: AppSpacing.md),

            // 🔹 Lista en memoria de pacientes
            Expanded(
              child: ValueListenableBuilder<List<PatientModel>>(
                valueListenable: _patientRepository.patients,
                builder: (context, patients, _) {
                  return ListView.builder(
                    itemCount: patients.length,
                    itemBuilder: (context, index) {
                      final patient = patients[index];

                      return _PatientCard(
                        patient: patient,
                        onTap: () => _handlePatientTap(patient),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PatientCard extends StatelessWidget {
  final PatientModel patient;
  final VoidCallback onTap;

  const _PatientCard({
    required this.patient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final detail = patient.diagnosis.isNotEmpty
        ? '${patient.birthDate} / ${patient.diagnosis}'
        : '${patient.birthDate} / Sin diagnóstico inicial';

    return GestureDetector(
      onTap: onTap,
      child: AppCard(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 25,
              child: Icon(Icons.person),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient.fullName,
                    style: AppTextStyles.body,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    detail,
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
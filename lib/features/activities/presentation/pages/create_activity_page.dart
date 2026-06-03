import 'package:flutter/material.dart';

import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../data/repositories/activity_firestore_repository.dart';
import '../../domain/models/activity_model.dart';
import '../../../patients/domain/models/patient_model.dart';
import '../../../patients/presentation/pages/patients_list_page.dart';
import '../../../templates/domain/models/template_model.dart';
import '../../../templates/presentation/pages/templates_page.dart';

// Pantalla de configuración y registro de una nueva actividad.
class CreateActivityPage extends StatefulWidget {
  // Paciente preseleccionado si se llega desde la ficha del paciente.
  final PatientModel? initialPatient;

  // Plantilla preseleccionada si se llega desde el dashboard o las plantillas.
  final TemplateModel? initialTemplate;

  const CreateActivityPage({
    super.key,
    this.initialPatient,
    this.initialTemplate,
  });

  @override
  State<CreateActivityPage> createState() => _CreateActivityPageState();
}

class _CreateActivityPageState extends State<CreateActivityPage> {
  // Almacena el paciente actualmente seleccionado.
  PatientModel? _selectedPatient;

  // Almacena la plantilla actualmente seleccionada.
  TemplateModel? _selectedTemplate;

  // Indica si el paciente asistió finalmente a la sesión.
  bool _attended = true;

  // Almacena la fecha programada de la cita seleccionada por el logopeda.
  DateTime? _appointmentDate;

  // Almacena la hora de inicio de la cita seleccionada por el logopeda.
  TimeOfDay? _startTime;

  // Almacena la hora de fin de la cita seleccionada por el logopeda.
  TimeOfDay? _endTime;

  // TODO: MIGRACION_PLANTILLAS — Los ajustes de la actividad (repeticiones,
  // tiempo límite, modo guiado) están temporalmente fijados a valores por
  // defecto mientras se completa la migración al nuevo sistema de plantillas.
  // En el punto 5 del plan, cada tipo de plantilla tendrá su propio flujo de
  // registro de actividad con los ajustes específicos que correspondan.
  static const int _defaultRepetitions = 3;
  static const int _defaultTimeLimitMinutes = 5;
  static const bool _defaultGuidedMode = true;

  // Almacena la referencia al repositorio Firestore de actividades.
  final ActivityFirestoreRepository _activityRepository =
      ActivityFirestoreRepository.instance;

  @override
  void initState() {
    super.initState();

    // Inicializa el paciente y la plantilla con los valores recibidos si existen.
    _selectedPatient = widget.initialPatient;
    _selectedTemplate = widget.initialTemplate;
  }

  // Formatea una hora del día al formato HH:mm de dos dígitos.
  String _formatTime(TimeOfDay time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  // Formatea una fecha al formato DD/MM/YYYY para mostrarla al usuario.
  String _formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year.toString();
    return '$d/$m/$y';
  }

  // Abre el selector de pacientes y actualiza el paciente seleccionado.
  Future<void> _selectPatient() async {
    final result = await Navigator.push<PatientModel>(
      context,
      MaterialPageRoute(
        builder: (context) => const PatientsListPage(selectionMode: true),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedPatient = result;
      });
    }
  }

  // Abre el selector de plantillas y actualiza la plantilla seleccionada.
  Future<void> _selectTemplate() async {
    final result = await Navigator.push<TemplateModel>(
      context,
      MaterialPageRoute(
        builder: (context) => const TemplatesPage(selectionMode: true),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedTemplate = result;
      });
    }
  }

  // Abre el calendario para que el logopeda elija la fecha de la cita.
  Future<void> _pickAppointmentDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _appointmentDate ?? now,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 2),
    );

    if (picked != null) {
      setState(() {
        _appointmentDate = picked;
      });
    }
  }

  // Abre el selector horario para escoger la hora de inicio de la cita.
  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? const TimeOfDay(hour: 9, minute: 0),
    );

    if (picked != null) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  // Abre el selector horario para escoger la hora de fin de la cita.
  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime ?? const TimeOfDay(hour: 10, minute: 0),
    );

    if (picked != null) {
      setState(() {
        _endTime = picked;
      });
    }
  }

  // Valida, persiste la actividad o ausencia y abre la previsualización si procede.
  Future<void> _submit() async {
    final t = AppLocalizations.of(context)!;

    // Comprobaciones comunes a asistencia y ausencia.
    if (_selectedPatient == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.errorSelectPatient)));
      return;
    }

    if (_appointmentDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.errorMissingAppointmentDate)));
      return;
    }

    if (_startTime == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.errorMissingStartTime)));
      return;
    }

    if (_endTime == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.errorMissingEndTime)));
      return;
    }

    final startMinutes = _startTime!.hour * 60 + _startTime!.minute;
    final endMinutes = _endTime!.hour * 60 + _endTime!.minute;

    if (startMinutes >= endMinutes) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.errorInvalidSchedule)));
      return;
    }

    // Comprobación adicional solo cuando la sesión sí se va a realizar.
    if (_attended && _selectedTemplate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.errorSelectTemplate)));
      return;
    }

    final activity = ActivityModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      patientId: _selectedPatient!.id,
      patientName: _selectedPatient!.fullName,
      templateId: _attended ? _selectedTemplate!.id : '',
      templateName: _attended ? _selectedTemplate!.name : '',
      repetitions: _attended ? _defaultRepetitions : 0,
      timeLimitMinutes: _attended ? _defaultTimeLimitMinutes : 0,
      guidedMode: _attended ? _defaultGuidedMode : false,
      createdAt: DateTime.now(),
      attended: _attended,
      appointmentDate: _appointmentDate!,
      startTime: _formatTime(_startTime!),
      endTime: _formatTime(_endTime!),
    );

    await _activityRepository.addActivity(activity);

    if (!mounted) return;

    // Muestra el mensaje correspondiente según el tipo de registro.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _attended
              ? t.activityRegistered(activity.patientName)
              : t.absenceRegistered(activity.patientName),
        ),
      ),
    );

    // Si fue ausencia el flujo termina aquí y volvemos a la pantalla anterior.
    if (!_attended) {
      Navigator.pop(context);
      return;
    }

    // TODO: MIGRACION_PLANTILLAS — La previsualización de actividad pasará a
    // ser específica de cada tipo de plantilla en el punto 5 del plan. Por
    // ahora se delega a la pantalla placeholder de previsualización.
    Navigator.pushNamed(
      context,
      AppRoutes.templatePreview,
      arguments: {'template': _selectedTemplate, 'previewMode': 'activity'},
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.registerActivityTitle), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: ListView(
          children: [
            // Sección de selección del paciente.
            _SectionTitle(title: t.patientSection),
            const SizedBox(height: AppSpacing.sm),
            _SelectionCard(
              icon: Icons.person,
              title: _selectedPatient?.fullName ?? t.selectPatient,
              subtitle: _selectedPatient?.birthDate ?? t.noneSelectedPatient,
              onTap: _selectPatient,
            ),

            const SizedBox(height: AppSpacing.xl),

            // Sección de asistencia o ausencia del paciente a la cita.
            _SectionTitle(title: t.attendanceSection),
            const SizedBox(height: AppSpacing.sm),
            AppCard(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.sm,
                  horizontal: AppSpacing.md,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SegmentedButton<bool>(
                        segments: [
                          ButtonSegment<bool>(
                            value: true,
                            label: Text(t.attendedToggle),
                            icon: const Icon(Icons.check_circle_outline),
                          ),
                          ButtonSegment<bool>(
                            value: false,
                            label: Text(t.absentToggle),
                            icon: const Icon(Icons.cancel_outlined),
                          ),
                        ],
                        selected: {_attended},
                        onSelectionChanged: (selection) {
                          setState(() {
                            _attended = selection.first;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Sección de fecha y horario programado de la cita.
            _SectionTitle(title: t.appointmentScheduleLabel),
            const SizedBox(height: AppSpacing.sm),
            _SelectionCard(
              icon: Icons.calendar_month,
              title: t.appointmentDateLabel,
              subtitle: _appointmentDate == null
                  ? t.appointmentDateHint
                  : _formatDate(_appointmentDate!),
              onTap: _pickAppointmentDate,
            ),
            const SizedBox(height: AppSpacing.sm),
            _SelectionCard(
              icon: Icons.schedule,
              title: t.startTimeLabel,
              subtitle: _startTime == null
                  ? t.selectTimeHint
                  : _formatTime(_startTime!),
              onTap: _pickStartTime,
            ),
            const SizedBox(height: AppSpacing.sm),
            _SelectionCard(
              icon: Icons.schedule,
              title: t.endTimeLabel,
              subtitle: _endTime == null
                  ? t.selectTimeHint
                  : _formatTime(_endTime!),
              onTap: _pickEndTime,
            ),

            const SizedBox(height: AppSpacing.xl),

            // Sección de plantilla solo si el paciente asistió.
            IgnorePointer(
              ignoring: !_attended,
              child: Opacity(
                opacity: _attended ? 1.0 : 0.4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SectionTitle(title: t.templateSection),
                    const SizedBox(height: AppSpacing.sm),
                    _SelectionCard(
                      icon: Icons.description,
                      title: _selectedTemplate?.name ?? t.selectTemplate,
                      subtitle:
                          _selectedTemplate?.objective ??
                          t.noneSelectedTemplate,
                      onTap: _selectTemplate,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Persiste el registro de asistencia o ausencia en Firestore.
            AppButton(
              label: _attended ? t.startActivity : t.registerAbsence,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTextStyles.title);
  }
}

class _SelectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SelectionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title, style: AppTextStyles.body),
        subtitle: Text(subtitle, style: AppTextStyles.bodySecondary),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';

import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/services/image_service.dart';
import '../../../../core/services/locale_service.dart';
import '../../../../core/services/report_service.dart';
import '../../../../core/services/session_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/patient_avatar.dart';
import '../../../activities/data/repositories/activity_firestore_repository.dart';
import '../../../activities/domain/models/activity_model.dart';
import '../../../activities/presentation/pages/create_activity_page.dart';
import '../../../invitations/data/repositories/invitation_firestore_repository.dart';
import '../../../reports/presentation/pages/report_range_page.dart';
import '../../data/repositories/patient_firestore_repository.dart';
import '../../domain/models/patient_model.dart';
import 'create_patient_page.dart';

// Pantalla de detalle completo de un paciente.
class PatientDetailPage extends StatefulWidget {
  final PatientModel patient;

  const PatientDetailPage({super.key, required this.patient});

  @override
  State<PatientDetailPage> createState() => _PatientDetailPageState();
}

class _PatientDetailPageState extends State<PatientDetailPage> {
  // Almacena el paciente actualmente visible en pantalla.
  late PatientModel _patient;

  // Almacena la referencia al repositorio Firestore de actividades.
  final ActivityFirestoreRepository _activityRepository =
      ActivityFirestoreRepository.instance;

  @override
  void initState() {
    super.initState();
    _patient = widget.patient;
  }

  // Abre el formulario de edición y actualiza la ficha local si hubo cambios.
  Future<void> _editPatient() async {
    final result = await Navigator.push<PatientModel>(
      context,
      MaterialPageRoute(
        builder: (context) => CreatePatientPage(initialPatient: _patient),
      ),
    );

    if (result != null) {
      setState(() {
        _patient = result;
      });
    }
  }

  // Abre el registro de actividad con el paciente actual preseleccionado.
  Future<void> _openCreateActivity() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateActivityPage(initialPatient: _patient),
      ),
    );
  }

  // Genera el informe completo del paciente y abre la previsualización del PDF.
  Future<void> _exportFullReport() async {
    final activities = _activityRepository.activities.value
        .where((a) => a.patientId == _patient.id)
        .toList();

    final pdfBytes = await ReportService.instance.buildPatientReport(
      patient: _patient,
      activities: activities,
      localeCode: LocaleService.instance.currentLocale.value.languageCode,
    );

    if (!mounted) return;

    await Printing.layoutPdf(onLayout: (_) async => pdfBytes);
  }

  // Abre la pantalla de selección de rango para generar un informe parcial.
  Future<void> _exportRangeReport() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportRangePage(patient: _patient),
      ),
    );
  }

  // Genera un código de invitación único y lo muestra al logopeda para compartirlo.
  Future<void> _generateInvitationCode() async {
    final t = AppLocalizations.of(context)!;
    final currentUid = SessionService.instance.currentUser.value?.uid;

    if (currentUid == null) return;

    final invitation = await InvitationFirestoreRepository.instance
        .createInvitation(patientId: _patient.id, createdByUid: currentUid);

    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(t.invitationCodeGeneratedTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(t.invitationCodeGeneratedMessage),
              const SizedBox(height: AppSpacing.lg),
              SelectableText(
                invitation.code,
                textAlign: TextAlign.center,
                style: AppTextStyles.headline,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: invitation.code));
                if (!dialogContext.mounted) return;
                ScaffoldMessenger.of(
                  dialogContext,
                ).showSnackBar(SnackBar(content: Text(t.codeCopiedSnack)));
              },
              child: Text(t.copyCodeAction),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(t.continueAction),
            ),
          ],
        );
      },
    );
  }

  // Muestra un diálogo para elegir el origen de la nueva foto del paciente.
  Future<void> _managePatientPhoto() async {
    final t = AppLocalizations.of(context)!;
    final cameraAvailable = ImageService.instance.isCameraAvailable;

    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text(t.choosePhotoSource, style: AppTextStyles.title),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text(t.photoFromGallery),
                onTap: () => Navigator.pop(sheetContext, 'gallery'),
              ),
              if (cameraAvailable)
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined),
                  title: Text(t.photoFromCamera),
                  onTap: () => Navigator.pop(sheetContext, 'camera'),
                ),
              if (_patient.hasPhoto)
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: Text(
                    t.removePhoto,
                    style: const TextStyle(color: Colors.red),
                  ),
                  onTap: () => Navigator.pop(sheetContext, 'remove'),
                ),
            ],
          ),
        );
      },
    );

    if (choice == null) return;

    if (choice == 'remove') {
      await _confirmRemovePhoto();
      return;
    }

    final imageBytes = choice == 'gallery'
        ? await ImageService.instance.pickFromGallery()
        : await ImageService.instance.pickFromCamera();

    if (imageBytes == null) return;

    try {
      // Sube los bytes procesados al bucket de Storage y obtiene la URL pública resultante.
      final photoUrl = await ImageService.instance.uploadPatientPhoto(
        patientId: _patient.id,
        imageBytes: imageBytes,
      );

      // Guarda la URL en el documento del paciente para asociarla a su perfil.
      final updated = _patient.copyWith(photoUrl: photoUrl);
      await PatientFirestoreRepository.instance.updatePatient(updated);

      if (!mounted) return;

      setState(() {
        _patient = updated;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.photoUpdated)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.errorPhotoUploadFailed)));
    }
  }

  // Pide confirmación al usuario y elimina la foto actual del paciente.
  Future<void> _confirmRemovePhoto() async {
    final t = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(t.confirmRemovePhotoTitle),
          content: Text(t.confirmRemovePhotoMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(t.cancelAction),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(
                t.confirmAction,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    // Borra el archivo del bucket de Storage para no dejar residuos.
    await ImageService.instance.deletePatientPhoto(_patient.id);

    // Limpia la referencia de la URL en el documento del paciente.
    final updated = _patient.copyWith(clearPhoto: true);
    await PatientFirestoreRepository.instance.updatePatient(updated);

    if (!mounted) return;

    setState(() {
      _patient = updated;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(t.photoRemoved)));
  }

  // Pide confirmación al usuario y, si la da, elimina al paciente y sus actividades.
  Future<void> _confirmDeletePatient() async {
    final t = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(t.confirmDeletePatientTitle),
          content: Text(t.confirmDeletePatientMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(t.cancelAction),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(
                t.confirmAction,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    // Borra la foto del paciente del bucket para no dejar archivos huérfanos.
    if (_patient.hasPhoto) {
      await ImageService.instance.deletePatientPhoto(_patient.id);
    }

    await PatientFirestoreRepository.instance.deletePatient(_patient.id);

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(t.patientDeleted)));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final canWrite = SessionService.instance.canWrite;

    final diagnosis = _patient.diagnosis.isNotEmpty
        ? _patient.diagnosis
        : t.noInitialDiagnosis;

    final observations = _patient.observations.isNotEmpty
        ? _patient.observations
        : t.noObservations;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pop(context, _patient);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(t.patientFileTitle), centerTitle: true),
        body: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: ListView(
            children: [
              // Muestra el avatar grande del paciente centrado y con su botón.
              Center(
                child: Column(
                  children: [
                    PatientAvatar(patient: _patient, radius: 60),
                    if (canWrite) ...[
                      const SizedBox(height: AppSpacing.sm),
                      TextButton.icon(
                        onPressed: _managePatientPhoto,
                        icon: const Icon(Icons.camera_alt_outlined),
                        label: Text(
                          _patient.hasPhoto ? t.changePhoto : t.addImage,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // Muestra el nombre completo del paciente como título principal.
              Text(
                _patient.fullName,
                style: AppTextStyles.headline,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),

              // Muestra los datos clínicos del paciente.
              _InfoRow(label: t.birthDateLabel, value: _patient.birthDate),
              _InfoRow(label: t.initialDiagnosisLabel, value: diagnosis),
              _InfoRow(label: t.observationsLabel, value: observations),

              const SizedBox(height: AppSpacing.lg),

              // Botones de acción disponibles solo si el usuario tiene permisos de escritura.
              if (canWrite)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppButton(
                      label: t.registerActivity,
                      onPressed: _openCreateActivity,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppButton(
                      label: t.editPatientFile,
                      onPressed: _editPatient,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppButton(
                      label: t.exportFullReport,
                      onPressed: _exportFullReport,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppButton(
                      label: t.exportRangeReport,
                      onPressed: _exportRangeReport,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    AppButton(
                      label: t.generateInvitationCode,
                      onPressed: _generateInvitationCode,
                    ),

                    const SizedBox(height: AppSpacing.xl),
                    AppButton(
                      label: t.deletePatient,
                      onPressed: _confirmDeletePatient,
                      isDestructive: true,
                    ),
                  ],
                ),

              const SizedBox(height: AppSpacing.xl),

              // Muestra el historial de actividades registradas para este paciente.
              Text(t.activityHistory, style: AppTextStyles.title),
              const SizedBox(height: AppSpacing.md),

              ValueListenableBuilder<List<ActivityModel>>(
                valueListenable: _activityRepository.activities,
                builder: (context, activities, _) {
                  final patientActivities = activities
                      .where((a) => a.patientId == _patient.id)
                      .toList();

                  if (patientActivities.isEmpty) {
                    return Text(
                      t.noActivitiesForPatient,
                      style: AppTextStyles.bodySecondary,
                    );
                  }

                  return Column(
                    children: patientActivities
                        .map((a) => _PatientActivityCard(activity: a))
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

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: AppTextStyles.body),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _PatientActivityCard extends StatelessWidget {
  final ActivityModel activity;

  const _PatientActivityCard({required this.activity});

  String _formatDate(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final y = dt.year.toString();
    return '$d/$m/$y';
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    final schedule =
        '${_formatDate(activity.appointmentDate)} · ${activity.startTime} - ${activity.endTime}';

    final detail = activity.attended
        ? '${t.repetitionsShort}: ${activity.repetitions} · ${t.timeShort}: ${activity.timeLimitMinutes} min · ${t.guidedShort}: ${activity.guidedMode ? t.yesShort : t.noShort}'
        : null;

    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            activity.attended
                ? Icons.assignment_turned_in_outlined
                : Icons.event_busy_outlined,
            color: activity.attended ? null : Colors.red,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.attended ? t.attendedBadge : t.absentBadge,
                  style: AppTextStyles.body.copyWith(
                    color: activity.attended ? null : Colors.red,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(schedule, style: AppTextStyles.bodySecondary),
                if (activity.attended) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(activity.templateName, style: AppTextStyles.body),
                  const SizedBox(height: AppSpacing.xs),
                  if (detail != null)
                    Text(detail, style: AppTextStyles.bodySecondary),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/services/locale_service.dart';
import '../../../../core/services/report_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../activities/data/repositories/activity_firestore_repository.dart';
import '../../../patients/domain/models/patient_model.dart';

// Pantalla de selección del rango de fechas para generar un informe parcial.
class ReportRangePage extends StatefulWidget {
  final PatientModel patient;

  const ReportRangePage({super.key, required this.patient});

  @override
  State<ReportRangePage> createState() => _ReportRangePageState();
}

class _ReportRangePageState extends State<ReportRangePage> {
  // Almacena la fecha de inicio del rango seleccionado por el logopeda.
  DateTime? _rangeStart;

  // Almacena la fecha de fin del rango seleccionado por el logopeda.
  DateTime? _rangeEnd;

  // Indica si la generación del informe está en curso.
  bool _isGenerating = false;

  // Formatea una fecha al formato DD/MM/YYYY para mostrarla al usuario.
  String _formatDate(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final y = dt.year.toString();
    return '$d/$m/$y';
  }

  // Abre el calendario para escoger la fecha de inicio del rango.
  Future<void> _pickStartDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _rangeStart ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
    );

    if (picked != null) {
      setState(() {
        _rangeStart = picked;
      });
    }
  }

  // Abre el calendario para escoger la fecha de fin del rango.
  Future<void> _pickEndDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _rangeEnd ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
    );

    if (picked != null) {
      setState(() {
        _rangeEnd = picked;
      });
    }
  }

  // Valida el rango, filtra las actividades y abre la previsualización del PDF.
  Future<void> _generateReport() async {
    final t = AppLocalizations.of(context)!;

    if (_rangeStart == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.errorMissingRangeStart)));
      return;
    }

    if (_rangeEnd == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.errorMissingRangeEnd)));
      return;
    }

    if (_rangeStart!.isAfter(_rangeEnd!)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.errorInvalidRange)));
      return;
    }

    // Recupera todas las actividades del paciente desde el repositorio Firestore.
    final allActivities = ActivityFirestoreRepository.instance.activities.value
        .where((a) => a.patientId == widget.patient.id)
        .toList();

    // Filtra las actividades incluidas en el rango seleccionado.
    final startDay = DateTime(
      _rangeStart!.year,
      _rangeStart!.month,
      _rangeStart!.day,
    );
    final endDay = DateTime(
      _rangeEnd!.year,
      _rangeEnd!.month,
      _rangeEnd!.day,
      23,
      59,
      59,
    );

    final filtered = allActivities.where((a) {
      final d = a.appointmentDate;
      return !d.isBefore(startDay) && !d.isAfter(endDay);
    }).toList();

    if (filtered.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.errorNoActivitiesInRange)));
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    try {
      // Construye el PDF mediante el servicio de informes.
      final pdfBytes = await ReportService.instance.buildPatientReport(
        patient: widget.patient,
        activities: filtered,
        localeCode: LocaleService.instance.currentLocale.value.languageCode,
        rangeStart: _rangeStart,
        rangeEnd: _rangeEnd,
      );

      if (!mounted) return;

      // Abre la previsualización del PDF con opciones de impresión y descarga.
      await Printing.layoutPdf(onLayout: (_) async => pdfBytes);
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.rangeReportTitle), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: ListView(
          children: [
            // Muestra el nombre del paciente como contexto del informe.
            Text(widget.patient.fullName, style: AppTextStyles.title),
            const SizedBox(height: AppSpacing.xl),

            // Selector de la fecha de inicio del rango.
            AppCard(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(t.rangeStartLabel, style: AppTextStyles.body),
                subtitle: Text(
                  _rangeStart == null
                      ? t.rangePickHint
                      : _formatDate(_rangeStart!),
                  style: AppTextStyles.bodySecondary,
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: _pickStartDate,
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            // Selector de la fecha de fin del rango.
            AppCard(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(t.rangeEndLabel, style: AppTextStyles.body),
                subtitle: Text(
                  _rangeEnd == null ? t.rangePickHint : _formatDate(_rangeEnd!),
                  style: AppTextStyles.bodySecondary,
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: _pickEndDate,
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Botón de generación con estado de carga durante la creación del PDF.
            AppButton(
              label: t.generateReport,
              isLoading: _isGenerating,
              onPressed: _isGenerating ? null : _generateReport,
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../features/activities/domain/models/activity_model.dart';
import '../../features/patients/domain/models/patient_model.dart';

// Centraliza la construcción de los informes clínicos en formato PDF.
class ReportService {
  // Constructor privado — patrón Singleton.
  ReportService._();

  // Expone la instancia global reutilizable.
  static final ReportService instance = ReportService._();

  // Genera el documento PDF del informe a partir del paciente y sus actividades.
  Future<Uint8List> buildPatientReport({
    required PatientModel patient,
    required List<ActivityModel> activities,
    required String localeCode,
    DateTime? rangeStart,
    DateTime? rangeEnd,
  }) async {
    // Carga el logo de la aplicación para incrustarlo en la cabecera del informe.
    final logoBytes = (await rootBundle.load(
      'assets/images/sigflod_logo.png',
    )).buffer.asUint8List();
    final logoImage = pw.MemoryImage(logoBytes);

    // Carga las variantes regular y negrita de la fuente Crimson Text.
    final regularFont = pw.Font.ttf(
      await rootBundle.load(
        'assets/fonts/Crimson_Text/CrimsonText-Regular.ttf',
      ),
    );
    final boldFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Crimson_Text/CrimsonText-Bold.ttf'),
    );

    // Construye los textos del informe según el idioma activo del usuario.
    final labels = _ReportLabels.forLocale(localeCode);

    // Calcula el resumen estadístico de asistencia del paciente.
    final totalSessions = activities.length;
    final attendedSessions = activities.where((a) => a.attended).length;
    final absentSessions = totalSessions - attendedSessions;
    final attendanceRate = totalSessions == 0
        ? 0
        : ((attendedSessions / totalSessions) * 100).round();

    // Construye el PDF mediante el motor de la librería pdf.
    final document = pw.Document(
      theme: pw.ThemeData.withFont(base: regularFont, bold: boldFont),
    );

    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) =>
            _buildHeader(logoImage, labels, rangeStart, rangeEnd),
        footer: (context) => _buildFooter(labels, context),
        build: (context) => [
          _buildPatientSection(patient, labels),
          pw.SizedBox(height: 20),
          _buildSummarySection(
            labels,
            totalSessions,
            attendedSessions,
            absentSessions,
            attendanceRate,
          ),
          pw.SizedBox(height: 20),
          _buildActivitiesTable(activities, labels),
        ],
      ),
    );

    return document.save();
  }

  // Construye la cabecera con logo, título e intervalo de fechas si procede.
  pw.Widget _buildHeader(
    pw.MemoryImage logoImage,
    _ReportLabels labels,
    DateTime? rangeStart,
    DateTime? rangeEnd,
  ) {
    final generatedAt = _formatDate(DateTime.now());

    final rangeLine = (rangeStart != null && rangeEnd != null)
        ? '${labels.range}: ${_formatDate(rangeStart)} - ${_formatDate(rangeEnd)}'
        : labels.fullHistory;

    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 12),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.grey400, width: 0.5),
        ),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Image(logoImage, width: 48, height: 48),
          pw.SizedBox(width: 12),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  labels.reportTitle,
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 2),
                pw.Text(
                  '${labels.generatedOn}: $generatedAt',
                  style: const pw.TextStyle(fontSize: 10),
                ),
                pw.Text(rangeLine, style: const pw.TextStyle(fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Construye el pie con la firma del sistema y la paginación.
  pw.Widget _buildFooter(_ReportLabels labels, pw.Context context) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(color: PdfColors.grey400, width: 0.5),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(labels.signature, style: const pw.TextStyle(fontSize: 9)),
          pw.Text(
            '${context.pageNumber} / ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 9),
          ),
        ],
      ),
    );
  }

  // Construye la sección con los datos personales y clínicos del paciente.
  pw.Widget _buildPatientSection(PatientModel patient, _ReportLabels labels) {
    final diagnosis = patient.diagnosis.isNotEmpty
        ? patient.diagnosis
        : labels.notProvided;
    final observations = patient.observations.isNotEmpty
        ? patient.observations
        : labels.notProvided;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          labels.patientSection,
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 6),
        _infoRow(labels.fullName, patient.fullName),
        _infoRow(labels.birthDate, patient.birthDate),
        _infoRow(labels.diagnosis, diagnosis),
        _infoRow(labels.observations, observations),
      ],
    );
  }

  // Construye la sección con el resumen estadístico de asistencia.
  pw.Widget _buildSummarySection(
    _ReportLabels labels,
    int total,
    int attended,
    int absent,
    int rate,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          labels.summarySection,
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 6),
        _infoRow(labels.totalSessions, total.toString()),
        _infoRow(labels.attendedSessions, attended.toString()),
        _infoRow(labels.absentSessions, absent.toString()),
        _infoRow(labels.attendanceRate, '$rate%'),
      ],
    );
  }

  // Construye la tabla con el historial detallado de actividades del paciente.
  pw.Widget _buildActivitiesTable(
    List<ActivityModel> activities,
    _ReportLabels labels,
  ) {
    if (activities.isEmpty) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            labels.historySection,
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 6),
          pw.Text(labels.noActivities, style: const pw.TextStyle(fontSize: 11)),
        ],
      );
    }

    final headers = [
      labels.tableDate,
      labels.tableSchedule,
      labels.tableTemplate,
      labels.tableConfig,
      labels.tableStatus,
    ];

    final rows = activities.map((a) {
      final schedule = '${a.startTime} - ${a.endTime}';
      final config = a.attended
          ? '${labels.reps}: ${a.repetitions} · ${labels.time}: ${a.timeLimitMinutes} min'
          : '-';
      final template = a.attended ? a.templateName : '-';
      final status = a.attended ? labels.attended : labels.absent;

      return [
        _formatDate(a.appointmentDate),
        schedule,
        template,
        config,
        status,
      ];
    }).toList();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          labels.historySection,
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 6),
        pw.TableHelper.fromTextArray(
          headers: headers,
          data: rows,
          cellStyle: const pw.TextStyle(fontSize: 9),
          headerStyle: pw.TextStyle(
            fontSize: 10,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.white,
          ),
          headerDecoration: const pw.BoxDecoration(
            color: PdfColors.blueGrey700,
          ),
          cellAlignment: pw.Alignment.centerLeft,
          border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
          columnWidths: {
            0: const pw.FlexColumnWidth(1.2),
            1: const pw.FlexColumnWidth(1.4),
            2: const pw.FlexColumnWidth(1.8),
            3: const pw.FlexColumnWidth(2.0),
            4: const pw.FlexColumnWidth(1.0),
          },
        ),
      ],
    );
  }

  // Construye una fila de "etiqueta: valor" reutilizable dentro del informe.
  pw.Widget _infoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 140,
            child: pw.Text(
              '$label:',
              style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Expanded(
            child: pw.Text(value, style: const pw.TextStyle(fontSize: 11)),
          ),
        ],
      ),
    );
  }

  // Formatea una fecha al formato DD/MM/YYYY usado en el informe.
  String _formatDate(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final y = dt.year.toString();
    return '$d/$m/$y';
  }
}

// Contenedor de etiquetas traducidas para el informe.
class _ReportLabels {
  final String reportTitle;
  final String generatedOn;
  final String fullHistory;
  final String range;
  final String signature;
  final String patientSection;
  final String summarySection;
  final String historySection;
  final String fullName;
  final String birthDate;
  final String diagnosis;
  final String observations;
  final String notProvided;
  final String totalSessions;
  final String attendedSessions;
  final String absentSessions;
  final String attendanceRate;
  final String noActivities;
  final String tableDate;
  final String tableSchedule;
  final String tableTemplate;
  final String tableConfig;
  final String tableStatus;
  final String attended;
  final String absent;
  final String reps;
  final String time;

  const _ReportLabels({
    required this.reportTitle,
    required this.generatedOn,
    required this.fullHistory,
    required this.range,
    required this.signature,
    required this.patientSection,
    required this.summarySection,
    required this.historySection,
    required this.fullName,
    required this.birthDate,
    required this.diagnosis,
    required this.observations,
    required this.notProvided,
    required this.totalSessions,
    required this.attendedSessions,
    required this.absentSessions,
    required this.attendanceRate,
    required this.noActivities,
    required this.tableDate,
    required this.tableSchedule,
    required this.tableTemplate,
    required this.tableConfig,
    required this.tableStatus,
    required this.attended,
    required this.absent,
    required this.reps,
    required this.time,
  });

  // Devuelve el conjunto de etiquetas adecuado al idioma activo de la app.
  factory _ReportLabels.forLocale(String code) {
    if (code == 'en') {
      return const _ReportLabels(
        reportTitle: 'Speech Therapy Report',
        generatedOn: 'Generated on',
        fullHistory: 'Full history',
        range: 'Range',
        signature: 'Generated by SIGFLOD — Rodrigo López',
        patientSection: 'Patient information',
        summarySection: 'Attendance summary',
        historySection: 'Activity history',
        fullName: 'Full name',
        birthDate: 'Date of birth',
        diagnosis: 'Initial diagnosis',
        observations: 'Observations',
        notProvided: 'Not provided',
        totalSessions: 'Total sessions',
        attendedSessions: 'Attended sessions',
        absentSessions: 'Absent sessions',
        attendanceRate: 'Attendance rate',
        noActivities: 'No activities recorded for this patient.',
        tableDate: 'Date',
        tableSchedule: 'Schedule',
        tableTemplate: 'Template',
        tableConfig: 'Configuration',
        tableStatus: 'Status',
        attended: 'Attended',
        absent: 'Absent',
        reps: 'Reps',
        time: 'Time',
      );
    }

    return const _ReportLabels(
      reportTitle: 'Informe Logopedico',
      generatedOn: 'Generado el',
      fullHistory: 'Historial completo',
      range: 'Rango',
      signature: 'Generado por SIGFLOD - Rodrigo Lopez',
      patientSection: 'Datos del paciente',
      summarySection: 'Resumen de asistencia',
      historySection: 'Historial de actividades',
      fullName: 'Nombre completo',
      birthDate: 'Fecha de nacimiento',
      diagnosis: 'Diagnostico inicial',
      observations: 'Observaciones',
      notProvided: 'No indicado',
      totalSessions: 'Total de sesiones',
      attendedSessions: 'Sesiones asistidas',
      absentSessions: 'Sesiones ausentes',
      attendanceRate: 'Tasa de asistencia',
      noActivities: 'No hay actividades registradas para este paciente.',
      tableDate: 'Fecha',
      tableSchedule: 'Horario',
      tableTemplate: 'Plantilla',
      tableConfig: 'Configuracion',
      tableStatus: 'Estado',
      attended: 'Asistio',
      absent: 'Ausente',
      reps: 'Reps',
      time: 'Tiempo',
    );
  }
}

class ActivityModel {
  final String id;
  final String patientId;
  final String patientName;
  final String templateId;
  final String templateName;
  final int repetitions;
  final int timeLimitMinutes;
  final bool guidedMode;
  final DateTime createdAt;

  // Indica si el paciente asistió finalmente a la sesión registrada.
  final bool attended;

  // Fecha en la que estaba programada o se realizó la sesión.
  final DateTime appointmentDate;

  // Hora de inicio programada en formato HH:mm.
  final String startTime;

  // Hora de fin programada en formato HH:mm.
  final String endTime;

  const ActivityModel({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.templateId,
    required this.templateName,
    required this.repetitions,
    required this.timeLimitMinutes,
    required this.guidedMode,
    required this.createdAt,
    required this.attended,
    required this.appointmentDate,
    required this.startTime,
    required this.endTime,
  });

  ActivityModel copyWith({
    String? id,
    String? patientId,
    String? patientName,
    String? templateId,
    String? templateName,
    int? repetitions,
    int? timeLimitMinutes,
    bool? guidedMode,
    DateTime? createdAt,
    bool? attended,
    DateTime? appointmentDate,
    String? startTime,
    String? endTime,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      templateId: templateId ?? this.templateId,
      templateName: templateName ?? this.templateName,
      repetitions: repetitions ?? this.repetitions,
      timeLimitMinutes: timeLimitMinutes ?? this.timeLimitMinutes,
      guidedMode: guidedMode ?? this.guidedMode,
      createdAt: createdAt ?? this.createdAt,
      attended: attended ?? this.attended,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  // Serializa el modelo a un mapa compatible con Firestore.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientId': patientId,
      'patientName': patientName,
      'templateId': templateId,
      'templateName': templateName,
      'repetitions': repetitions,
      'timeLimitMinutes': timeLimitMinutes,
      'guidedMode': guidedMode,
      'createdAt': createdAt.toIso8601String(),
      'attended': attended,
      'appointmentDate': appointmentDate.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  // Reconstruye el modelo a partir de un mapa procedente de Firestore.
  factory ActivityModel.fromMap(Map<String, dynamic> map) {
    return ActivityModel(
      id: map['id'] ?? '',
      patientId: map['patientId'] ?? '',
      patientName: map['patientName'] ?? '',
      templateId: map['templateId'] ?? '',
      templateName: map['templateName'] ?? '',
      repetitions: map['repetitions'] ?? 3,
      timeLimitMinutes: map['timeLimitMinutes'] ?? 5,
      guidedMode: map['guidedMode'] ?? true,
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      attended: map['attended'] ?? true,
      appointmentDate:
          DateTime.tryParse(map['appointmentDate'] ?? '') ?? DateTime.now(),
      startTime: map['startTime'] ?? '',
      endTime: map['endTime'] ?? '',
    );
  }
}

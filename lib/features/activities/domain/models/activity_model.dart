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
    );
  }

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
    };
  }

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
    );
  }
}
class TemplateModel {
  final String id;
  final String type;
  final String name;
  final String objective;
  final String recommendedAge;
  final String level;
  final String observations;
  final List<String> words;
  final int repetitions;
  final int timeLimitMinutes;
  final bool guidedMode;
  final bool soundsEnabled;
  final bool feedbackEnabled;
  final bool positiveReinforcementEnabled;

  const TemplateModel({
    required this.id,
    required this.type,
    required this.name,
    required this.objective,
    required this.recommendedAge,
    required this.level,
    required this.observations,
    required this.words,
    required this.repetitions,
    required this.timeLimitMinutes,
    required this.guidedMode,
    required this.soundsEnabled,
    required this.feedbackEnabled,
    required this.positiveReinforcementEnabled,
  });

  TemplateModel copyWith({
    String? id,
    String? type,
    String? name,
    String? objective,
    String? recommendedAge,
    String? level,
    String? observations,
    List<String>? words,
    int? repetitions,
    int? timeLimitMinutes,
    bool? guidedMode,
    bool? soundsEnabled,
    bool? feedbackEnabled,
    bool? positiveReinforcementEnabled,
  }) {
    return TemplateModel(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      objective: objective ?? this.objective,
      recommendedAge: recommendedAge ?? this.recommendedAge,
      level: level ?? this.level,
      observations: observations ?? this.observations,
      words: words ?? this.words,
      repetitions: repetitions ?? this.repetitions,
      timeLimitMinutes: timeLimitMinutes ?? this.timeLimitMinutes,
      guidedMode: guidedMode ?? this.guidedMode,
      soundsEnabled: soundsEnabled ?? this.soundsEnabled,
      feedbackEnabled: feedbackEnabled ?? this.feedbackEnabled,
      positiveReinforcementEnabled:
          positiveReinforcementEnabled ?? this.positiveReinforcementEnabled,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'objective': objective,
      'recommendedAge': recommendedAge,
      'level': level,
      'observations': observations,
      'words': words,
      'repetitions': repetitions,
      'timeLimitMinutes': timeLimitMinutes,
      'guidedMode': guidedMode,
      'soundsEnabled': soundsEnabled,
      'feedbackEnabled': feedbackEnabled,
      'positiveReinforcementEnabled': positiveReinforcementEnabled,
    };
  }

  factory TemplateModel.fromMap(Map<String, dynamic> map) {
    return TemplateModel(
      id: map['id'] ?? '',
      type: map['type'] ?? '',
      name: map['name'] ?? '',
      objective: map['objective'] ?? '',
      recommendedAge: map['recommendedAge'] ?? '',
      level: map['level'] ?? '',
      observations: map['observations'] ?? '',
      words: List<String>.from(map['words'] ?? const []),
      repetitions: map['repetitions'] ?? 3,
      timeLimitMinutes: map['timeLimitMinutes'] ?? 3,
      guidedMode: map['guidedMode'] ?? true,
      soundsEnabled: map['soundsEnabled'] ?? true,
      feedbackEnabled: map['feedbackEnabled'] ?? true,
      positiveReinforcementEnabled:
          map['positiveReinforcementEnabled'] ?? true,
    );
  }
}
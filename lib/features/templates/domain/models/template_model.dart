import 'items/comprehension_block.dart';
import 'items/custom_item.dart';
import 'items/motor_praxia.dart';
import 'items/phoneme_item.dart';
import 'items/sequence_step.dart';
import 'items/vocabulary_item.dart';
import 'template_enums.dart';

// Contrato común a todas las plantillas del sistema.
// Cada subtipo concreto añade sus propios campos específicos y sus propios ajustes funcionales, pero todos comparten los campos administrativos definidos aquí.
sealed class TemplateModel {
  final String id;
  final TemplateType type;
  final String name;
  final String objective;
  final String recommendedAge;
  final TemplateLevel level;
  final String observations;
  final DateTime createdAt;

  const TemplateModel({
    required this.id,
    required this.type,
    required this.name,
    required this.objective,
    required this.recommendedAge,
    required this.level,
    required this.observations,
    required this.createdAt,
  });

  // Serializa la parte común a un mapa para almacenar en Firestore.
  Map<String, dynamic> baseToMap() {
    return {
      'id': id,
      'type': type.code,
      'name': name,
      'objective': objective,
      'recommendedAge': recommendedAge,
      'level': level.code,
      'observations': observations,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Convierte el modelo completo (campos comunes + específicos) en un mapa.
  // Cada subtipo concreto sobreescribe este método para añadir su propio bloque `content` con los campos específicos del tipo.
  Map<String, dynamic> toMap();

  // Reconstruye la plantilla correcta a partir de un mapa de Firestore.
  // Inspecciona el campo `type` y delega la deserialización al subtipo adecuado, garantizando type safety en el resto de la aplicación.
  factory TemplateModel.fromMap(Map<String, dynamic> map) {
    final type = TemplateTypeMapper.fromCode(map['type'] as String?);
    switch (type) {
      case TemplateType.phonemes:
        return PhonemeTemplate.fromMap(map);
      case TemplateType.motor:
        return MotorTemplate.fromMap(map);
      case TemplateType.comprehension:
        return ComprehensionTemplate.fromMap(map);
      case TemplateType.vocabulary:
        return VocabularyTemplate.fromMap(map);
      case TemplateType.sequences:
        return SequenceTemplate.fromMap(map);
      case TemplateType.custom:
        return CustomTemplate.fromMap(map);
      case TemplateType.unknown:
        // Caso defensivo: si Firestore devolviera un tipo desconocido, se reconstruye como plantilla Personalizada vacía.
        return CustomTemplate.fromMap(map);
    }
  }
}

// Plantilla de Fonemas / Pronunciación.
class PhonemeTemplate extends TemplateModel {
  final String targetPhoneme;
  final PhonemeType phonemeType;
  final List<PhonemeItem> items;
  final int repetitions;
  final bool guidedMode;
  final bool soundsEnabled;
  final bool feedbackEnabled;
  final bool positiveReinforcementEnabled;

  const PhonemeTemplate({
    required super.id,
    required super.name,
    required super.objective,
    required super.recommendedAge,
    required super.level,
    required super.observations,
    required super.createdAt,
    required this.targetPhoneme,
    required this.phonemeType,
    required this.items,
    required this.repetitions,
    required this.guidedMode,
    required this.soundsEnabled,
    required this.feedbackEnabled,
    required this.positiveReinforcementEnabled,
  }) : super(type: TemplateType.phonemes);

  PhonemeTemplate copyWith({
    String? id,
    String? name,
    String? objective,
    String? recommendedAge,
    TemplateLevel? level,
    String? observations,
    DateTime? createdAt,
    String? targetPhoneme,
    PhonemeType? phonemeType,
    List<PhonemeItem>? items,
    int? repetitions,
    bool? guidedMode,
    bool? soundsEnabled,
    bool? feedbackEnabled,
    bool? positiveReinforcementEnabled,
  }) {
    return PhonemeTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      objective: objective ?? this.objective,
      recommendedAge: recommendedAge ?? this.recommendedAge,
      level: level ?? this.level,
      observations: observations ?? this.observations,
      createdAt: createdAt ?? this.createdAt,
      targetPhoneme: targetPhoneme ?? this.targetPhoneme,
      phonemeType: phonemeType ?? this.phonemeType,
      items: items ?? this.items,
      repetitions: repetitions ?? this.repetitions,
      guidedMode: guidedMode ?? this.guidedMode,
      soundsEnabled: soundsEnabled ?? this.soundsEnabled,
      feedbackEnabled: feedbackEnabled ?? this.feedbackEnabled,
      positiveReinforcementEnabled:
          positiveReinforcementEnabled ?? this.positiveReinforcementEnabled,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...baseToMap(),
      'content': {
        'targetPhoneme': targetPhoneme,
        'phonemeType': phonemeType.code,
        'items': items.map((i) => i.toMap()).toList(),
        'repetitions': repetitions,
        'guidedMode': guidedMode,
        'soundsEnabled': soundsEnabled,
        'feedbackEnabled': feedbackEnabled,
        'positiveReinforcementEnabled': positiveReinforcementEnabled,
      },
    };
  }

  factory PhonemeTemplate.fromMap(Map<String, dynamic> map) {
    final content = Map<String, dynamic>.from(map['content'] ?? const {});
    return PhonemeTemplate(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      objective: map['objective'] ?? '',
      recommendedAge: map['recommendedAge'] ?? '',
      level: TemplateLevelMapper.fromCode(map['level'] as String?),
      observations: map['observations'] ?? '',
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      targetPhoneme: content['targetPhoneme'] ?? '',
      phonemeType: PhonemeTypeMapper.fromCode(
        content['phonemeType'] as String?,
      ),
      items: ((content['items'] as List?) ?? const [])
          .map((i) => PhonemeItem.fromMap(Map<String, dynamic>.from(i)))
          .toList(),
      repetitions: content['repetitions'] ?? 3,
      guidedMode: content['guidedMode'] ?? true,
      soundsEnabled: content['soundsEnabled'] ?? true,
      feedbackEnabled: content['feedbackEnabled'] ?? true,
      positiveReinforcementEnabled:
          content['positiveReinforcementEnabled'] ?? true,
    );
  }
}

// Plantilla Motora (praxias bucofonatorias).
class MotorTemplate extends TemplateModel {
  final bool useMirror;
  final List<MotorPraxia> praxias;

  const MotorTemplate({
    required super.id,
    required super.name,
    required super.objective,
    required super.recommendedAge,
    required super.level,
    required super.observations,
    required super.createdAt,
    required this.useMirror,
    required this.praxias,
  }) : super(type: TemplateType.motor);

  MotorTemplate copyWith({
    String? id,
    String? name,
    String? objective,
    String? recommendedAge,
    TemplateLevel? level,
    String? observations,
    DateTime? createdAt,
    bool? useMirror,
    List<MotorPraxia>? praxias,
  }) {
    return MotorTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      objective: objective ?? this.objective,
      recommendedAge: recommendedAge ?? this.recommendedAge,
      level: level ?? this.level,
      observations: observations ?? this.observations,
      createdAt: createdAt ?? this.createdAt,
      useMirror: useMirror ?? this.useMirror,
      praxias: praxias ?? this.praxias,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...baseToMap(),
      'content': {
        'useMirror': useMirror,
        'praxias': praxias.map((p) => p.toMap()).toList(),
      },
    };
  }

  factory MotorTemplate.fromMap(Map<String, dynamic> map) {
    final content = Map<String, dynamic>.from(map['content'] ?? const {});
    return MotorTemplate(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      objective: map['objective'] ?? '',
      recommendedAge: map['recommendedAge'] ?? '',
      level: TemplateLevelMapper.fromCode(map['level'] as String?),
      observations: map['observations'] ?? '',
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      useMirror: content['useMirror'] ?? true,
      praxias: ((content['praxias'] as List?) ?? const [])
          .map((p) => MotorPraxia.fromMap(Map<String, dynamic>.from(p)))
          .toList(),
    );
  }
}

// Plantilla de Comprensión.
class ComprehensionTemplate extends TemplateModel {
  final ComprehensionModality modality;
  final List<ComprehensionBlock> blocks;
  final int timeLimitMinutes;
  final bool guidedMode;
  final bool feedbackEnabled;
  final bool positiveReinforcementEnabled;

  const ComprehensionTemplate({
    required super.id,
    required super.name,
    required super.objective,
    required super.recommendedAge,
    required super.level,
    required super.observations,
    required super.createdAt,
    required this.modality,
    required this.blocks,
    required this.timeLimitMinutes,
    required this.guidedMode,
    required this.feedbackEnabled,
    required this.positiveReinforcementEnabled,
  }) : super(type: TemplateType.comprehension);

  ComprehensionTemplate copyWith({
    String? id,
    String? name,
    String? objective,
    String? recommendedAge,
    TemplateLevel? level,
    String? observations,
    DateTime? createdAt,
    ComprehensionModality? modality,
    List<ComprehensionBlock>? blocks,
    int? timeLimitMinutes,
    bool? guidedMode,
    bool? feedbackEnabled,
    bool? positiveReinforcementEnabled,
  }) {
    return ComprehensionTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      objective: objective ?? this.objective,
      recommendedAge: recommendedAge ?? this.recommendedAge,
      level: level ?? this.level,
      observations: observations ?? this.observations,
      createdAt: createdAt ?? this.createdAt,
      modality: modality ?? this.modality,
      blocks: blocks ?? this.blocks,
      timeLimitMinutes: timeLimitMinutes ?? this.timeLimitMinutes,
      guidedMode: guidedMode ?? this.guidedMode,
      feedbackEnabled: feedbackEnabled ?? this.feedbackEnabled,
      positiveReinforcementEnabled:
          positiveReinforcementEnabled ?? this.positiveReinforcementEnabled,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...baseToMap(),
      'content': {
        'modality': modality.code,
        'blocks': blocks.map((b) => b.toMap()).toList(),
        'timeLimitMinutes': timeLimitMinutes,
        'guidedMode': guidedMode,
        'feedbackEnabled': feedbackEnabled,
        'positiveReinforcementEnabled': positiveReinforcementEnabled,
      },
    };
  }

  factory ComprehensionTemplate.fromMap(Map<String, dynamic> map) {
    final content = Map<String, dynamic>.from(map['content'] ?? const {});
    return ComprehensionTemplate(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      objective: map['objective'] ?? '',
      recommendedAge: map['recommendedAge'] ?? '',
      level: TemplateLevelMapper.fromCode(map['level'] as String?),
      observations: map['observations'] ?? '',
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      modality: ComprehensionModalityMapper.fromCode(
        content['modality'] as String?,
      ),
      blocks: ((content['blocks'] as List?) ?? const [])
          .map((b) => ComprehensionBlock.fromMap(Map<String, dynamic>.from(b)))
          .toList(),
      timeLimitMinutes: content['timeLimitMinutes'] ?? 5,
      guidedMode: content['guidedMode'] ?? true,
      feedbackEnabled: content['feedbackEnabled'] ?? true,
      positiveReinforcementEnabled:
          content['positiveReinforcementEnabled'] ?? true,
    );
  }
}

// Plantilla de Vocabulario.
class VocabularyTemplate extends TemplateModel {
  final VocabularyMode mode;
  final List<VocabularyItem> items;
  final int repetitions;
  final bool guidedMode;
  final bool soundsEnabled;
  final bool feedbackEnabled;
  final bool positiveReinforcementEnabled;

  const VocabularyTemplate({
    required super.id,
    required super.name,
    required super.objective,
    required super.recommendedAge,
    required super.level,
    required super.observations,
    required super.createdAt,
    required this.mode,
    required this.items,
    required this.repetitions,
    required this.guidedMode,
    required this.soundsEnabled,
    required this.feedbackEnabled,
    required this.positiveReinforcementEnabled,
  }) : super(type: TemplateType.vocabulary);

  VocabularyTemplate copyWith({
    String? id,
    String? name,
    String? objective,
    String? recommendedAge,
    TemplateLevel? level,
    String? observations,
    DateTime? createdAt,
    VocabularyMode? mode,
    List<VocabularyItem>? items,
    int? repetitions,
    bool? guidedMode,
    bool? soundsEnabled,
    bool? feedbackEnabled,
    bool? positiveReinforcementEnabled,
  }) {
    return VocabularyTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      objective: objective ?? this.objective,
      recommendedAge: recommendedAge ?? this.recommendedAge,
      level: level ?? this.level,
      observations: observations ?? this.observations,
      createdAt: createdAt ?? this.createdAt,
      mode: mode ?? this.mode,
      items: items ?? this.items,
      repetitions: repetitions ?? this.repetitions,
      guidedMode: guidedMode ?? this.guidedMode,
      soundsEnabled: soundsEnabled ?? this.soundsEnabled,
      feedbackEnabled: feedbackEnabled ?? this.feedbackEnabled,
      positiveReinforcementEnabled:
          positiveReinforcementEnabled ?? this.positiveReinforcementEnabled,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...baseToMap(),
      'content': {
        'mode': mode.code,
        'items': items.map((i) => i.toMap()).toList(),
        'repetitions': repetitions,
        'guidedMode': guidedMode,
        'soundsEnabled': soundsEnabled,
        'feedbackEnabled': feedbackEnabled,
        'positiveReinforcementEnabled': positiveReinforcementEnabled,
      },
    };
  }

  factory VocabularyTemplate.fromMap(Map<String, dynamic> map) {
    final content = Map<String, dynamic>.from(map['content'] ?? const {});
    return VocabularyTemplate(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      objective: map['objective'] ?? '',
      recommendedAge: map['recommendedAge'] ?? '',
      level: TemplateLevelMapper.fromCode(map['level'] as String?),
      observations: map['observations'] ?? '',
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      mode: VocabularyModeMapper.fromCode(content['mode'] as String?),
      items: ((content['items'] as List?) ?? const [])
          .map((i) => VocabularyItem.fromMap(Map<String, dynamic>.from(i)))
          .toList(),
      repetitions: content['repetitions'] ?? 3,
      guidedMode: content['guidedMode'] ?? true,
      soundsEnabled: content['soundsEnabled'] ?? true,
      feedbackEnabled: content['feedbackEnabled'] ?? true,
      positiveReinforcementEnabled:
          content['positiveReinforcementEnabled'] ?? true,
    );
  }
}

// Plantilla de Secuencias.
class SequenceTemplate extends TemplateModel {
  final List<SequenceStep> steps;
  final bool feedbackEnabled;
  final bool positiveReinforcementEnabled;

  const SequenceTemplate({
    required super.id,
    required super.name,
    required super.objective,
    required super.recommendedAge,
    required super.level,
    required super.observations,
    required super.createdAt,
    required this.steps,
    required this.feedbackEnabled,
    required this.positiveReinforcementEnabled,
  }) : super(type: TemplateType.sequences);

  SequenceTemplate copyWith({
    String? id,
    String? name,
    String? objective,
    String? recommendedAge,
    TemplateLevel? level,
    String? observations,
    DateTime? createdAt,
    List<SequenceStep>? steps,
    bool? feedbackEnabled,
    bool? positiveReinforcementEnabled,
  }) {
    return SequenceTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      objective: objective ?? this.objective,
      recommendedAge: recommendedAge ?? this.recommendedAge,
      level: level ?? this.level,
      observations: observations ?? this.observations,
      createdAt: createdAt ?? this.createdAt,
      steps: steps ?? this.steps,
      feedbackEnabled: feedbackEnabled ?? this.feedbackEnabled,
      positiveReinforcementEnabled:
          positiveReinforcementEnabled ?? this.positiveReinforcementEnabled,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...baseToMap(),
      'content': {
        'steps': steps.map((s) => s.toMap()).toList(),
        'feedbackEnabled': feedbackEnabled,
        'positiveReinforcementEnabled': positiveReinforcementEnabled,
      },
    };
  }

  factory SequenceTemplate.fromMap(Map<String, dynamic> map) {
    final content = Map<String, dynamic>.from(map['content'] ?? const {});
    return SequenceTemplate(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      objective: map['objective'] ?? '',
      recommendedAge: map['recommendedAge'] ?? '',
      level: TemplateLevelMapper.fromCode(map['level'] as String?),
      observations: map['observations'] ?? '',
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      steps: ((content['steps'] as List?) ?? const [])
          .map((s) => SequenceStep.fromMap(Map<String, dynamic>.from(s)))
          .toList(),
      feedbackEnabled: content['feedbackEnabled'] ?? true,
      positiveReinforcementEnabled:
          content['positiveReinforcementEnabled'] ?? true,
    );
  }
}

// Plantilla Personalizada (comodín de campos libres).
class CustomTemplate extends TemplateModel {
  final List<CustomItem> items;
  final int repetitions;
  final int timeLimitMinutes;
  final bool guidedMode;
  final bool soundsEnabled;
  final bool feedbackEnabled;
  final bool positiveReinforcementEnabled;

  const CustomTemplate({
    required super.id,
    required super.name,
    required super.objective,
    required super.recommendedAge,
    required super.level,
    required super.observations,
    required super.createdAt,
    required this.items,
    required this.repetitions,
    required this.timeLimitMinutes,
    required this.guidedMode,
    required this.soundsEnabled,
    required this.feedbackEnabled,
    required this.positiveReinforcementEnabled,
  }) : super(type: TemplateType.custom);

  CustomTemplate copyWith({
    String? id,
    String? name,
    String? objective,
    String? recommendedAge,
    TemplateLevel? level,
    String? observations,
    DateTime? createdAt,
    List<CustomItem>? items,
    int? repetitions,
    int? timeLimitMinutes,
    bool? guidedMode,
    bool? soundsEnabled,
    bool? feedbackEnabled,
    bool? positiveReinforcementEnabled,
  }) {
    return CustomTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      objective: objective ?? this.objective,
      recommendedAge: recommendedAge ?? this.recommendedAge,
      level: level ?? this.level,
      observations: observations ?? this.observations,
      createdAt: createdAt ?? this.createdAt,
      items: items ?? this.items,
      repetitions: repetitions ?? this.repetitions,
      timeLimitMinutes: timeLimitMinutes ?? this.timeLimitMinutes,
      guidedMode: guidedMode ?? this.guidedMode,
      soundsEnabled: soundsEnabled ?? this.soundsEnabled,
      feedbackEnabled: feedbackEnabled ?? this.feedbackEnabled,
      positiveReinforcementEnabled:
          positiveReinforcementEnabled ?? this.positiveReinforcementEnabled,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...baseToMap(),
      'content': {
        'items': items.map((i) => i.toMap()).toList(),
        'repetitions': repetitions,
        'timeLimitMinutes': timeLimitMinutes,
        'guidedMode': guidedMode,
        'soundsEnabled': soundsEnabled,
        'feedbackEnabled': feedbackEnabled,
        'positiveReinforcementEnabled': positiveReinforcementEnabled,
      },
    };
  }

  factory CustomTemplate.fromMap(Map<String, dynamic> map) {
    final content = Map<String, dynamic>.from(map['content'] ?? const {});
    return CustomTemplate(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      objective: map['objective'] ?? '',
      recommendedAge: map['recommendedAge'] ?? '',
      level: TemplateLevelMapper.fromCode(map['level'] as String?),
      observations: map['observations'] ?? '',
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      items: ((content['items'] as List?) ?? const [])
          .map((i) => CustomItem.fromMap(Map<String, dynamic>.from(i)))
          .toList(),
      repetitions: content['repetitions'] ?? 3,
      timeLimitMinutes: content['timeLimitMinutes'] ?? 5,
      guidedMode: content['guidedMode'] ?? true,
      soundsEnabled: content['soundsEnabled'] ?? true,
      feedbackEnabled: content['feedbackEnabled'] ?? true,
      positiveReinforcementEnabled:
          content['positiveReinforcementEnabled'] ?? true,
    );
  }
}

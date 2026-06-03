import 'package:flutter/widgets.dart';
import '../../../../l10n/app_localizations.dart';

// Representa los tipos posibles de plantilla en el sistema.
enum TemplateType {
  comprehension,
  motor,
  vocabulary,
  phonemes,
  sequences,
  custom,
  unknown,
}

// Representa los niveles posibles de dificultad de una plantilla.
enum TemplateLevel { initial, medium, advanced, unknown }

// Representa el tipo de fonema trabajado en una plantilla de Fonemas/Pronunciación.
enum PhonemeType { simple, multiple, blend, unknown }

// Representa la posición del fonema dentro de la palabra a trabajar.
enum PhonemePosition { initial, middle, final_, blend, unknown }

// Representa el grupo muscular trabajado en una praxia bucofonatoria.
enum MotorMuscleGroup { lips, tongue, cheeks, jaw, palate, breath, unknown }

// Representa la modalidad de presentación en una plantilla de Comprensión.
enum ComprehensionModality { reading, listening, unknown }

// Representa el modo de trabajo en una plantilla de Vocabulario.
enum VocabularyMode { naming, riddle, categorization, unknown }

// Conversores entre el código interno y el texto traducido al idioma activo.
extension TemplateTypeMapper on TemplateType {
  // Devuelve el código interno que se persiste en Firestore.
  String get code {
    switch (this) {
      case TemplateType.comprehension:
        return 'comprehension';
      case TemplateType.motor:
        return 'motor';
      case TemplateType.vocabulary:
        return 'vocabulary';
      case TemplateType.phonemes:
        return 'phonemes';
      case TemplateType.sequences:
        return 'sequences';
      case TemplateType.custom:
        return 'custom';
      case TemplateType.unknown:
        return 'unknown';
    }
  }

  // Devuelve la etiqueta traducida al idioma activo del contexto recibido.
  String localized(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    switch (this) {
      case TemplateType.comprehension:
        return t.templateTypeComprehension;
      case TemplateType.motor:
        return t.templateTypeMotor;
      case TemplateType.vocabulary:
        return t.templateTypeVocabulary;
      case TemplateType.phonemes:
        return t.templateTypePhonemes;
      case TemplateType.sequences:
        return t.templateTypeSequences;
      case TemplateType.custom:
        return t.templateTypeCustom;
      case TemplateType.unknown:
        return '';
    }
  }

  // Reconstruye el enum a partir del código persistido en Firestore.
  static TemplateType fromCode(String? code) {
    switch (code) {
      case 'comprehension':
        return TemplateType.comprehension;
      case 'motor':
        return TemplateType.motor;
      case 'vocabulary':
        return TemplateType.vocabulary;
      case 'phonemes':
        return TemplateType.phonemes;
      case 'sequences':
        return TemplateType.sequences;
      case 'custom':
        return TemplateType.custom;
      default:
        return TemplateType.unknown;
    }
  }
}

extension TemplateLevelMapper on TemplateLevel {
  // Devuelve el código interno que se persiste en Firestore.
  String get code {
    switch (this) {
      case TemplateLevel.initial:
        return 'initial';
      case TemplateLevel.medium:
        return 'medium';
      case TemplateLevel.advanced:
        return 'advanced';
      case TemplateLevel.unknown:
        return 'unknown';
    }
  }

  // Devuelve la etiqueta traducida al idioma activo del contexto recibido.
  String localized(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    switch (this) {
      case TemplateLevel.initial:
        return t.levelInitial;
      case TemplateLevel.medium:
        return t.levelMedium;
      case TemplateLevel.advanced:
        return t.levelAdvanced;
      case TemplateLevel.unknown:
        return '';
    }
  }

  // Reconstruye el enum a partir del código persistido en Firestore.
  static TemplateLevel fromCode(String? code) {
    switch (code) {
      case 'initial':
        return TemplateLevel.initial;
      case 'medium':
        return TemplateLevel.medium;
      case 'advanced':
        return TemplateLevel.advanced;
      default:
        return TemplateLevel.unknown;
    }
  }
}

// Conversores entre el código interno y la etiqueta traducida al idioma activo.
extension PhonemeTypeMapper on PhonemeType {
  String get code {
    switch (this) {
      case PhonemeType.simple:
        return 'simple';
      case PhonemeType.multiple:
        return 'multiple';
      case PhonemeType.blend:
        return 'blend';
      case PhonemeType.unknown:
        return 'unknown';
    }
  }

  String localized(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    switch (this) {
      case PhonemeType.simple:
        return t.phonemeTypeSimple;
      case PhonemeType.multiple:
        return t.phonemeTypeMultiple;
      case PhonemeType.blend:
        return t.phonemeTypeBlend;
      case PhonemeType.unknown:
        return '';
    }
  }

  static PhonemeType fromCode(String? code) {
    switch (code) {
      case 'simple':
        return PhonemeType.simple;
      case 'multiple':
        return PhonemeType.multiple;
      case 'blend':
        return PhonemeType.blend;
      default:
        return PhonemeType.unknown;
    }
  }
}

extension PhonemePositionMapper on PhonemePosition {
  String get code {
    switch (this) {
      case PhonemePosition.initial:
        return 'initial';
      case PhonemePosition.middle:
        return 'middle';
      case PhonemePosition.final_:
        return 'final';
      case PhonemePosition.blend:
        return 'blend';
      case PhonemePosition.unknown:
        return 'unknown';
    }
  }

  String localized(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    switch (this) {
      case PhonemePosition.initial:
        return t.phonemePositionInitial;
      case PhonemePosition.middle:
        return t.phonemePositionMiddle;
      case PhonemePosition.final_:
        return t.phonemePositionFinal;
      case PhonemePosition.blend:
        return t.phonemePositionBlend;
      case PhonemePosition.unknown:
        return '';
    }
  }

  static PhonemePosition fromCode(String? code) {
    switch (code) {
      case 'initial':
        return PhonemePosition.initial;
      case 'middle':
        return PhonemePosition.middle;
      case 'final':
        return PhonemePosition.final_;
      case 'blend':
        return PhonemePosition.blend;
      default:
        return PhonemePosition.unknown;
    }
  }
}

extension MotorMuscleGroupMapper on MotorMuscleGroup {
  String get code {
    switch (this) {
      case MotorMuscleGroup.lips:
        return 'lips';
      case MotorMuscleGroup.tongue:
        return 'tongue';
      case MotorMuscleGroup.cheeks:
        return 'cheeks';
      case MotorMuscleGroup.jaw:
        return 'jaw';
      case MotorMuscleGroup.palate:
        return 'palate';
      case MotorMuscleGroup.breath:
        return 'breath';
      case MotorMuscleGroup.unknown:
        return 'unknown';
    }
  }

  String localized(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    switch (this) {
      case MotorMuscleGroup.lips:
        return t.motorGroupLips;
      case MotorMuscleGroup.tongue:
        return t.motorGroupTongue;
      case MotorMuscleGroup.cheeks:
        return t.motorGroupCheeks;
      case MotorMuscleGroup.jaw:
        return t.motorGroupJaw;
      case MotorMuscleGroup.palate:
        return t.motorGroupPalate;
      case MotorMuscleGroup.breath:
        return t.motorGroupBreath;
      case MotorMuscleGroup.unknown:
        return '';
    }
  }

  static MotorMuscleGroup fromCode(String? code) {
    switch (code) {
      case 'lips':
        return MotorMuscleGroup.lips;
      case 'tongue':
        return MotorMuscleGroup.tongue;
      case 'cheeks':
        return MotorMuscleGroup.cheeks;
      case 'jaw':
        return MotorMuscleGroup.jaw;
      case 'palate':
        return MotorMuscleGroup.palate;
      case 'breath':
        return MotorMuscleGroup.breath;
      default:
        return MotorMuscleGroup.unknown;
    }
  }
}

extension ComprehensionModalityMapper on ComprehensionModality {
  String get code {
    switch (this) {
      case ComprehensionModality.reading:
        return 'reading';
      case ComprehensionModality.listening:
        return 'listening';
      case ComprehensionModality.unknown:
        return 'unknown';
    }
  }

  String localized(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    switch (this) {
      case ComprehensionModality.reading:
        return t.comprehensionModalityReading;
      case ComprehensionModality.listening:
        return t.comprehensionModalityListening;
      case ComprehensionModality.unknown:
        return '';
    }
  }

  static ComprehensionModality fromCode(String? code) {
    switch (code) {
      case 'reading':
        return ComprehensionModality.reading;
      case 'listening':
        return ComprehensionModality.listening;
      default:
        return ComprehensionModality.unknown;
    }
  }
}

extension VocabularyModeMapper on VocabularyMode {
  String get code {
    switch (this) {
      case VocabularyMode.naming:
        return 'naming';
      case VocabularyMode.riddle:
        return 'riddle';
      case VocabularyMode.categorization:
        return 'categorization';
      case VocabularyMode.unknown:
        return 'unknown';
    }
  }

  String localized(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    switch (this) {
      case VocabularyMode.naming:
        return t.vocabularyModeNaming;
      case VocabularyMode.riddle:
        return t.vocabularyModeRiddle;
      case VocabularyMode.categorization:
        return t.vocabularyModeCategorization;
      case VocabularyMode.unknown:
        return '';
    }
  }

  static VocabularyMode fromCode(String? code) {
    switch (code) {
      case 'naming':
        return VocabularyMode.naming;
      case 'riddle':
        return VocabularyMode.riddle;
      case 'categorization':
        return VocabularyMode.categorization;
      default:
        return VocabularyMode.unknown;
    }
  }
}

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

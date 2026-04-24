import 'package:flutter/material.dart';
import '../../domain/models/template_model.dart';

// 🔹 Repositorio en memoria compartido para las plantillas de toda la app
class TemplateMemoryRepository {
  // 🔹 Constructor privado para forzar una única instancia compartida
  TemplateMemoryRepository._();

  // 🔹 Instancia global reutilizable
  static final TemplateMemoryRepository instance =
      TemplateMemoryRepository._();

  // 🔹 Lista observable de plantillas en memoria
  final ValueNotifier<List<TemplateModel>> templates =
      ValueNotifier<List<TemplateModel>>([
    const TemplateModel(
      id: '1',
      type: 'Juego de rimas',
      name: 'Juego de rimas',
      objective: 'Rimas, palabras y sílabas.',
      recommendedAge: '6-8 años',
      level: 'Inicial',
      observations: '',
      words: ['Casa', 'Mesa', 'Pesa', 'Fresa'],
      repetitions: 3,
      timeLimitMinutes: 3,
      guidedMode: true,
      soundsEnabled: true,
      feedbackEnabled: true,
      positiveReinforcementEnabled: true,
    ),
    const TemplateModel(
      id: '2',
      type: 'Fonemas / Pronunciación',
      name: 'Pronunciación',
      objective: 'Fonética. Control al hablar.',
      recommendedAge: '6-9 años',
      level: 'Inicial',
      observations: '',
      words: ['Casa', 'Zapato', 'Cantar', 'Kayak'],
      repetitions: 3,
      timeLimitMinutes: 3,
      guidedMode: true,
      soundsEnabled: true,
      feedbackEnabled: true,
      positiveReinforcementEnabled: true,
    ),
    const TemplateModel(
      id: '3',
      type: 'Memorización',
      name: 'Memorización',
      objective: 'Agilidad mental. Recuerda.',
      recommendedAge: '7-10 años',
      level: 'Medio',
      observations: '',
      words: ['Sol', 'Luna', 'Árbol', 'Perro'],
      repetitions: 3,
      timeLimitMinutes: 3,
      guidedMode: true,
      soundsEnabled: true,
      feedbackEnabled: true,
      positiveReinforcementEnabled: true,
    ),
    const TemplateModel(
      id: '4',
      type: 'Secuencias',
      name: 'Secuencias',
      objective: 'Ordena imágenes y/o palabras.',
      recommendedAge: '6-10 años',
      level: 'Inicial',
      observations: '',
      words: ['Primero', 'Después', 'Luego', 'Final'],
      repetitions: 3,
      timeLimitMinutes: 3,
      guidedMode: true,
      soundsEnabled: true,
      feedbackEnabled: true,
      positiveReinforcementEnabled: true,
    ),
  ]);

  // 🔹 Añade una plantilla nueva al repositorio
  void addTemplate(TemplateModel template) {
    templates.value = [
      template,
      ...templates.value,
    ];
  }

  // 🔹 Actualiza una plantilla existente por id
  void updateTemplate(TemplateModel updatedTemplate) {
    final updatedList = templates.value.map((template) {
      if (template.id == updatedTemplate.id) {
        return updatedTemplate;
      }

      return template;
    }).toList();

    templates.value = updatedList;
  }

  // 🔹 Comprueba si ya existe una plantilla con ese id
  bool existsById(String id) {
    return templates.value.any((template) => template.id == id);
  }

  // 🔹 Recupera una plantilla concreta por id
  TemplateModel? getById(String id) {
    try {
      return templates.value.firstWhere((template) => template.id == id);
    } catch (_) {
      return null;
    }
  }
}
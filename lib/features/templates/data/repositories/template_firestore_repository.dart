import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../domain/models/template_model.dart';

// Gestiona todas las operaciones de plantillas contra Firestore.
class TemplateFirestoreRepository {
  // Constructor privado — patrón Singleton.
  TemplateFirestoreRepository._();

  // Expone la instancia global reutilizable.
  static final TemplateFirestoreRepository instance =
      TemplateFirestoreRepository._();

  // Almacena la referencia a la colección de plantillas en Firestore.
  final CollectionReference _collection = FirebaseFirestore.instance.collection(
    'templates',
  );

  // Mantiene la lista observable de plantillas para la interfaz.
  final ValueNotifier<List<TemplateModel>> templates =
      ValueNotifier<List<TemplateModel>>([]);

  // Inicia la escucha en tiempo real de la colección de plantillas.
  void startListening() {
    _collection.orderBy('name').snapshots().listen((snapshot) {
      final list = snapshot.docs.map((doc) {
        return TemplateModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      templates.value = list;
    });
  }

  // Añade una plantilla nueva a Firestore.
  Future<void> addTemplate(TemplateModel template) async {
    await _collection.doc(template.id).set(template.toMap());
  }

  // Actualiza los datos de una plantilla existente en Firestore.
  Future<void> updateTemplate(TemplateModel template) async {
    await _collection.doc(template.id).update(template.toMap());
  }

  // Recupera una plantilla concreta por su identificador.
  Future<TemplateModel?> getById(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return TemplateModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  // Comprueba si ya existe una plantilla con el identificador dado.
  Future<bool> existsById(String id) async {
    final doc = await _collection.doc(id).get();
    return doc.exists;
  }

  // Elimina una plantilla conservando las actividades que la utilizaron.
  Future<void> deleteTemplate(String templateId) async {
    await _collection.doc(templateId).delete();
  }
}

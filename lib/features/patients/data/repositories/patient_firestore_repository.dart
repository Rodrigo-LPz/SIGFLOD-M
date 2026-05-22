import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../domain/models/patient_model.dart';

// Gestiona todas las operaciones de pacientes contra Firestore.
class PatientFirestoreRepository {
  // Constructor privado — patrón Singleton.
  PatientFirestoreRepository._();

  // Expone la instancia global reutilizable.
  static final PatientFirestoreRepository instance =
      PatientFirestoreRepository._();

  // Almacena la referencia a la colección de pacientes en Firestore.
  final CollectionReference _collection = FirebaseFirestore.instance.collection(
    'patients',
  );

  // Mantiene la lista observable de pacientes para la interfaz.
  final ValueNotifier<List<PatientModel>> patients =
      ValueNotifier<List<PatientModel>>([]);

  // Inicia la escucha en tiempo real de la colección de pacientes.
  void startListening({List<String>? restrictToIds}) {
    // Si la lista de restricción es vacía no devuelve ningún paciente.
    if (restrictToIds != null && restrictToIds.isEmpty) {
      patients.value = [];
      return;
    }

    // Construye la consulta básica ordenada por nombre.
    Query query = _collection.orderBy('name');

    // Aplica el filtro solo si se ha restringido el acceso a ciertos pacientes.
    if (restrictToIds != null) {
      query = query.where(FieldPath.documentId, whereIn: restrictToIds);
    }

    query.snapshots().listen((snapshot) {
      final list = snapshot.docs.map((doc) {
        return PatientModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      patients.value = list;
    });
  }

  // Añade un paciente nuevo a Firestore.
  Future<void> addPatient(PatientModel patient) async {
    await _collection.doc(patient.id).set(patient.toMap());
  }

  // Actualiza los datos de un paciente existente en Firestore.
  Future<void> updatePatient(PatientModel patient) async {
    await _collection.doc(patient.id).update(patient.toMap());
  }

  // Recupera un paciente concreto por su identificador.
  Future<PatientModel?> getById(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return PatientModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  // Elimina un paciente y todas sus actividades vinculadas en cascada.
  Future<void> deletePatient(String patientId) async {
    // Localiza primero todas las actividades del paciente.
    final activitiesQuery = await FirebaseFirestore.instance
        .collection('activities')
        .where('patientId', isEqualTo: patientId)
        .get();

    // Construye un batch para borrar todo de forma atómica.
    final batch = FirebaseFirestore.instance.batch();
    for (final doc in activitiesQuery.docs) {
      batch.delete(doc.reference);
    }
    batch.delete(_collection.doc(patientId));

    // Ejecuta el borrado en una única operación transaccional.
    await batch.commit();
  }
}

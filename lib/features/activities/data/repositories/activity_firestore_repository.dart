import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../domain/models/activity_model.dart';

// Gestiona todas las operaciones de actividades contra Firestore.
class ActivityFirestoreRepository {
  // Constructor privado — patrón Singleton.
  ActivityFirestoreRepository._();

  // Expone la instancia global reutilizable.
  static final ActivityFirestoreRepository instance =
      ActivityFirestoreRepository._();

  // Almacena la referencia a la colección de actividades en Firestore.
  final CollectionReference _collection = FirebaseFirestore.instance.collection(
    'activities',
  );

  // Mantiene la lista observable de actividades para la interfaz.
  final ValueNotifier<List<ActivityModel>> activities =
      ValueNotifier<List<ActivityModel>>([]);

  // Inicia la escucha en tiempo real de la colección de actividades.
  void startListening({List<String>? restrictToPatientIds}) {
    // Si la lista de restricción es vacía no devuelve ninguna actividad.
    if (restrictToPatientIds != null && restrictToPatientIds.isEmpty) {
      activities.value = [];
      return;
    }

    // Construye la consulta básica ordenada por fecha de creación.
    Query query = _collection.orderBy('createdAt', descending: true);

    // Aplica el filtro solo si el usuario tiene acceso restringido a pacientes.
    if (restrictToPatientIds != null) {
      query = query.where('patientId', whereIn: restrictToPatientIds);
    }

    query.snapshots().listen((snapshot) {
      final list = snapshot.docs.map((doc) {
        return ActivityModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      activities.value = list;
    });
  }

  // Añade una actividad nueva a Firestore.
  Future<void> addActivity(ActivityModel activity) async {
    await _collection.doc(activity.id).set(activity.toMap());
  }

  // Devuelve todas las actividades registradas de un paciente concreto.
  List<ActivityModel> getActivitiesByPatientId(String patientId) {
    return activities.value
        .where((activity) => activity.patientId == patientId)
        .toList();
  }

  // Devuelve las actividades ordenadas de más reciente a más antigua.
  List<ActivityModel> getRecentActivities() {
    final sorted = [...activities.value];
    sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted;
  }
}

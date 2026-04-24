import 'package:flutter/material.dart';
import '../../domain/models/activity_model.dart';

// 🔹 Repositorio en memoria compartido para todas las actividades de la app
class ActivityMemoryRepository {
  // 🔹 Constructor privado para forzar una única instancia compartida
  ActivityMemoryRepository._();

  // 🔹 Instancia global reutilizable
  static final ActivityMemoryRepository instance =
      ActivityMemoryRepository._();

  // 🔹 Lista observable de actividades en memoria
  final ValueNotifier<List<ActivityModel>> activities =
      ValueNotifier<List<ActivityModel>>([]);

  // 🔹 Añade una actividad nueva al repositorio
  void addActivity(ActivityModel activity) {
    activities.value = [
      activity,
      ...activities.value,
    ];
  }

  // 🔹 Devuelve todas las actividades registradas de un paciente concreto
  List<ActivityModel> getActivitiesByPatientId(String patientId) {
    return activities.value
        .where((activity) => activity.patientId == patientId)
        .toList();
  }

  // 🔹 Devuelve las actividades ordenadas de más reciente a más antigua
  List<ActivityModel> getRecentActivities() {
    final sortedActivities = [...activities.value];
    sortedActivities.sort(
      (a, b) => b.createdAt.compareTo(a.createdAt),
    );
    return sortedActivities;
  }
}
import 'package:flutter/material.dart';
import '../../domain/models/patient_model.dart';

// 🔹 Repositorio en memoria compartido para toda la app
class PatientMemoryRepository {
  // 🔹 Instancia única para reutilizar siempre la misma memoria
  PatientMemoryRepository._();

  // 🔹 Punto de acceso global al repositorio
  static final PatientMemoryRepository instance = PatientMemoryRepository._();

  // 🔹 Lista observable de pacientes en memoria
  final ValueNotifier<List<PatientModel>> patients = ValueNotifier<List<PatientModel>>([
    const PatientModel(
      id: '1',
      name: 'Aday',
      surname: 'Perdomo',
      birthDate: '22 / 09 / 2005',
      diagnosis: 'Disgrafía, Retraso del Habla, TEL',
      observations: '',
    ),
    const PatientModel(
      id: '2',
      name: 'Matías',
      surname: 'Ariel',
      birthDate: '20 / 03 / 2005',
      diagnosis: 'Dislexia, Disfemia, TDAH',
      observations: '',
    ),
    const PatientModel(
      id: '3',
      name: 'Amaro',
      surname: 'Morales',
      birthDate: '20 / 03 / 2005',
      diagnosis: 'TID, TAS',
      observations: '',
    ),
  ]);

  // 🔹 Añade un paciente nuevo a la memoria
  void addPatient(PatientModel patient) {
    patients.value = [
      ...patients.value,
      patient,
    ];
  }

  // 🔹 Sustituye un paciente existente por su versión actualizada
  void updatePatient(PatientModel updatedPatient) {
    final updatedList = patients.value.map((patient) {
      if (patient.id == updatedPatient.id) {
        return updatedPatient;
      }

      return patient;
    }).toList();

    patients.value = updatedList;
  }

  // 🔹 Recupera un paciente concreto por id
  PatientModel? getById(String id) {
    try {
      return patients.value.firstWhere((patient) => patient.id == id);
    } catch (_) {
      return null;
    }
  }
}
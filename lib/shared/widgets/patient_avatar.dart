import 'dart:convert';
import 'package:flutter/material.dart';
import '../../features/patients/domain/models/patient_model.dart';

// Muestra la foto del paciente o un avatar genérico si no tiene foto asignada.
class PatientAvatar extends StatelessWidget {
  // Paciente del que se mostrará la foto o el avatar genérico.
  final PatientModel patient;

  // Radio del círculo que envuelve la foto o el avatar.
  final double radius;

  const PatientAvatar({super.key, required this.patient, this.radius = 25});

  @override
  Widget build(BuildContext context) {
    // Si el paciente no tiene foto, muestra el avatar genérico predeterminado.
    if (!patient.hasPhoto) {
      return CircleAvatar(radius: radius, child: const Icon(Icons.person));
    }

    // Decodifica la cadena Base64 a bytes para mostrar la imagen original.
    try {
      final bytes = base64Decode(patient.photoBase64!);
      return CircleAvatar(radius: radius, backgroundImage: MemoryImage(bytes));
    } catch (_) {
      // Si la cadena está corrupta, muestra el avatar genérico como respaldo.
      return CircleAvatar(radius: radius, child: const Icon(Icons.person));
    }
  }
}

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
      return CircleAvatar(
        key: ValueKey('avatar-${patient.id}-none'),
        radius: radius,
        child: const Icon(Icons.person),
      );
    }

    // Carga la imagen del paciente directamente desde su URL pública en Storage.
    return CircleAvatar(
      key: ValueKey('avatar-${patient.id}-${patient.photoUrl}'),
      radius: radius,
      backgroundImage: NetworkImage(patient.photoUrl!),
      onBackgroundImageError: (_, _) {
        // Falla silenciosamente si la imagen no carga.
      },
    );
  }
}

// Representa una invitación pendiente que vincula un familiar a un paciente.
class InvitationModel {
  // Identificador único del documento (el propio código de invitación).
  final String code;

  // Identificador del paciente al que se vincula esta invitación.
  final String patientId;

  // Identificador del logopeda que generó la invitación.
  final String createdByUid;

  // Fecha en la que se generó la invitación.
  final DateTime createdAt;

  const InvitationModel({
    required this.code,
    required this.patientId,
    required this.createdByUid,
    required this.createdAt,
  });

  // Serializa el modelo a un mapa compatible con Firestore.
  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'patientId': patientId,
      'createdByUid': createdByUid,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Reconstruye el modelo a partir de un mapa procedente de Firestore.
  factory InvitationModel.fromMap(Map<String, dynamic> map) {
    return InvitationModel(
      code: map['code'] ?? '',
      patientId: map['patientId'] ?? '',
      createdByUid: map['createdByUid'] ?? '',
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}

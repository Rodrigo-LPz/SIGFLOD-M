// Representa los datos clínicos y personales de un paciente del logopeda.
class PatientModel {
  final String id;
  final String name;
  final String surname;
  final String birthDate;
  final String diagnosis;
  final String observations;

  // Almacena la foto de perfil del paciente codificada como texto Base64.
  final String? photoBase64;

  const PatientModel({
    required this.id,
    required this.name,
    required this.surname,
    required this.birthDate,
    required this.diagnosis,
    required this.observations,
    this.photoBase64,
  });

  String get fullName => '$name $surname'.trim();

  // Determina si el paciente tiene una foto de perfil asignada.
  bool get hasPhoto => photoBase64 != null && photoBase64!.isNotEmpty;

  PatientModel copyWith({
    String? id,
    String? name,
    String? surname,
    String? birthDate,
    String? diagnosis,
    String? observations,
    String? photoBase64,
    bool clearPhoto = false,
  }) {
    return PatientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      birthDate: birthDate ?? this.birthDate,
      diagnosis: diagnosis ?? this.diagnosis,
      observations: observations ?? this.observations,
      photoBase64: clearPhoto ? null : (photoBase64 ?? this.photoBase64),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'birthDate': birthDate,
      'diagnosis': diagnosis,
      'observations': observations,
      'photoBase64': photoBase64,
    };
  }

  factory PatientModel.fromMap(Map<String, dynamic> map) {
    return PatientModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      surname: map['surname'] ?? '',
      birthDate: map['birthDate'] ?? '',
      diagnosis: map['diagnosis'] ?? '',
      observations: map['observations'] ?? '',
      photoBase64: map['photoBase64'] as String?,
    );
  }
}

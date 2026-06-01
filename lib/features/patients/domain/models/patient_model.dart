// Representa los datos clínicos y personales de un paciente del logopeda.
class PatientModel {
  final String id;
  final String name;
  final String surname;
  final String birthDate;
  final String diagnosis;
  final String observations;

  // Almacena la URL pública de la foto de perfil del paciente en Firebase Storage.
  final String? photoUrl;

  const PatientModel({
    required this.id,
    required this.name,
    required this.surname,
    required this.birthDate,
    required this.diagnosis,
    required this.observations,
    this.photoUrl,
  });

  String get fullName => '$name $surname'.trim();

  // Determina si el paciente tiene una foto de perfil asignada.
  bool get hasPhoto => photoUrl != null && photoUrl!.isNotEmpty;

  PatientModel copyWith({
    String? id,
    String? name,
    String? surname,
    String? birthDate,
    String? diagnosis,
    String? observations,
    String? photoUrl,
    bool clearPhoto = false,
  }) {
    return PatientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      birthDate: birthDate ?? this.birthDate,
      diagnosis: diagnosis ?? this.diagnosis,
      observations: observations ?? this.observations,
      photoUrl: clearPhoto ? null : (photoUrl ?? this.photoUrl),
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
      'photoUrl': photoUrl,
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
      photoUrl: map['photoUrl'] as String?,
    );
  }
}

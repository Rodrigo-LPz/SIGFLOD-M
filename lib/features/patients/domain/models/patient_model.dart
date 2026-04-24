class PatientModel {
  final String id;
  final String name;
  final String surname;
  final String birthDate;
  final String diagnosis;
  final String observations;

  const PatientModel({
    required this.id,
    required this.name,
    required this.surname,
    required this.birthDate,
    required this.diagnosis,
    required this.observations,
  });

  String get fullName => '$name $surname'.trim();

  PatientModel copyWith({
    String? id,
    String? name,
    String? surname,
    String? birthDate,
    String? diagnosis,
    String? observations,
  }) {
    return PatientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      birthDate: birthDate ?? this.birthDate,
      diagnosis: diagnosis ?? this.diagnosis,
      observations: observations ?? this.observations,
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
    );
  }
}
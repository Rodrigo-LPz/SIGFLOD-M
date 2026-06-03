import '../template_enums.dart';

// Representa una praxia bucofonatoria concreta dentro de una plantilla Motora.
class MotorPraxia {
  final String id;
  final String name;
  final MotorMuscleGroup muscleGroup;
  final String description;
  final int repetitions;
  final int holdSeconds;
  final String? imageUrl;
  final String? videoUrl;

  const MotorPraxia({
    required this.id,
    required this.name,
    required this.muscleGroup,
    required this.description,
    required this.repetitions,
    required this.holdSeconds,
    this.imageUrl,
    this.videoUrl,
  });

  MotorPraxia copyWith({
    String? id,
    String? name,
    MotorMuscleGroup? muscleGroup,
    String? description,
    int? repetitions,
    int? holdSeconds,
    String? imageUrl,
    String? videoUrl,
    bool clearImage = false,
    bool clearVideo = false,
  }) {
    return MotorPraxia(
      id: id ?? this.id,
      name: name ?? this.name,
      muscleGroup: muscleGroup ?? this.muscleGroup,
      description: description ?? this.description,
      repetitions: repetitions ?? this.repetitions,
      holdSeconds: holdSeconds ?? this.holdSeconds,
      imageUrl: clearImage ? null : (imageUrl ?? this.imageUrl),
      videoUrl: clearVideo ? null : (videoUrl ?? this.videoUrl),
    );
  }

  // Serializa la praxia a un mapa compatible con Firestore.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'muscleGroup': muscleGroup.code,
      'description': description,
      'repetitions': repetitions,
      'holdSeconds': holdSeconds,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
    };
  }

  // Reconstruye la praxia a partir de un mapa procedente de Firestore.
  factory MotorPraxia.fromMap(Map<String, dynamic> map) {
    return MotorPraxia(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      muscleGroup: MotorMuscleGroupMapper.fromCode(
        map['muscleGroup'] as String?,
      ),
      description: map['description'] ?? '',
      repetitions: map['repetitions'] ?? 5,
      holdSeconds: map['holdSeconds'] ?? 3,
      imageUrl: map['imageUrl'] as String?,
      videoUrl: map['videoUrl'] as String?,
    );
  }
}

// Representa un paso individual dentro de una secuencia narrativa o temporal.
class SequenceStep {
  final String id;
  final String description;
  final int correctOrder;
  final String? imageUrl;

  const SequenceStep({
    required this.id,
    required this.description,
    required this.correctOrder,
    this.imageUrl,
  });

  SequenceStep copyWith({
    String? id,
    String? description,
    int? correctOrder,
    String? imageUrl,
    bool clearImage = false,
  }) {
    return SequenceStep(
      id: id ?? this.id,
      description: description ?? this.description,
      correctOrder: correctOrder ?? this.correctOrder,
      imageUrl: clearImage ? null : (imageUrl ?? this.imageUrl),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'correctOrder': correctOrder,
      'imageUrl': imageUrl,
    };
  }

  factory SequenceStep.fromMap(Map<String, dynamic> map) {
    return SequenceStep(
      id: map['id'] ?? '',
      description: map['description'] ?? '',
      correctOrder: map['correctOrder'] ?? 0,
      imageUrl: map['imageUrl'] as String?,
    );
  }
}

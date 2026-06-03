import '../template_enums.dart';

// Representa un item concreto de una plantilla de Fonemas o Pronunciación.
class PhonemeItem {
  final String id;
  final String word;
  final PhonemePosition position;
  final String? audioUrl;
  final String? imageUrl;

  const PhonemeItem({
    required this.id,
    required this.word,
    required this.position,
    this.audioUrl,
    this.imageUrl,
  });

  PhonemeItem copyWith({
    String? id,
    String? word,
    PhonemePosition? position,
    String? audioUrl,
    String? imageUrl,
    bool clearAudio = false,
    bool clearImage = false,
  }) {
    return PhonemeItem(
      id: id ?? this.id,
      word: word ?? this.word,
      position: position ?? this.position,
      audioUrl: clearAudio ? null : (audioUrl ?? this.audioUrl),
      imageUrl: clearImage ? null : (imageUrl ?? this.imageUrl),
    );
  }

  // Serializa el item a un mapa compatible con Firestore.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'position': position.code,
      'audioUrl': audioUrl,
      'imageUrl': imageUrl,
    };
  }

  // Reconstruye el item a partir de un mapa procedente de Firestore.
  factory PhonemeItem.fromMap(Map<String, dynamic> map) {
    return PhonemeItem(
      id: map['id'] ?? '',
      word: map['word'] ?? '',
      position: PhonemePositionMapper.fromCode(map['position'] as String?),
      audioUrl: map['audioUrl'] as String?,
      imageUrl: map['imageUrl'] as String?,
    );
  }
}

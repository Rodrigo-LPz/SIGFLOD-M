// Representa un item concreto dentro de una plantilla de Vocabulario.
class VocabularyItem {
  final String id;
  final String word;
  final String category;
  final String definition;
  final String? imageUrl;
  final String? audioUrl;

  const VocabularyItem({
    required this.id,
    required this.word,
    required this.category,
    required this.definition,
    this.imageUrl,
    this.audioUrl,
  });

  VocabularyItem copyWith({
    String? id,
    String? word,
    String? category,
    String? definition,
    String? imageUrl,
    String? audioUrl,
    bool clearImage = false,
    bool clearAudio = false,
  }) {
    return VocabularyItem(
      id: id ?? this.id,
      word: word ?? this.word,
      category: category ?? this.category,
      definition: definition ?? this.definition,
      imageUrl: clearImage ? null : (imageUrl ?? this.imageUrl),
      audioUrl: clearAudio ? null : (audioUrl ?? this.audioUrl),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'category': category,
      'definition': definition,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
    };
  }

  factory VocabularyItem.fromMap(Map<String, dynamic> map) {
    return VocabularyItem(
      id: map['id'] ?? '',
      word: map['word'] ?? '',
      category: map['category'] ?? '',
      definition: map['definition'] ?? '',
      imageUrl: map['imageUrl'] as String?,
      audioUrl: map['audioUrl'] as String?,
    );
  }
}

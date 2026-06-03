// Representa un item totalmente libre dentro de una plantilla Personalizada.
class CustomItem {
  final String id;
  final String text;
  final String? imageUrl;
  final String? audioUrl;
  final String? videoUrl;

  const CustomItem({
    required this.id,
    required this.text,
    this.imageUrl,
    this.audioUrl,
    this.videoUrl,
  });

  CustomItem copyWith({
    String? id,
    String? text,
    String? imageUrl,
    String? audioUrl,
    String? videoUrl,
    bool clearImage = false,
    bool clearAudio = false,
    bool clearVideo = false,
  }) {
    return CustomItem(
      id: id ?? this.id,
      text: text ?? this.text,
      imageUrl: clearImage ? null : (imageUrl ?? this.imageUrl),
      audioUrl: clearAudio ? null : (audioUrl ?? this.audioUrl),
      videoUrl: clearVideo ? null : (videoUrl ?? this.videoUrl),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
      'videoUrl': videoUrl,
    };
  }

  factory CustomItem.fromMap(Map<String, dynamic> map) {
    return CustomItem(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      imageUrl: map['imageUrl'] as String?,
      audioUrl: map['audioUrl'] as String?,
      videoUrl: map['videoUrl'] as String?,
    );
  }
}

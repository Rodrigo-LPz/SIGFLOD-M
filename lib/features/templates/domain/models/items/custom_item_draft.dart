import 'package:flutter/foundation.dart';

// Representa un item de plantilla Personalizada en construcción dentro del
// wizard, antes de que sus archivos multimedia se hayan subido a Storage.
//
// Cada campo multimedia puede contener bytes recién seleccionados (pendientes
// de subir) o una URL ya existente (cuando se edita una plantilla previamente
// guardada). Cuando se finaliza el wizard, los bytes se suben a Storage y se
// reemplazan por las URLs definitivas en el modelo final CustomItem.
class CustomItemDraft {
  final String id;
  final String text;

  // Bytes de la imagen seleccionada pendientes de subir a Storage.
  final Uint8List? imageBytes;
  // URL existente de la imagen si proviene de una plantilla ya guardada.
  final String? imageUrl;

  // Bytes del audio seleccionado pendientes de subir a Storage.
  final Uint8List? audioBytes;
  // Tipo MIME del audio seleccionado para subirlo con el contentType correcto.
  final String? audioContentType;
  // URL existente del audio si proviene de una plantilla ya guardada.
  final String? audioUrl;

  // Bytes del vídeo seleccionado pendientes de subir a Storage.
  final Uint8List? videoBytes;
  // Tipo MIME del vídeo seleccionado para subirlo con el contentType correcto.
  final String? videoContentType;
  // URL existente del vídeo si proviene de una plantilla ya guardada.
  final String? videoUrl;

  const CustomItemDraft({
    required this.id,
    required this.text,
    this.imageBytes,
    this.imageUrl,
    this.audioBytes,
    this.audioContentType,
    this.audioUrl,
    this.videoBytes,
    this.videoContentType,
    this.videoUrl,
  });

  // Indica si el item tiene una imagen disponible, bien pendiente o ya subida.
  bool get hasImage => imageBytes != null || imageUrl != null;

  // Indica si el item tiene un audio disponible, bien pendiente o ya subido.
  bool get hasAudio => audioBytes != null || audioUrl != null;

  // Indica si el item tiene un vídeo disponible, bien pendiente o ya subido.
  bool get hasVideo => videoBytes != null || videoUrl != null;

  CustomItemDraft copyWith({
    String? id,
    String? text,
    Uint8List? imageBytes,
    String? imageUrl,
    Uint8List? audioBytes,
    String? audioContentType,
    String? audioUrl,
    Uint8List? videoBytes,
    String? videoContentType,
    String? videoUrl,
    bool clearImage = false,
    bool clearAudio = false,
    bool clearVideo = false,
  }) {
    return CustomItemDraft(
      id: id ?? this.id,
      text: text ?? this.text,
      imageBytes: clearImage ? null : (imageBytes ?? this.imageBytes),
      imageUrl: clearImage ? null : (imageUrl ?? this.imageUrl),
      audioBytes: clearAudio ? null : (audioBytes ?? this.audioBytes),
      audioContentType: clearAudio
          ? null
          : (audioContentType ?? this.audioContentType),
      audioUrl: clearAudio ? null : (audioUrl ?? this.audioUrl),
      videoBytes: clearVideo ? null : (videoBytes ?? this.videoBytes),
      videoContentType: clearVideo
          ? null
          : (videoContentType ?? this.videoContentType),
      videoUrl: clearVideo ? null : (videoUrl ?? this.videoUrl),
    );
  }
}

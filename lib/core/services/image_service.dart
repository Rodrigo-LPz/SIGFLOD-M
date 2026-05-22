import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

// Centraliza la captura, procesamiento y codificación de imágenes en la aplicación.
class ImageService {
  // Constructor privado — patrón Singleton.
  ImageService._();

  // Expone la instancia global reutilizable.
  static final ImageService instance = ImageService._();

  // Mantiene la instancia del selector de imágenes nativo.
  final ImagePicker _picker = ImagePicker();

  // Lado máximo en píxeles al que se redimensiona la imagen subida.
  static const int _maxDimension = 512;

  // Calidad de compresión utilizada al codificar la imagen como JPEG.
  static const int _jpegQuality = 85;

  // Indica si la plataforma actual permite capturar imágenes con la cámara.
  bool get isCameraAvailable {
    // La web y los entornos de escritorio no exponen una cámara accesible.
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  // Abre la galería del dispositivo y devuelve la imagen procesada como Base64.
  Future<String?> pickFromGallery() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return null;
    return _processToBase64(picked);
  }

  // Abre la cámara del dispositivo y devuelve la imagen capturada como Base64.
  Future<String?> pickFromCamera() async {
    final picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked == null) return null;
    return _processToBase64(picked);
  }

  // Procesa una imagen seleccionada redimensionándola y codificándola.
  Future<String?> _processToBase64(XFile file) async {
    // Lee los bytes originales del fichero seleccionado.
    final originalBytes = await file.readAsBytes();

    // Decodifica la imagen utilizando el paquete image.
    final decoded = img.decodeImage(originalBytes);
    if (decoded == null) return null;

    // Redimensiona la imagen manteniendo la proporción al lado mayor.
    final resized = _resize(decoded);

    // Codifica la imagen redimensionada como JPEG comprimido.
    final compressedBytes = Uint8List.fromList(
      img.encodeJpg(resized, quality: _jpegQuality),
    );

    // Convierte los bytes finales a una cadena Base64 transportable.
    return base64Encode(compressedBytes);
  }

  // Redimensiona la imagen al lado mayor establecido como máximo.
  img.Image _resize(img.Image source) {
    final width = source.width;
    final height = source.height;

    // Si la imagen ya es pequeña no es necesario redimensionarla.
    if (width <= _maxDimension && height <= _maxDimension) {
      return source;
    }

    if (width >= height) {
      return img.copyResize(source, width: _maxDimension);
    } else {
      return img.copyResize(source, height: _maxDimension);
    }
  }
}

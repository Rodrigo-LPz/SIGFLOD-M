import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

// Centraliza la captura, procesamiento y subida de imágenes en la aplicación.
class ImageService {
  // Constructor privado — patrón Singleton.
  ImageService._();

  // Expone la instancia global reutilizable.
  static final ImageService instance = ImageService._();

  // Mantiene la instancia del selector de imágenes nativo.
  final ImagePicker _picker = ImagePicker();

  // Mantiene la instancia del servicio de almacenamiento de Firebase.
  final FirebaseStorage _storage = FirebaseStorage.instance;

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

  // Abre la galería del dispositivo y devuelve los bytes procesados de la imagen.
  Future<Uint8List?> pickFromGallery() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return null;
    return _processToBytes(picked);
  }

  // Abre la cámara del dispositivo y devuelve los bytes procesados de la imagen.
  Future<Uint8List?> pickFromCamera() async {
    final picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked == null) return null;
    return _processToBytes(picked);
  }

  // Sube los bytes de una foto al bucket de Storage y devuelve su URL pública.
  Future<String> uploadPatientPhoto({
    required String patientId,
    required Uint8List imageBytes,
  }) async {
    // Construye la referencia al archivo dentro del bucket usando la estructura acordada.
    final ref = _storage.ref('patients/$patientId/photo');

    // Sube los bytes con el contentType correcto para satisfacer las reglas de Storage.
    await ref.putData(imageBytes, SettableMetadata(contentType: 'image/jpeg'));

    // Devuelve la URL pública para almacenarla en el documento del paciente.
    return ref.getDownloadURL();
  }

  // Elimina la foto de perfil del paciente del bucket de Storage.
  Future<void> deletePatientPhoto(String patientId) async {
    final ref = _storage.ref('patients/$patientId/photo');
    // Intenta borrar el archivo y silencia el error si el archivo no existe.
    try {
      await ref.delete();
    } on FirebaseException catch (e) {
      if (e.code != 'object-not-found') rethrow;
    }
  }

  // Procesa una imagen seleccionada redimensionándola y comprimiéndola a JPEG.
  Future<Uint8List?> _processToBytes(XFile file) async {
    // Lee los bytes originales del fichero seleccionado.
    final originalBytes = await file.readAsBytes();

    // Decodifica la imagen utilizando el paquete image.
    final decoded = img.decodeImage(originalBytes);
    if (decoded == null) return null;

    // Redimensiona la imagen manteniendo la proporción al lado mayor.
    final resized = _resize(decoded);

    // Codifica la imagen redimensionada como JPEG comprimido y devuelve sus bytes.
    return Uint8List.fromList(img.encodeJpg(resized, quality: _jpegQuality));
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

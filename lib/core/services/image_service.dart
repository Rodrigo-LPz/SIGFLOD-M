import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

// Centraliza la captura, procesamiento y subida de archivos multimedia en la aplicación, tanto para fotos de pacientes como para items de plantillas (imágenes, audios y vídeos).
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

  // SELECCIÓN DE ARCHIVOS
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

  // Abre el selector de archivos para escoger un audio del dispositivo.
  Future<PickedMediaFile?> pickAudio() async {
    final result = await FilePicker.pickFiles(
      type: FileType.audio,
      withData: true,
    );

    if (result == null || result.files.isEmpty) return null;

    final file = result.files.first;
    final bytes = file.bytes;
    if (bytes == null) return null;

    return PickedMediaFile(
      bytes: bytes,
      fileName: file.name,
      contentType: _resolveAudioContentType(file.extension),
    );
  }

  // Abre el selector de archivos para escoger un vídeo del dispositivo.
  Future<PickedMediaFile?> pickVideo() async {
    final result = await FilePicker.pickFiles(
      type: FileType.video,
      withData: true,
    );

    if (result == null || result.files.isEmpty) return null;

    final file = result.files.first;
    final bytes = file.bytes;
    if (bytes == null) return null;

    return PickedMediaFile(
      bytes: bytes,
      fileName: file.name,
      contentType: _resolveVideoContentType(file.extension),
    );
  }

  // SUBIDA Y BORRADO DE FOTOS DE PACIENTES
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
    try {
      await ref.delete();
    } on FirebaseException catch (e) {
      if (e.code != 'object-not-found') rethrow;
    }
  }

  // SUBIDA Y BORRADO DE ARCHIVOS MULTIMEDIA DE PLANTILLAS
  // Sube los bytes de una imagen asociada a un item de plantilla y devuelve su URL.
  Future<String> uploadTemplateItemImage({
    required String templateId,
    required String itemId,
    required Uint8List imageBytes,
  }) async {
    final ref = _storage.ref('templates/$templateId/$itemId/image');
    await ref.putData(imageBytes, SettableMetadata(contentType: 'image/jpeg'));
    return ref.getDownloadURL();
  }

  // Sube los bytes de un audio asociado a un item de plantilla y devuelve su URL.
  Future<String> uploadTemplateItemAudio({
    required String templateId,
    required String itemId,
    required Uint8List audioBytes,
    required String contentType,
  }) async {
    final ref = _storage.ref('templates/$templateId/$itemId/audio');
    await ref.putData(audioBytes, SettableMetadata(contentType: contentType));
    return ref.getDownloadURL();
  }

  // Sube los bytes de un vídeo asociado a un item de plantilla y devuelve su URL.
  Future<String> uploadTemplateItemVideo({
    required String templateId,
    required String itemId,
    required Uint8List videoBytes,
    required String contentType,
  }) async {
    final ref = _storage.ref('templates/$templateId/$itemId/video');
    await ref.putData(videoBytes, SettableMetadata(contentType: contentType));
    return ref.getDownloadURL();
  }

  // Elimina todos los archivos multimedia asociados a una plantilla completa.
  // Recorre todos los items que cuelgan de la plantilla y borra cada archivo encontrado. Se usa al eliminar una plantilla para evitar dejar archivos huérfanos en el bucket.
  Future<void> deleteAllTemplateMedia(String templateId) async {
    final folderRef = _storage.ref('templates/$templateId');
    try {
      final listing = await folderRef.listAll();

      // Borra los archivos directos colgando de la carpeta de la plantilla.
      for (final item in listing.items) {
        await item.delete();
      }

      // Recorre cada subcarpeta de item y borra todos sus archivos internos.
      for (final prefix in listing.prefixes) {
        final innerListing = await prefix.listAll();
        for (final item in innerListing.items) {
          await item.delete();
        }
      }
    } on FirebaseException catch (e) {
      if (e.code != 'object-not-found') rethrow;
    }
  }

  // Elimina los archivos multimedia de un item concreto de una plantilla.
  Future<void> deleteTemplateItemMedia({
    required String templateId,
    required String itemId,
  }) async {
    final folderRef = _storage.ref('templates/$templateId/$itemId');
    try {
      final listing = await folderRef.listAll();
      for (final item in listing.items) {
        await item.delete();
      }
    } on FirebaseException catch (e) {
      if (e.code != 'object-not-found') rethrow;
    }
  }

  // UTILIDADES PRIVADAS
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

  // Resuelve el contentType MIME a partir de la extensión del archivo de audio.
  String _resolveAudioContentType(String? extension) {
    switch (extension?.toLowerCase()) {
      case 'mp3':
        return 'audio/mpeg';
      case 'wav':
        return 'audio/wav';
      case 'ogg':
        return 'audio/ogg';
      case 'm4a':
        return 'audio/mp4';
      case 'aac':
        return 'audio/aac';
      default:
        return 'audio/mpeg';
    }
  }

  // Resuelve el contentType MIME a partir de la extensión del archivo de vídeo.
  String _resolveVideoContentType(String? extension) {
    switch (extension?.toLowerCase()) {
      case 'mp4':
        return 'video/mp4';
      case 'mov':
        return 'video/quicktime';
      case 'avi':
        return 'video/x-msvideo';
      case 'mkv':
        return 'video/x-matroska';
      case 'webm':
        return 'video/webm';
      default:
        return 'video/mp4';
    }
  }
}

// Representa un archivo multimedia seleccionado por el logopeda, listo para ser subido al bucket de Storage cuando finalice el wizard de la plantilla.
class PickedMediaFile {
  final Uint8List bytes;
  final String fileName;
  final String contentType;

  const PickedMediaFile({
    required this.bytes,
    required this.fileName,
    required this.contentType,
  });
}

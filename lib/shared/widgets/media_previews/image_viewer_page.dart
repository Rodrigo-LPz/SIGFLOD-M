import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

// Visor a pantalla completa para previsualizar una imagen con gestos de zoom y desplazamiento. Acepta una imagen procedente de bytes en memoria (durante el wizard antes de subir a Storage) o una URL pública (cuando ya está subida).
// Se navega a esta pantalla mediante un MaterialPageRoute con argumentos para que pueda usarse de forma reutilizable desde cualquier parte de la aplicación.
class ImageViewerPage extends StatelessWidget {
  // Bytes de la imagen cuando todavía no se ha subido a Storage.
  final Uint8List? imageBytes;

  // URL pública de la imagen cuando ya está subida a Storage.
  final String? imageUrl;

  const ImageViewerPage({super.key, this.imageBytes, this.imageUrl})
    : assert(
        imageBytes != null || imageUrl != null,
        'Debe proporcionarse imageBytes o imageUrl para mostrar la imagen.',
      );

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(t.mediaViewerImageTitle),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
          tooltip: t.mediaViewerClose,
        ),
      ),
      body: Column(
        children: [
          // Zona principal: imagen con gestos de zoom y desplazamiento.
          Expanded(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Center(child: _buildImage()),
            ),
          ),

          // Pista visual con la instruccion de uso del zoom.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              t.mediaViewerImageHint,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // Construye el widget de imagen apropiado segun la fuente disponible.
  Widget _buildImage() {
    if (imageBytes != null) {
      return Image.memory(imageBytes!, fit: BoxFit.contain);
    }
    return Image.network(imageUrl!, fit: BoxFit.contain);
  }
}

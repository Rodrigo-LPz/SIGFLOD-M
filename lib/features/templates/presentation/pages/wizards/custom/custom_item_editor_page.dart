import 'package:flutter/material.dart';

import '../../../../../../config/theme/app_spacing.dart';
import '../../../../../../config/theme/app_text_styles.dart';
import '../../../../../../core/services/image_service.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/widgets/app_button.dart';
import '../../../../../../shared/widgets/app_card.dart';
import '../../../../../../shared/widgets/app_text_field.dart';
import '../../../../../../shared/widgets/media_previews/audio_player_page.dart';
import '../../../../../../shared/widgets/media_previews/image_viewer_page.dart';
import '../../../../../../shared/widgets/media_previews/video_player_page.dart';
import '../../../../domain/models/items/custom_item_draft.dart';

// Pantalla aparte donde el logopeda edita un item de plantilla Personalizada, gestionando su texto y sus archivos multimedia opcionales (imagen, audio y vídeo). Los archivos seleccionados permanecen en memoria como bytes y solo se subirán al bucket de Storage cuando se finalice el wizard completo.
class CustomItemEditorPage extends StatefulWidget {
  const CustomItemEditorPage({super.key});

  @override
  State<CustomItemEditorPage> createState() => _CustomItemEditorPageState();
}

class _CustomItemEditorPageState extends State<CustomItemEditorPage> {
  // Controlador del campo de texto del item.
  late final TextEditingController _textController;

  // Borrador actualmente editado en pantalla.
  late CustomItemDraft _draft;

  // Indica si la pantalla está editando un item existente o creando uno nuevo.
  bool _isEditing = false;

  // Evita procesar los argumentos más de una vez por instancia.
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    // Inicializa un borrador vacío como fallback hasta procesar los argumentos.
    _draft = CustomItemDraft(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: '',
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      final args = ModalRoute.of(context)?.settings.arguments;

      if (args is CustomItemDraft) {
        _draft = args;
        _textController.text = args.text;
        _isEditing = true;
      }

      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  // Abre el selector adecuado para añadir o cambiar la imagen del item.
  Future<void> _pickImage() async {
    final t = AppLocalizations.of(context)!;
    final cameraAvailable = ImageService.instance.isCameraAvailable;

    // Si la cámara no está disponible, abre la galería directamente.
    if (!cameraAvailable) {
      final bytes = await ImageService.instance.pickFromGallery();
      if (bytes == null) return;
      setState(() {
        _draft = _draft.copyWith(imageBytes: bytes, imageUrl: null);
      });
      return;
    }

    // En móvil ofrece elegir entre galería y cámara.
    final source = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text(t.choosePhotoSource, style: AppTextStyles.title),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text(t.photoFromGallery),
                onTap: () => Navigator.pop(sheetContext, 'gallery'),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: Text(t.photoFromCamera),
                onTap: () => Navigator.pop(sheetContext, 'camera'),
              ),
            ],
          ),
        );
      },
    );

    if (source == null) return;

    final bytes = source == 'gallery'
        ? await ImageService.instance.pickFromGallery()
        : await ImageService.instance.pickFromCamera();

    if (bytes == null) return;

    setState(() {
      _draft = _draft.copyWith(imageBytes: bytes, imageUrl: null);
    });
  }

  // Pide confirmación al logopeda y elimina la imagen del borrador.
  Future<void> _removeImage() async {
    final t = AppLocalizations.of(context)!;
    final confirmed = await _confirm(
      title: t.customItemConfirmRemoveImageTitle,
      message: t.customItemConfirmRemoveImageMessage,
    );
    if (!confirmed) return;
    setState(() {
      _draft = _draft.copyWith(clearImage: true);
    });
  }

  // Abre el selector de audios y guarda el archivo seleccionado en el borrador.
  Future<void> _pickAudio() async {
    final picked = await ImageService.instance.pickAudio();
    if (picked == null) return;
    setState(() {
      _draft = _draft.copyWith(
        audioBytes: picked.bytes,
        audioContentType: picked.contentType,
        audioUrl: null,
      );
    });
  }

  // Pide confirmación al logopeda y elimina el audio del borrador.
  Future<void> _removeAudio() async {
    final t = AppLocalizations.of(context)!;
    final confirmed = await _confirm(
      title: t.customItemConfirmRemoveAudioTitle,
      message: t.customItemConfirmRemoveAudioMessage,
    );
    if (!confirmed) return;
    setState(() {
      _draft = _draft.copyWith(clearAudio: true);
    });
  }

  // Abre el selector de vídeos y guarda el archivo seleccionado en el borrador.
  Future<void> _pickVideo() async {
    final picked = await ImageService.instance.pickVideo();
    if (picked == null) return;
    setState(() {
      _draft = _draft.copyWith(
        videoBytes: picked.bytes,
        videoContentType: picked.contentType,
        videoUrl: null,
      );
    });
  }

  // Pide confirmación al logopeda y elimina el vídeo del borrador.
  Future<void> _removeVideo() async {
    final t = AppLocalizations.of(context)!;
    final confirmed = await _confirm(
      title: t.customItemConfirmRemoveVideoTitle,
      message: t.customItemConfirmRemoveVideoMessage,
    );
    if (!confirmed) return;
    setState(() {
      _draft = _draft.copyWith(clearVideo: true);
    });
  }

  // Abre el visor de imagen a pantalla completa con la imagen actual del item.
  void _previewImage() {
    if (!_draft.hasImage) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ImageViewerPage(
          imageBytes: _draft.imageBytes,
          imageUrl: _draft.imageUrl,
        ),
      ),
    );
  }

  // Abre el reproductor de audio a pantalla completa con el audio actual del item.
  void _previewAudio() {
    if (!_draft.hasAudio) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AudioPlayerPage(
          audioBytes: _draft.audioBytes,
          audioContentType: _draft.audioContentType,
          audioUrl: _draft.audioUrl,
        ),
      ),
    );
  }

  // Abre el reproductor de vídeo a pantalla completa con el vídeo actual del item.
  void _previewVideo() {
    if (!_draft.hasVideo) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VideoPlayerPage(
          videoBytes: _draft.videoBytes,
          videoUrl: _draft.videoUrl,
        ),
      ),
    );
  }

  // Muestra un diálogo de confirmación reutilizable.
  Future<bool> _confirm({
    required String title,
    required String message,
  }) async {
    final t = AppLocalizations.of(context)!;
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(t.cancelAction),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(
                t.confirmAction,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
    return result == true;
  }

  // Valida los campos y devuelve el borrador completo a la pantalla anterior.
  void _saveItem() {
    final t = AppLocalizations.of(context)!;
    final text = _textController.text.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.customItemErrorEmptyText)));
      return;
    }

    final updated = _draft.copyWith(text: text);
    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? t.customItemEditorTitleEdit : t.customItemEditorTitleNew,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: ListView(
          children: [
            const SizedBox(height: AppSpacing.sm),

            AppTextField(
              label: t.customItemTextLabel,
              hint: t.customItemTextHint,
              controller: _textController,
              maxLines: 3,
            ),

            const SizedBox(height: AppSpacing.xl),

            // SECCIÓN IMAGEN
            Text(t.customItemSectionImage, style: AppTextStyles.title),
            const SizedBox(height: AppSpacing.sm),
            _MediaPreviewSection(
              hasMedia: _draft.hasImage,
              previewBuilder: () {
                if (_draft.imageBytes != null) {
                  return Image.memory(
                    _draft.imageBytes!,
                    height: 160,
                    fit: BoxFit.cover,
                  );
                }
                if (_draft.imageUrl != null) {
                  return Image.network(
                    _draft.imageUrl!,
                    height: 160,
                    fit: BoxFit.cover,
                  );
                }
                return const SizedBox.shrink();
              },
              previewLabel: t.customItemImagePreview,
              addLabel: t.customItemAddImage,
              changeLabel: t.customItemChangeImage,
              removeLabel: t.customItemRemoveImage,
              onPick: _pickImage,
              onRemove: _removeImage,
              onPreview: _previewImage,
            ),

            const SizedBox(height: AppSpacing.xl),

            // SECCIÓN AUDIO
            Text(t.customItemSectionAudio, style: AppTextStyles.title),
            const SizedBox(height: AppSpacing.sm),
            _MediaPreviewSection(
              hasMedia: _draft.hasAudio,
              previewBuilder: () => _MediaFilePreview(
                icon: Icons.audiotrack,
                label: t.customItemAudioPreview,
              ),
              previewLabel: t.customItemAudioPreview,
              addLabel: t.customItemAddAudio,
              changeLabel: t.customItemChangeAudio,
              removeLabel: t.customItemRemoveAudio,
              onPick: _pickAudio,
              onRemove: _removeAudio,
              onPreview: _previewAudio,
            ),

            const SizedBox(height: AppSpacing.xl),

            // SECCIÓN VÍDEO
            Text(t.customItemSectionVideo, style: AppTextStyles.title),
            const SizedBox(height: AppSpacing.sm),
            _MediaPreviewSection(
              hasMedia: _draft.hasVideo,
              previewBuilder: () => _MediaFilePreview(
                icon: Icons.videocam,
                label: t.customItemVideoPreview,
              ),
              previewLabel: t.customItemVideoPreview,
              addLabel: t.customItemAddVideo,
              changeLabel: t.customItemChangeVideo,
              removeLabel: t.customItemRemoveVideo,
              onPick: _pickVideo,
              onRemove: _removeVideo,
              onPreview: _previewVideo,
            ),

            const SizedBox(height: AppSpacing.xl),

            AppButton(label: t.customItemSaveButton, onPressed: _saveItem),
          ],
        ),
      ),
    );
  }
}

// Sección reutilizable para gestionar uno de los tres archivos multimedia.
// Cuando el item ya tiene un archivo asignado se muestran tres acciones: la previsualización a pantalla completa, el reemplazo del archivo actual y la eliminación. Además, la propia previsualización integrada es tappable como atajo equivalente al botón de previsualización a pantalla completa.
class _MediaPreviewSection extends StatelessWidget {
  final bool hasMedia;
  final Widget Function() previewBuilder;
  final String previewLabel;
  final String addLabel;
  final String changeLabel;
  final String removeLabel;
  final VoidCallback onPick;
  final VoidCallback onRemove;
  final VoidCallback onPreview;

  const _MediaPreviewSection({
    required this.hasMedia,
    required this.previewBuilder,
    required this.previewLabel,
    required this.addLabel,
    required this.changeLabel,
    required this.removeLabel,
    required this.onPick,
    required this.onRemove,
    required this.onPreview,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasMedia) {
      return AppButton(label: addLabel, onPressed: onPick);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Previsualizacion integrada que tambien abre el visor al pulsarla.
        InkWell(
          onTap: onPreview,
          borderRadius: BorderRadius.circular(8),
          child: AppCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: previewBuilder(),
                ),
                // Icono superpuesto que indica que la zona es interactiva.
                Positioned(
                  right: AppSpacing.sm,
                  bottom: AppSpacing.sm,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.open_in_full,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // Boton explicito de previsualizacion para mayor descubribilidad.
        AppButton(label: previewLabel, onPressed: onPreview),

        const SizedBox(height: AppSpacing.sm),

        // Acciones complementarias para reemplazar o eliminar el archivo.
        Row(
          children: [
            Expanded(
              child: AppButton(label: changeLabel, onPressed: onPick),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: AppButton(
                label: removeLabel,
                onPressed: onRemove,
                isDestructive: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Vista previa simple para archivos de audio o vídeo, que no pueden mostrarse inline durante el wizard sin reproductores especializados. Muestra un icono representativo junto al nombre genérico del tipo de archivo seleccionado.
class _MediaFilePreview extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MediaFilePreview({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40),
          const SizedBox(width: AppSpacing.md),
          Text(label, style: AppTextStyles.body),
        ],
      ),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../../../l10n/app_localizations.dart';
import 'playback_speed_selector.dart';

// Reproductor a pantalla completa para previsualizar archivos de vídeo dentro del wizard de plantillas y durante las sesiones de intervención. Acepta el vídeo procedente de bytes en memoria (mientras se construye la plantilla) o de una URL pública (cuando ya está subido a Storage).
// Internamente utiliza media_kit, que unifica audio y vídeo en una única implementación multiplataforma con soporte para todos los formatos habituales, incluyendo la reproducción directa de bytes en navegador sin archivos temporales en disco.
class VideoPlayerPage extends StatefulWidget {
  // Bytes del vídeo cuando todavía no se ha subido a Storage.
  final Uint8List? videoBytes;

  // URL pública del vídeo cuando ya está subido a Storage.
  final String? videoUrl;

  // Nombre del archivo mostrado como referencia visual al logopeda.
  final String fileName;

  const VideoPlayerPage({
    super.key,
    this.videoBytes,
    this.videoUrl,
    this.fileName = '',
  }) : assert(
         videoBytes != null || videoUrl != null,
         'Debe proporcionarse videoBytes o videoUrl para reproducir el vídeo.',
       );

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  // Instancia del reproductor multimedia nativo del paquete media_kit.
  late final Player _player;

  // Controlador del widget de vídeo que renderiza la salida del reproductor.
  late final VideoController _videoController;

  // Indica si el vídeo ha terminado de cargarse y está listo para reproducir.
  bool _isReady = false;

  // Indica si la carga del vídeo ha fallado.
  bool _hasError = false;

  // Posición visual de la barra mientras el usuario la está arrastrando, independiente de la posición real del reproductor para evitar sobrecargarlo con peticiones de decodificación de frames durante el arrastre.
  double? _dragPosition;

  @override
  void initState() {
    super.initState();
    _player = Player();
    _videoController = VideoController(_player);
    _initializeVideo();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  // Carga el vídeo en el reproductor desde bytes en memoria o desde la URL.
  Future<void> _initializeVideo() async {
    try {
      if (widget.videoBytes != null) {
        // media_kit reproduce bytes directamente sin necesidad de archivos temporales en disco, funcionando incluso en navegadores web.
        await _player.open(await Media.memory(widget.videoBytes!), play: false);
      } else {
        await _player.open(Media(widget.videoUrl!), play: false);
      }

      if (!mounted) return;
      setState(() {
        _isReady = true;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _hasError = true;
      });
    }
  }

  // Alterna entre reproducir y pausar el vídeo según su estado actual.
  Future<void> _togglePlay() async {
    await _player.playOrPause();
  }

  // Retrocede la posición actual del reproductor diez segundos.
  Future<void> _skipBackward() async {
    final current = _player.state.position;
    final newPosition = current - const Duration(seconds: 10);
    await _player.seek(
      newPosition < Duration.zero ? Duration.zero : newPosition,
    );
  }

  // Avanza la posición actual del reproductor diez segundos.
  Future<void> _skipForward() async {
    final current = _player.state.position;
    final total = _player.state.duration;
    final newPosition = current + const Duration(seconds: 10);
    await _player.seek(newPosition > total ? total : newPosition);
  }

  // Aplica al reproductor la velocidad seleccionada por el usuario.
  Future<void> _changeSpeed(double speed) async {
    await _player.setRate(speed);
  }

  // Formatea una duración en el formato mm:ss para mostrarla al usuario.
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(t.mediaViewerVideoTitle),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
          tooltip: t.mediaViewerClose,
        ),
      ),
      body: _buildBody(t),
    );
  }

  // Construye el cuerpo del reproductor según el estado actual de carga.
  Widget _buildBody(AppLocalizations t) {
    if (_hasError) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          t.mediaViewerErrorLoad,
          style: const TextStyle(color: Colors.white70),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (!_isReady) {
      return const CircularProgressIndicator(color: Colors.white);
    }

    return SafeArea(
      child: Column(
        children: [
          // El vídeo se expande para ocupar todo el espacio disponible que dejan
          // los controles inferiores, manteniendo su proporción 16:9 centrado.
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Video(
                  controller: _videoController,
                  controls: NoVideoControls,
                ),
              ),
            ),
          ),

          // Bloque de controles fijo en la parte inferior de la pantalla.
          _buildControls(t),
        ],
      ),
    );
  }

  // Construye el bloque de controles fijo bajo el vídeo.
  Widget _buildControls(AppLocalizations t) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: Colors.white12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Nombre del archivo de vídeo cargado como referencia visual.
          if (widget.fileName.isNotEmpty) ...[
            Text(
              widget.fileName,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
          ],

          // Barra de progreso interactiva con el tiempo actual y total.
          // La posición mostrada usa el valor del arrastre si el usuario está manipulando la barra, y la posición real del reproductor en caso contrario. El seek al reproductor se ejecuta una única vez al soltar la barra para no sobrecargar la decodificación de frames.
          StreamBuilder<Duration>(
            stream: _player.stream.position,
            builder: (context, positionSnapshot) {
              return StreamBuilder<Duration>(
                stream: _player.stream.duration,
                builder: (context, durationSnapshot) {
                  final position = positionSnapshot.data ?? Duration.zero;
                  final total = durationSnapshot.data ?? Duration.zero;
                  final maxSeconds = total.inMilliseconds.toDouble().clamp(
                    1,
                    double.infinity,
                  );
                  final realSeconds = position.inMilliseconds
                      .toDouble()
                      .clamp(0, maxSeconds)
                      .toDouble();
                  final displaySeconds = _dragPosition ?? realSeconds;
                  final displayDuration = Duration(
                    milliseconds: displaySeconds.toInt(),
                  );

                  return Column(
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 2,
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 14,
                          ),
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 7,
                          ),
                        ),
                        child: Slider(
                          value: displaySeconds.clamp(0, maxSeconds).toDouble(),
                          min: 0,
                          max: maxSeconds.toDouble(),
                          onChanged: (newValue) {
                            setState(() {
                              _dragPosition = newValue;
                            });
                          },
                          onChangeEnd: (newValue) async {
                            await _player.seek(
                              Duration(milliseconds: newValue.toInt()),
                            );
                            if (!mounted) return;
                            setState(() {
                              _dragPosition = null;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(displayDuration),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              _formatDuration(total),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),

          const SizedBox(height: 8),

          // Fila central con los controles principales del reproductor.
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Botón para retroceder diez segundos en el vídeo.
              IconButton(
                iconSize: 40,
                color: Colors.white,
                tooltip: t.mediaViewerSkipBack,
                icon: const Icon(Icons.replay_10),
                onPressed: _skipBackward,
              ),

              const SizedBox(width: 12),

              // Botón principal de reproducir o pausar el vídeo.
              StreamBuilder<bool>(
                stream: _player.stream.playing,
                builder: (context, snapshot) {
                  final isPlaying = snapshot.data ?? false;
                  return IconButton(
                    iconSize: 56,
                    color: Colors.white,
                    tooltip: isPlaying
                        ? t.mediaViewerAudioPause
                        : t.mediaViewerAudioPlay,
                    icon: Icon(
                      isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                    ),
                    onPressed: _togglePlay,
                  );
                },
              ),

              const SizedBox(width: 12),

              // Botón para avanzar diez segundos en el vídeo.
              IconButton(
                iconSize: 40,
                color: Colors.white,
                tooltip: t.mediaViewerSkipForward,
                icon: const Icon(Icons.forward_10),
                onPressed: _skipForward,
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Selector de velocidad de reproducción disponible al usuario.
          StreamBuilder<double>(
            stream: _player.stream.rate,
            builder: (context, snapshot) {
              final currentSpeed = snapshot.data ?? 1.0;
              return PlaybackSpeedSelector(
                currentSpeed: currentSpeed,
                onSpeedChanged: _changeSpeed,
              );
            },
          ),
        ],
      ),
    );
  }
}

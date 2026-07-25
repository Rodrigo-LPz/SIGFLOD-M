import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';

import '../../../l10n/app_localizations.dart';
import 'playback_speed_selector.dart';

// Reproductor a pantalla completa para previsualizar archivos de audio dentro del wizard de plantillas y durante las sesiones de intervención. Acepta el audio procedente de bytes en memoria (mientras se construye la plantilla) o de una URL pública (cuando ya está subido a Storage). Internamente utiliza media_kit, que unifica audio y vídeo en una única implementación multiplataforma con soporte para todos los formatos habituales.
class AudioPlayerPage extends StatefulWidget {
  // Bytes del audio cuando todavía no se ha subido a Storage.
  final Uint8List? audioBytes;

  // Tipo MIME del audio necesario para reproducir bytes en memoria.
  final String? audioContentType;

  // URL pública del audio cuando ya está subido a Storage.
  final String? audioUrl;

  // Nombre del archivo mostrado como referencia visual al logopeda.
  final String fileName;

  const AudioPlayerPage({
    super.key,
    this.audioBytes,
    this.audioContentType,
    this.audioUrl,
    this.fileName = '',
  }) : assert(
         audioBytes != null || audioUrl != null,
         'Debe proporcionarse audioBytes o audioUrl para reproducir el audio.',
       );

  @override
  State<AudioPlayerPage> createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  // Instancia del reproductor multimedia nativo del paquete media_kit.
  late final Player _player;

  // Indica si el audio ha terminado de cargarse y está listo para reproducir.
  bool _isReady = false;

  // Indica si la carga del audio ha fallado.
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _player = Player();
    _initializeAudio();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  // Carga el audio en el reproductor desde bytes en memoria o desde la URL.
  Future<void> _initializeAudio() async {
    try {
      if (widget.audioBytes != null) {
        // media_kit reproduce bytes mediante una fuente de datos en memoria
        // utilizando el protocolo nativo de libmpv, que lee directamente desde
        // el buffer sin necesidad de archivos temporales en disco.
        await _player.open(await Media.memory(widget.audioBytes!), play: false);
      } else {
        await _player.open(Media(widget.audioUrl!), play: false);
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

  // Alterna entre reproducir y pausar el audio según su estado actual.
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
        title: Text(t.mediaViewerAudioTitle),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
          tooltip: t.mediaViewerClose,
        ),
      ),
      body: Center(child: _buildBody(t)),
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icono representativo y nombre del archivo de audio cargado.
          const Icon(Icons.audiotrack, size: 96, color: Colors.white70),
          if (widget.fileName.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              widget.fileName,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          const SizedBox(height: 48),

          // Barra de progreso con los tiempos actuales del reproductor.
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
                  final currentSeconds = position.inMilliseconds
                      .toDouble()
                      .clamp(0, maxSeconds);

                  return Column(
                    children: [
                      Slider(
                        value: currentSeconds.toDouble(),
                        min: 0,
                        max: maxSeconds.toDouble(),
                        onChanged: (value) {
                          _player.seek(Duration(milliseconds: value.toInt()));
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(position),
                              style: const TextStyle(color: Colors.white70),
                            ),
                            Text(
                              _formatDuration(total),
                              style: const TextStyle(color: Colors.white70),
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
          const SizedBox(height: 32),

          // Fila central con los controles principales del reproductor.
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Botón para retroceder diez segundos en el audio.
              IconButton(
                iconSize: 48,
                color: Colors.white,
                tooltip: t.mediaViewerSkipBack,
                icon: const Icon(Icons.replay_10),
                onPressed: _skipBackward,
              ),

              const SizedBox(width: 16),

              // Botón principal de reproducir o pausar el audio.
              StreamBuilder<bool>(
                stream: _player.stream.playing,
                builder: (context, snapshot) {
                  final isPlaying = snapshot.data ?? false;
                  return IconButton(
                    iconSize: 72,
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

              const SizedBox(width: 16),

              // Botón para avanzar diez segundos en el audio.
              IconButton(
                iconSize: 48,
                color: Colors.white,
                tooltip: t.mediaViewerSkipForward,
                icon: const Icon(Icons.forward_10),
                onPressed: _skipForward,
              ),
            ],
          ),

          const SizedBox(height: 16),

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

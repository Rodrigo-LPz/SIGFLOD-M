import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

// Selector avanzado de velocidad de reproducción reutilizable en cualquiera de los reproductores multimedia de la aplicación. Presenta un menú desplegable con un slider continuo (para velocidad arbitraria de precisión fina) y una fila de botones rápidos con los valores estándar más habituales, permitiendo tanto ajuste libre como selección directa según la preferencia del logopeda en cada momento.
class PlaybackSpeedSelector extends StatelessWidget {
  // Velocidades rápidas fijas mostradas como accesos directos bajo el slider.
  static const List<double> _quickSpeeds = [2.0, 1.5, 1.25, 1.0, 0.75, 0.5];

  // Velocidad mínima permitida por el slider en su extremo inferior.
  static const double minSpeed = 0.25;

  // Velocidad máxima permitida por el slider en su extremo superior.
  static const double maxSpeed = 2.0;

  // Salto de precisión de cada paso del slider al desplazarse.
  static const double stepSpeed = 0.05;

  // Velocidad actualmente aplicada al reproductor asociado.
  final double currentSpeed;

  // Callback ejecutado cuando el usuario selecciona una velocidad concreta.
  final ValueChanged<double> onSpeedChanged;

  const PlaybackSpeedSelector({
    super.key,
    required this.currentSpeed,
    required this.onSpeedChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return _SpeedSelectorButton(
      currentSpeed: currentSpeed,
      onSpeedChanged: onSpeedChanged,
      quickSpeeds: _quickSpeeds,
      tooltip: t.mediaViewerSpeed,
      formatSpeed: _formatSpeed,
    );
  }

  // Formatea un valor de velocidad eliminando los decimales innecesarios y
  // limitando la precisión mostrada a dos posiciones significativas.
  static String _formatSpeed(double speed) {
    if (speed == speed.roundToDouble()) {
      return speed.toInt().toString();
    }
    // Redondea a dos decimales para evitar valores como 1.0500000000001.
    final rounded = (speed * 100).round() / 100;
    if (rounded == rounded.roundToDouble()) {
      return rounded.toInt().toString();
    }
    // Elimina el cero final innecesario (por ejemplo 1.10 se muestra como 1.1).
    final text = rounded.toString();
    return text.endsWith('0') ? text.substring(0, text.length - 1) : text;
  }
}

// Botón visual que abre el panel emergente con el selector de velocidad.
class _SpeedSelectorButton extends StatefulWidget {
  final double currentSpeed;
  final ValueChanged<double> onSpeedChanged;
  final List<double> quickSpeeds;
  final String tooltip;
  final String Function(double) formatSpeed;

  const _SpeedSelectorButton({
    required this.currentSpeed,
    required this.onSpeedChanged,
    required this.quickSpeeds,
    required this.tooltip,
    required this.formatSpeed,
  });

  @override
  State<_SpeedSelectorButton> createState() => _SpeedSelectorButtonState();
}

class _SpeedSelectorButtonState extends State<_SpeedSelectorButton> {
  // Clave necesaria para localizar la posición en pantalla del botón.
  final GlobalKey _buttonKey = GlobalKey();

  // Abre el panel emergente anclado a la posición del botón en pantalla.
  Future<void> _openPanel() async {
    final buttonContext = _buttonKey.currentContext;
    if (buttonContext == null) return;

    final buttonBox = buttonContext.findRenderObject() as RenderBox;
    final overlay =
        Overlay.of(buttonContext).context.findRenderObject() as RenderBox;

    final buttonPosition = buttonBox.localToGlobal(Offset.zero);
    final buttonSize = buttonBox.size;

    // Coloca el panel encima del botón, alineado a la derecha del mismo.
    final panelWidth = 260.0;
    final panelLeft = buttonPosition.dx + buttonSize.width - panelWidth;
    final panelBottom = overlay.size.height - buttonPosition.dy + 8;

    await showDialog<void>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (dialogContext) {
        return Stack(
          children: [
            // Zona invisible que cierra el panel al pulsar fuera de él.
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.pop(dialogContext),
              ),
            ),

            Positioned(
              left: panelLeft.clamp(8.0, overlay.size.width - panelWidth - 8),
              bottom: panelBottom,
              width: panelWidth,
              child: Material(
                color: Colors.transparent,
                child: _SpeedPanel(
                  initialSpeed: widget.currentSpeed,
                  quickSpeeds: widget.quickSpeeds,
                  formatSpeed: widget.formatSpeed,
                  onSpeedChanged: (value) {
                    widget.onSpeedChanged(value);
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: InkWell(
        key: _buttonKey,
        onTap: _openPanel,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white24),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.speed, color: Colors.white70, size: 18),
              const SizedBox(width: 6),
              Text(
                '${widget.formatSpeed(widget.currentSpeed)}x',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Panel emergente con el slider continuo y los botones rápidos de velocidad.
class _SpeedPanel extends StatefulWidget {
  final double initialSpeed;
  final List<double> quickSpeeds;
  final String Function(double) formatSpeed;
  final ValueChanged<double> onSpeedChanged;

  const _SpeedPanel({
    required this.initialSpeed,
    required this.quickSpeeds,
    required this.formatSpeed,
    required this.onSpeedChanged,
  });

  @override
  State<_SpeedPanel> createState() => _SpeedPanelState();
}

class _SpeedPanelState extends State<_SpeedPanel> {
  // Velocidad actualmente reflejada en la barra deslizante del panel.
  late double _selectedSpeed;

  @override
  void initState() {
    super.initState();
    _selectedSpeed = widget.initialSpeed;
  }

  // Actualiza la velocidad seleccionada y la propaga al reproductor asociado.
  void _updateSpeed(double newSpeed) {
    setState(() {
      _selectedSpeed = newSpeed;
    });
    widget.onSpeedChanged(newSpeed);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Cabecera con la velocidad exacta actualmente seleccionada.
          Center(
            child: Text(
              '${widget.formatSpeed(_selectedSpeed)}x',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Barra deslizante continua con precisión fina para ajustar velocidad.
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white24,
              thumbColor: Colors.white,
              overlayColor: Colors.white24,
              trackHeight: 3,
            ),
            child: Slider(
              value: _selectedSpeed.clamp(
                PlaybackSpeedSelector.minSpeed,
                PlaybackSpeedSelector.maxSpeed,
              ),
              min: PlaybackSpeedSelector.minSpeed,
              max: PlaybackSpeedSelector.maxSpeed,
              divisions:
                  ((PlaybackSpeedSelector.maxSpeed -
                              PlaybackSpeedSelector.minSpeed) /
                          PlaybackSpeedSelector.stepSpeed)
                      .round(),
              onChanged: _updateSpeed,
            ),
          ),

          const SizedBox(height: 4),

          // Etiquetas de referencia con los extremos del rango del slider.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.formatSpeed(PlaybackSpeedSelector.minSpeed)}x',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
              Text(
                '${widget.formatSpeed(PlaybackSpeedSelector.maxSpeed)}x',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Fila de botones rápidos con las velocidades estándar más comunes.
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: widget.quickSpeeds.map((speed) {
              final isSelected = (_selectedSpeed - speed).abs() < 0.001;
              return _QuickSpeedChip(
                label: '${widget.formatSpeed(speed)}x',
                selected: isSelected,
                onTap: () => _updateSpeed(speed),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// Chip visual reutilizable para las velocidades rápidas del panel emergente.
class _QuickSpeedChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _QuickSpeedChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          border: Border.all(color: Colors.white38),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.black : Colors.white,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

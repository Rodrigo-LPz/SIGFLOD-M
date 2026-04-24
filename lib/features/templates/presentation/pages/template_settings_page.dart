import 'package:flutter/material.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../domain/models/template_model.dart';

// 🔹 Pantalla de ajustes finales de la plantilla
class TemplateSettingsPage extends StatefulWidget {
  const TemplateSettingsPage({super.key});

  @override
  State<TemplateSettingsPage> createState() => _TemplateSettingsPageState();
}

// 🔹 Estado interno de la pantalla
class _TemplateSettingsPageState extends State<TemplateSettingsPage> {
  // 🔹 Plantilla recibida del paso anterior
  TemplateModel? _template;

  // 🔹 Valores editables de configuración
  int _repetitions = 3;
  int _timeLimitMinutes = 3;
  bool _guidedMode = true;
  bool _soundsEnabled = true;
  bool _feedbackEnabled = true;
  bool _positiveReinforcementEnabled = true;

  // 🔹 Evita reinicializar al reconstruir
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 🔹 Solo inicializamos una vez usando los argumentos de navegación
    if (!_isInitialized) {
      final args = ModalRoute.of(context)?.settings.arguments;

      // 🔹 Si llega una plantilla válida, cargamos sus datos
      if (args is TemplateModel) {
        _template = args;
        _repetitions = args.repetitions;
        _timeLimitMinutes = args.timeLimitMinutes;
        _guidedMode = args.guidedMode;
        _soundsEnabled = args.soundsEnabled;
        _feedbackEnabled = args.feedbackEnabled;
        _positiveReinforcementEnabled = args.positiveReinforcementEnabled;
      }

      _isInitialized = true;
    }
  }

  // 🔹 Continúa al siguiente paso enviando la plantilla actualizada
  void _goToPreview() {
    // 🔹 Si no hay plantilla base, no podemos continuar
    if (_template == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo recuperar la plantilla configurada.'),
        ),
      );
      return;
    }

    // 🔹 Construimos la plantilla final con los ajustes actuales
    final updatedTemplate = _template!.copyWith(
      repetitions: _repetitions,
      timeLimitMinutes: _timeLimitMinutes,
      guidedMode: _guidedMode,
      soundsEnabled: _soundsEnabled,
      feedbackEnabled: _feedbackEnabled,
      positiveReinforcementEnabled: _positiveReinforcementEnabled,
    );

    // 🔹 Navegamos a la previsualización enviando la plantilla completa
    Navigator.pushNamed(
      context,
      AppRoutes.templatePreview,
      arguments: updatedTemplate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes Finales'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: ListView(
          children: [
            const SizedBox(height: AppSpacing.sm),

            // 🔹 Ajuste de repeticiones
            _CounterSetting(
              title: 'Nº de Repeticiones',
              value: _repetitions,
              onDecrement: () {
                if (_repetitions > 1) {
                  setState(() {
                    _repetitions--;
                  });
                }
              },
              onIncrement: () {
                setState(() {
                  _repetitions++;
                });
              },
            ),

            const SizedBox(height: AppSpacing.lg),

            // 🔹 Ajuste de modo guiado
            _SwitchSetting(
              title: 'Modo Guiado',
              value: _guidedMode,
              onChanged: (value) {
                setState(() {
                  _guidedMode = value;
                });
              },
            ),

            const SizedBox(height: AppSpacing.lg),

            // 🔹 Ajuste de tiempo límite
            _CounterSetting(
              title: 'Tiempo Límite (min)',
              value: _timeLimitMinutes,
              onDecrement: () {
                if (_timeLimitMinutes > 1) {
                  setState(() {
                    _timeLimitMinutes--;
                  });
                }
              },
              onIncrement: () {
                setState(() {
                  _timeLimitMinutes++;
                });
              },
            ),

            const SizedBox(height: AppSpacing.lg),

            // 🔹 Ajuste de sonidos
            _SwitchSetting(
              title: 'Sonidos',
              value: _soundsEnabled,
              onChanged: (value) {
                setState(() {
                  _soundsEnabled = value;
                });
              },
            ),

            const SizedBox(height: AppSpacing.lg),

            // 🔹 Ajuste de retroalimentación
            _SwitchSetting(
              title: 'Retroalimentación',
              value: _feedbackEnabled,
              onChanged: (value) {
                setState(() {
                  _feedbackEnabled = value;
                });
              },
            ),

            const SizedBox(height: AppSpacing.lg),

            // 🔹 Ajuste de refuerzo positivo
            _SwitchSetting(
              title: 'Refuerzo Positivo',
              value: _positiveReinforcementEnabled,
              onChanged: (value) {
                setState(() {
                  _positiveReinforcementEnabled = value;
                });
              },
            ),

            const SizedBox(height: AppSpacing.xl),

            // 🔹 Botón para abrir la previsualización real
            AppButton(
              label: 'Previsualizar',
              onPressed: _goToPreview,
            ),
          ],
        ),
      ),
    );
  }
}

// 🔹 Widget reutilizable para contadores numéricos
class _CounterSetting extends StatelessWidget {
  final String title;
  final int value;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _CounterSetting({
    required this.title,
    required this.value,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 Nombre del ajuste
        Text(
          title,
          style: AppTextStyles.body,
        ),

        const SizedBox(height: AppSpacing.sm),

        // 🔹 Fila de decremento / valor / incremento
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: onDecrement,
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text(
              '$value',
              style: AppTextStyles.title,
            ),
            IconButton(
              onPressed: onIncrement,
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ],
    );
  }
}

// 🔹 Widget reutilizable para ajustes booleanos
class _SwitchSetting extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchSetting({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 🔹 Nombre del ajuste
        Text(
          title,
          style: AppTextStyles.body,
        ),

        // 🔹 Interruptor real conectado al estado
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
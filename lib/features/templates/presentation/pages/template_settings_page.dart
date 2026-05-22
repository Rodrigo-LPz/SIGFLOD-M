import 'package:flutter/material.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../domain/models/template_model.dart';

// Pantalla de ajustes finales de la plantilla antes de la previsualización.
class TemplateSettingsPage extends StatefulWidget {
  const TemplateSettingsPage({super.key});

  @override
  State<TemplateSettingsPage> createState() => _TemplateSettingsPageState();
}

class _TemplateSettingsPageState extends State<TemplateSettingsPage> {
  // Almacena la plantilla recibida desde el paso anterior.
  TemplateModel? _template;

  // Mantiene los valores actualmente editables de la plantilla.
  int _repetitions = 3;
  int _timeLimitMinutes = 3;
  bool _guidedMode = true;
  bool _soundsEnabled = true;
  bool _feedbackEnabled = true;
  bool _positiveReinforcementEnabled = true;

  // Evita reinicializar los valores al reconstruir el widget.
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      final args = ModalRoute.of(context)?.settings.arguments;

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

  // Construye la plantilla con los ajustes actuales y abre la previsualización.
  void _goToPreview() {
    final t = AppLocalizations.of(context)!;

    if (_template == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.errorTemplateConfigMissing)));
      return;
    }

    final updatedTemplate = _template!.copyWith(
      repetitions: _repetitions,
      timeLimitMinutes: _timeLimitMinutes,
      guidedMode: _guidedMode,
      soundsEnabled: _soundsEnabled,
      feedbackEnabled: _feedbackEnabled,
      positiveReinforcementEnabled: _positiveReinforcementEnabled,
    );

    Navigator.pushNamed(
      context,
      AppRoutes.templatePreview,
      arguments: updatedTemplate,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.finalSettingsTitle), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: ListView(
          children: [
            const SizedBox(height: AppSpacing.sm),

            _CounterSetting(
              title: t.repetitionsSetting,
              value: _repetitions,
              onDecrement: () {
                if (_repetitions > 1) {
                  setState(() => _repetitions--);
                }
              },
              onIncrement: () => setState(() => _repetitions++),
            ),

            const SizedBox(height: AppSpacing.lg),

            _SwitchSetting(
              title: t.guidedModeSetting,
              value: _guidedMode,
              onChanged: (value) => setState(() => _guidedMode = value),
            ),

            const SizedBox(height: AppSpacing.lg),

            _CounterSetting(
              title: t.timeLimitSetting,
              value: _timeLimitMinutes,
              onDecrement: () {
                if (_timeLimitMinutes > 1) {
                  setState(() => _timeLimitMinutes--);
                }
              },
              onIncrement: () => setState(() => _timeLimitMinutes++),
            ),

            const SizedBox(height: AppSpacing.lg),

            _SwitchSetting(
              title: t.soundsSetting,
              value: _soundsEnabled,
              onChanged: (value) => setState(() => _soundsEnabled = value),
            ),

            const SizedBox(height: AppSpacing.lg),

            _SwitchSetting(
              title: t.feedbackSetting,
              value: _feedbackEnabled,
              onChanged: (value) => setState(() => _feedbackEnabled = value),
            ),

            const SizedBox(height: AppSpacing.lg),

            _SwitchSetting(
              title: t.positiveReinforcementSetting,
              value: _positiveReinforcementEnabled,
              onChanged: (value) =>
                  setState(() => _positiveReinforcementEnabled = value),
            ),

            const SizedBox(height: AppSpacing.xl),

            AppButton(label: t.previewButton, onPressed: _goToPreview),
          ],
        ),
      ),
    );
  }
}

// Widget reutilizable para ajustes numéricos con contador.
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
        Text(title, style: AppTextStyles.body),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: onDecrement,
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text('$value', style: AppTextStyles.title),
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

// Widget reutilizable para ajustes booleanos con interruptor.
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
        Text(title, style: AppTextStyles.body),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}

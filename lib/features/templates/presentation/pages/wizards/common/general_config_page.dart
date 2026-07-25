import 'package:flutter/material.dart';

import '../../../../../../config/theme/app_spacing.dart';
import '../../../../../../config/theme/app_text_styles.dart';
import '../../../../../../core/routes/app_routes.dart';
import '../../../../../../core/utils/input_formatters.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/widgets/app_button.dart';
import '../../../../../../shared/widgets/app_text_field.dart';
import '../../../../domain/models/template_enums.dart';

// Pantalla común del wizard donde el logopeda introduce los datos generales de la plantilla, independientemente de su tipo.
// Recibe como argumento el código del TemplateType seleccionado en la pantalla anterior y, al pulsar Continuar, navega a la pantalla específica del tipo pasando una estructura con todos los datos recogidos hasta ese momento.
class WizardGeneralConfigPage extends StatefulWidget {
  const WizardGeneralConfigPage({super.key});

  @override
  State<WizardGeneralConfigPage> createState() =>
      _WizardGeneralConfigPageState();
}

class _WizardGeneralConfigPageState extends State<WizardGeneralConfigPage> {
  // Controladores de los campos editables de la pantalla.
  late final TextEditingController _nameController;
  late final TextEditingController _objectiveController;
  late final TextEditingController _recommendedAgeController;
  late final TextEditingController _observationsController;

  // Almacena el nivel actualmente seleccionado por el logopeda.
  TemplateLevel _selectedLevel = TemplateLevel.initial;

  // Almacena el tipo de plantilla recibido desde la pantalla anterior.
  TemplateType _selectedType = TemplateType.custom;

  // Evita procesar los argumentos más de una vez por instancia.
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _objectiveController = TextEditingController();
    _recommendedAgeController = TextEditingController();
    _observationsController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      final args = ModalRoute.of(context)?.settings.arguments;

      // La pantalla anterior pasa el código del tipo seleccionado.
      if (args is String && args.trim().isNotEmpty) {
        _selectedType = TemplateTypeMapper.fromCode(args);
      }

      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _objectiveController.dispose();
    _recommendedAgeController.dispose();
    _observationsController.dispose();
    super.dispose();
  }

  // Valida los campos y avanza a la siguiente pantalla del wizard.
  void _continueToNextStep() {
    final t = AppLocalizations.of(context)!;

    final name = _nameController.text.trim();
    final objective = _objectiveController.text.trim();
    final recommendedAge = _recommendedAgeController.text.trim();
    final observations = _observationsController.text.trim();

    if (name.isEmpty || objective.isEmpty || recommendedAge.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.errorTemplateRequiredFields)));
      return;
    }

    // Construye un mapa con los datos generales acumulados hasta ahora.
    // El wizard utiliza un mapa como contenedor de transferencia entre pantallas porque los datos van enriqueciéndose paso a paso y los distintos subtipos requieren campos diferentes según se avanza.
    final wizardData = <String, dynamic>{
      'type': _selectedType.code,
      'name': name,
      'objective': objective,
      'recommendedAge': recommendedAge,
      'level': _selectedLevel.code,
      'observations': observations,
    };

    // Determina la ruta del siguiente paso según el tipo elegido.
    final nextRoute = _resolveNextRouteForType(_selectedType);

    Navigator.pushNamed(context, nextRoute, arguments: wizardData);
  }

  // Devuelve la ruta del siguiente paso del wizard según el tipo recibido.
  // Custom no tiene pantalla específica de tipo y salta directamente al paso de contenido. El resto de tipos tendrán su propia pantalla de configuración específica antes del paso de contenido.
  String _resolveNextRouteForType(TemplateType type) {
    switch (type) {
      case TemplateType.custom:
        return AppRoutes.wizardCustomContent;
      case TemplateType.phonemes:
      case TemplateType.motor:
      case TemplateType.comprehension:
      case TemplateType.vocabulary:
      case TemplateType.sequences:
      case TemplateType.unknown:
        // TODO: MIGRACION_PLANTILLAS — Devolver la ruta de la pantalla específica de cada tipo cuando estén implementadas.
        return AppRoutes.wizardCustomContent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.templateConfigTitle(_selectedType.localized(context))),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: ListView(
          children: [
            const SizedBox(height: AppSpacing.sm),

            Text(t.basicConfigSection, style: AppTextStyles.title),
            const SizedBox(height: AppSpacing.md),

            AppTextField(
              label: t.templateNameLabel,
              controller: _nameController,
              inputFormatters: [
                AppInputFormatters.templateNameFormatter(
                  context: context,
                  errorMessage: t.errorInvalidTemplateNameChar,
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            AppTextField(
              label: t.objectiveLabel,
              controller: _objectiveController,
            ),

            const SizedBox(height: AppSpacing.md),

            AppTextField(
              label: t.recommendedAgeLabel,
              hint: t.recommendedAgeHint,
              controller: _recommendedAgeController,
              keyboardType: TextInputType.text,
              inputFormatters: [
                AppInputFormatters.ageRangeFormatter(
                  context: context,
                  errorMessage: t.errorInvalidAgeChar,
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            Text(t.levelLabel, style: AppTextStyles.body),

            const SizedBox(height: AppSpacing.sm),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _LevelChip(
                  label: TemplateLevel.initial.localized(context),
                  selected: _selectedLevel == TemplateLevel.initial,
                  onTap: () =>
                      setState(() => _selectedLevel = TemplateLevel.initial),
                ),
                _LevelChip(
                  label: TemplateLevel.medium.localized(context),
                  selected: _selectedLevel == TemplateLevel.medium,
                  onTap: () =>
                      setState(() => _selectedLevel = TemplateLevel.medium),
                ),
                _LevelChip(
                  label: TemplateLevel.advanced.localized(context),
                  selected: _selectedLevel == TemplateLevel.advanced,
                  onTap: () =>
                      setState(() => _selectedLevel = TemplateLevel.advanced),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            AppTextField(
              label: t.templateObservationsLabel,
              controller: _observationsController,
              maxLines: 3,
            ),

            const SizedBox(height: AppSpacing.xl),

            AppButton(label: t.continueButton, onPressed: _continueToNextStep),
          ],
        ),
      ),
    );
  }
}

// Chip reutilizable para seleccionar el nivel de la plantilla.
class _LevelChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LevelChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label, style: AppTextStyles.bodySecondary),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}

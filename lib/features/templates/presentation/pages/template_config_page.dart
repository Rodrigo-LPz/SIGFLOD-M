import 'package:flutter/material.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/input_formatters.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../domain/models/template_enums.dart';
import '../../domain/models/template_model.dart';

// Pantalla de configuración básica de la plantilla.
class TemplateConfigPage extends StatefulWidget {
  const TemplateConfigPage({super.key});

  @override
  State<TemplateConfigPage> createState() => _TemplateConfigPageState();
}

class _TemplateConfigPageState extends State<TemplateConfigPage> {
  // Almacena el controlador del campo de nombre de la plantilla.
  late final TextEditingController _nameController;

  // Almacena el controlador del campo de objetivo.
  late final TextEditingController _objectiveController;

  // Almacena el controlador del campo de edad recomendada.
  late final TextEditingController _recommendedAgeController;

  // Almacena el controlador del campo de observaciones.
  late final TextEditingController _observationsController;

  // Almacena el nivel actualmente seleccionado por el usuario.
  TemplateLevel _selectedLevel = TemplateLevel.initial;

  // Almacena el tipo de plantilla recibido desde la pantalla anterior.
  TemplateType _selectedType = TemplateType.phonemes;

  // Almacena la plantilla original si la pantalla está en modo edición.
  TemplateModel? _editingTemplate;

  // Evita reinicializar el tipo al reconstruir el widget.
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    // Inicializa los controladores vacíos por defecto.
    _nameController = TextEditingController();
    _objectiveController = TextEditingController();
    _recommendedAgeController = TextEditingController();
    _observationsController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Resuelve una sola vez los argumentos recibidos por la ruta.
    if (!_isInitialized) {
      final args = ModalRoute.of(context)?.settings.arguments;

      // Modo creación: recibe solo el código del tipo seleccionado.
      if (args is String && args.trim().isNotEmpty) {
        _selectedType = TemplateTypeMapper.fromCode(args);
      }

      // Modo edición: recibe la plantilla existente y precarga sus datos.
      if (args is TemplateModel) {
        _editingTemplate = args;
        _selectedType = args.type;
        _selectedLevel = args.level;
        _nameController.text = args.name;
        _objectiveController.text = args.objective;
        _recommendedAgeController.text = args.recommendedAge;
        _observationsController.text = args.observations;
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

  // Valida los campos y construye el modelo base de la plantilla.
  void _continueToWords() {
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

    // Si estamos editando, conserva el id original y los demás campos no tocados.
    final original = _editingTemplate;
    final template = original != null
        ? original.copyWith(
            type: _selectedType,
            name: name,
            objective: objective,
            recommendedAge: recommendedAge,
            level: _selectedLevel,
            observations: observations,
          )
        : TemplateModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            type: _selectedType,
            name: name,
            objective: objective,
            recommendedAge: recommendedAge,
            level: _selectedLevel,
            observations: observations,
            words: const [],
            repetitions: 3,
            timeLimitMinutes: 3,
            guidedMode: true,
            soundsEnabled: true,
            feedbackEnabled: true,
            positiveReinforcementEnabled: true,
          );

    Navigator.pushNamed(context, AppRoutes.templateWords, arguments: template);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isEditing = _editingTemplate != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing
              ? t.editTemplateTitle
              : t.templateConfigTitle(_selectedType.localized(context)),
        ),
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

            AppButton(label: t.continueButton, onPressed: _continueToWords),
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

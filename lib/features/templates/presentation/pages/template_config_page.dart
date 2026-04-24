import 'package:flutter/material.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../domain/models/template_model.dart';

// 🔹 Pantalla de configuración básica de la plantilla
class TemplateConfigPage extends StatefulWidget {
  const TemplateConfigPage({super.key});

  @override
  State<TemplateConfigPage> createState() => _TemplateConfigPageState();
}

// 🔹 Estado interno de la pantalla
class _TemplateConfigPageState extends State<TemplateConfigPage> {
  // 🔹 Controlador para el nombre de la plantilla
  late final TextEditingController _nameController;

  // 🔹 Controlador para el objetivo
  late final TextEditingController _objectiveController;

  // 🔹 Controlador para la edad recomendada
  late final TextEditingController _recommendedAgeController;

  // 🔹 Controlador para observaciones
  late final TextEditingController _observationsController;

  // 🔹 Nivel seleccionado por el usuario
  String _selectedLevel = 'Inicial';

  // 🔹 Tipo de plantilla recibido desde la pantalla anterior
  String _selectedType = 'Fonemas / Pronunciación';

  // 🔹 Evita reinicializar el tipo al reconstruir
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    // 🔹 Inicializamos los controladores vacíos
    _nameController = TextEditingController();
    _objectiveController = TextEditingController();
    _recommendedAgeController = TextEditingController();
    _observationsController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 🔹 Solo inicializamos una vez con los argumentos de navegación
    if (!_isInitialized) {
      final args = ModalRoute.of(context)?.settings.arguments;

      // 🔹 Si llega un tipo válido, lo usamos como tipo seleccionado
      if (args is String && args.trim().isNotEmpty) {
        _selectedType = args;
      }

      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    // 🔹 Liberamos memoria de todos los controladores
    _nameController.dispose();
    _objectiveController.dispose();
    _recommendedAgeController.dispose();
    _observationsController.dispose();
    super.dispose();
  }

  // 🔹 Método encargado de validar y construir la plantilla base
  void _continueToWords() {
    // 🔹 Limpiamos espacios sobrantes
    final name = _nameController.text.trim();
    final objective = _objectiveController.text.trim();
    final recommendedAge = _recommendedAgeController.text.trim();
    final observations = _observationsController.text.trim();

    // 🔹 Validación mínima de los campos más importantes
    if (name.isEmpty || objective.isEmpty || recommendedAge.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Debe completar al menos nombre, objetivo y edad recomendada.',
          ),
        ),
      );
      return;
    }

    // 🔹 Construimos el modelo base de plantilla
    final template = TemplateModel(
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

    // 🔹 Navegamos al siguiente paso enviando la plantilla como argumento
    Navigator.pushNamed(
      context,
      AppRoutes.templateWords,
      arguments: template,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plantilla: $_selectedType'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: ListView(
          children: [
            const SizedBox(height: AppSpacing.sm),

            // 🔹 Título del bloque
            const Text(
              'Configuración Básica',
              style: AppTextStyles.title,
            ),

            const SizedBox(height: AppSpacing.md),

            // 🔹 Campo de nombre de plantilla
            AppTextField(
              label: 'Nombre de la plantilla',
              controller: _nameController,
            ),

            const SizedBox(height: AppSpacing.md),

            // 🔹 Campo de objetivo
            AppTextField(
              label: 'Objetivo',
              controller: _objectiveController,
            ),

            const SizedBox(height: AppSpacing.md),

            // 🔹 Campo de edad recomendada
            AppTextField(
              label: 'Edad recomendada',
              controller: _recommendedAgeController,
            ),

            const SizedBox(height: AppSpacing.lg),

            // 🔹 Texto de selección de nivel
            const Text(
              'Nivel',
              style: AppTextStyles.body,
            ),

            const SizedBox(height: AppSpacing.sm),

            // 🔹 Selector real de nivel
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _LevelChip(
                  label: 'Inicial',
                  selected: _selectedLevel == 'Inicial',
                  onTap: () {
                    setState(() {
                      _selectedLevel = 'Inicial';
                    });
                  },
                ),
                _LevelChip(
                  label: 'Medio',
                  selected: _selectedLevel == 'Medio',
                  onTap: () {
                    setState(() {
                      _selectedLevel = 'Medio';
                    });
                  },
                ),
                _LevelChip(
                  label: 'Avanzado',
                  selected: _selectedLevel == 'Avanzado',
                  onTap: () {
                    setState(() {
                      _selectedLevel = 'Avanzado';
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            // 🔹 Campo de observaciones
            AppTextField(
              label: 'Observaciones',
              controller: _observationsController,
              maxLines: 3,
            ),

            const SizedBox(height: AppSpacing.xl),

            // 🔹 Botón para continuar al siguiente paso con datos reales
            AppButton(
              label: 'Continuar',
              onPressed: _continueToWords,
            ),
          ],
        ),
      ),
    );
  }
}

// 🔹 Chip reutilizable para seleccionar nivel
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
      label: Text(
        label,
        style: AppTextStyles.bodySecondary,
      ),
      selected: selected,
      onSelected: (_) {
        onTap();
      },
    );
  }
}
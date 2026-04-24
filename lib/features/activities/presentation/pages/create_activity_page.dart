import 'package:flutter/material.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../domain/models/activity_model.dart';
import '../../data/repositories/activity_memory_repository.dart';
import '../../../patients/domain/models/patient_model.dart';
import '../../../patients/presentation/pages/patients_list_page.dart';
import '../../../templates/domain/models/template_model.dart';
import '../../../templates/presentation/pages/templates_page.dart';


// 🔹 Pantalla de creación/configuración de actividad
class CreateActivityPage extends StatefulWidget {
  // 🔹 Paciente opcional por si más adelante abrimos esta vista con uno ya seleccionado
  final PatientModel? initialPatient;

  // 🔹 Plantilla opcional por si más adelante abrimos esta vista con una ya seleccionada
  final TemplateModel? initialTemplate;

  const CreateActivityPage({
    super.key,
    this.initialPatient,
    this.initialTemplate,
  });

  @override
  State<CreateActivityPage> createState() => _CreateActivityPageState();
}

// 🔹 Estado interno de la pantalla
class _CreateActivityPageState extends State<CreateActivityPage> {
  // 🔹 Paciente actualmente seleccionado
  late PatientModel _selectedPatient;

  // 🔹 Plantilla actualmente seleccionada
  late TemplateModel _selectedTemplate;

  // 🔹 Ajustes internos reales de la actividad
  int _repetitions = 3;
  int _timeLimitMinutes = 5;
  bool _guidedMode = true;

  // 🔹 Repositorio compartido de actividades en memoria
  final ActivityMemoryRepository _activityRepository = ActivityMemoryRepository.instance;

  @override
  void initState() {
    super.initState();

    // 🔹 Paciente provisional en memoria si no llega uno real desde otra pantalla
    _selectedPatient = widget.initialPatient ??
        const PatientModel(
          id: '2',
          name: 'Matías',
          surname: 'Ariel',
          birthDate: '20 / 03 / 2005',
          diagnosis: 'Dislexia, Disfemia, TDAH',
          observations: '',
        );

    // 🔹 Plantilla provisional en memoria si no llega una real desde otra pantalla
    _selectedTemplate = widget.initialTemplate ??
        const TemplateModel(
          id: '2',
          type: 'Fonemas / Pronunciación',
          name: 'Pronunciación',
          objective: 'Fonética. Control al hablar.',
          recommendedAge: '6-9 años',
          level: 'Inicial',
          observations: '',
          words: ['Casa', 'Zapato', 'Cantar', 'Kayak'],
          repetitions: 3,
          timeLimitMinutes: 5,
          guidedMode: true,
          soundsEnabled: true,
          feedbackEnabled: true,
          positiveReinforcementEnabled: true,
        );

    // 🔹 Sincronizamos ajustes iniciales con la plantilla seleccionada
    _repetitions = _selectedTemplate.repetitions;
    _timeLimitMinutes = _selectedTemplate.timeLimitMinutes;
    _guidedMode = _selectedTemplate.guidedMode;
  }
  
  // 🔹 Abre el selector de pacientes y actualiza el paciente elegido
  Future<void> _selectPatient() async {
    final result = await Navigator.push<PatientModel>(
      context,
      MaterialPageRoute(
        builder: (context) => const PatientsListPage(
          selectionMode: true,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedPatient = result;
      });
    }
  }

  // 🔹 Abre el selector de plantillas y actualiza la plantilla elegida
  Future<void> _selectTemplate() async {
    final result = await Navigator.push<TemplateModel>(
      context,
      MaterialPageRoute(
        builder: (context) => const TemplatesPage(
          selectionMode: true,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedTemplate = result;

        // 🔹 Sincronizamos la configuración de actividad con la plantilla elegida
        _repetitions = result.repetitions;
        _timeLimitMinutes = result.timeLimitMinutes;
        _guidedMode = result.guidedMode;
      });
    }
  }

  // 🔹 Construye una actividad real y lanza la preview con la plantilla ajustada
  void _startActivity() {
    final activity = ActivityModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      patientId: _selectedPatient.id,
      patientName: _selectedPatient.fullName,
      templateId: _selectedTemplate.id,
      templateName: _selectedTemplate.name,
      repetitions: _repetitions,
      timeLimitMinutes: _timeLimitMinutes,
      guidedMode: _guidedMode,
      createdAt: DateTime.now(),
    );

    // 🔹 Plantilla ajustada con los parámetros actuales para la preview
    final previewTemplate = _selectedTemplate.copyWith(
      repetitions: _repetitions,
      timeLimitMinutes: _timeLimitMinutes,
      guidedMode: _guidedMode,
    );

    // 🔹 Guardamos la actividad en la memoria compartida
    _activityRepository.addActivity(activity);

    // 🔹 Feedback visible de que la actividad ya se registró correctamente
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Actividad registrada para ${activity.patientName}.',
        ),
      ),
    );

    // 🔹 Abrimos la preview con la plantilla real actualizada
    Navigator.pushNamed(
      context,
      AppRoutes.templatePreview,
      arguments: {
        'template': previewTemplate,
        'previewMode': 'activity',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final patientSubtitle = _selectedPatient.birthDate;
    final templateSubtitle = _selectedTemplate.objective;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Actividad'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: ListView(
          children: [
            _PatientSection(
              patient: _selectedPatient,
              subtitle: patientSubtitle,
              onTap: _selectPatient,
            ),
            const SizedBox(height: AppSpacing.xl),

            _TemplateSection(
              template: _selectedTemplate,
              subtitle: templateSubtitle,
              onTap: _selectTemplate,
            ),
            const SizedBox(height: AppSpacing.xl),

            _SettingsSection(
              repetitions: _repetitions,
              timeLimitMinutes: _timeLimitMinutes,
              guidedMode: _guidedMode,
              onDecreaseRepetitions: () {
                if (_repetitions > 1) {
                  setState(() {
                    _repetitions--;
                  });
                }
              },
              onIncreaseRepetitions: () {
                setState(() {
                  _repetitions++;
                });
              },
              onDecreaseTime: () {
                if (_timeLimitMinutes > 1) {
                  setState(() {
                    _timeLimitMinutes--;
                  });
                }
              },
              onIncreaseTime: () {
                setState(() {
                  _timeLimitMinutes++;
                });
              },
              onGuidedModeChanged: (value) {
                setState(() {
                  _guidedMode = value;
                });
              },
            ),
            const SizedBox(height: AppSpacing.xl),

            _StartButton(
              onPressed: _startActivity,
            ),
          ],
        ),
      ),
    );
  }
}

// 🔹 Sección visual del paciente seleccionado
class _PatientSection extends StatelessWidget {
  final PatientModel patient;
  final String subtitle;
  final VoidCallback onTap;

  const _PatientSection({
    required this.patient,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Paciente',
          style: AppTextStyles.title,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          child: ListTile(
            leading: const Icon(Icons.person),
            title: Text(
              patient.fullName,
              style: AppTextStyles.body,
            ),
            subtitle: Text(
              subtitle,
              style: AppTextStyles.bodySecondary,
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: onTap,
          ),
        ),
      ],
    );
  }
}

// 🔹 Sección visual de la plantilla seleccionada
class _TemplateSection extends StatelessWidget {
  final TemplateModel template;
  final String subtitle;
  final VoidCallback onTap;

  const _TemplateSection({
    required this.template,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Plantilla',
          style: AppTextStyles.title,
        ),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          child: ListTile(
            leading: const Icon(Icons.description),
            title: Text(
              template.name,
              style: AppTextStyles.body,
            ),
            subtitle: Text(
              subtitle,
              style: AppTextStyles.bodySecondary,
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: onTap,
          ),
        ),
      ],
    );
  }
}

// 🔹 Sección de configuración real de la actividad
class _SettingsSection extends StatelessWidget {
  final int repetitions;
  final int timeLimitMinutes;
  final bool guidedMode;
  final VoidCallback onDecreaseRepetitions;
  final VoidCallback onIncreaseRepetitions;
  final VoidCallback onDecreaseTime;
  final VoidCallback onIncreaseTime;
  final ValueChanged<bool> onGuidedModeChanged;

  const _SettingsSection({
    required this.repetitions,
    required this.timeLimitMinutes,
    required this.guidedMode,
    required this.onDecreaseRepetitions,
    required this.onIncreaseRepetitions,
    required this.onDecreaseTime,
    required this.onIncreaseTime,
    required this.onGuidedModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Configuración',
          style: AppTextStyles.title,
        ),
        const SizedBox(height: AppSpacing.sm),

        _SettingTile(
          title: 'Nº de repeticiones',
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: onDecreaseRepetitions,
                icon: const Icon(Icons.remove),
              ),
              Text(
                '$repetitions',
                style: AppTextStyles.body,
              ),
              IconButton(
                onPressed: onIncreaseRepetitions,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        _SettingTile(
          title: 'Tiempo (min)',
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: onDecreaseTime,
                icon: const Icon(Icons.remove),
              ),
              Text(
                '$timeLimitMinutes',
                style: AppTextStyles.body,
              ),
              IconButton(
                onPressed: onIncreaseTime,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        _SettingTile(
          title: 'Modo guiado',
          trailing: Switch(
            value: guidedMode,
            onChanged: onGuidedModeChanged,
          ),
        ),
      ],
    );
  }
}

// 🔹 Tarjeta visual reutilizable para cada ajuste
class _SettingTile extends StatelessWidget {
  final String title;
  final Widget trailing;

  const _SettingTile({
    required this.title,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: ListTile(
        title: Text(
          title,
          style: AppTextStyles.body,
        ),
        trailing: trailing,
      ),
    );
  }
}

// 🔹 Botón principal de inicio de actividad
class _StartButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _StartButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: 'Iniciar Actividad',
      onPressed: onPressed,
    );
  }
}
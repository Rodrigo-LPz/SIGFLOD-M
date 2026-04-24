import 'package:flutter/material.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../domain/models/patient_model.dart';


// 🔹 Pantalla de alta / edición de paciente
class CreatePatientPage extends StatefulWidget {
  // 🔹 Paciente opcional por si más adelante reutilizamos esta vista para editar
  final PatientModel? initialPatient;

  const CreatePatientPage({
    super.key,
    this.initialPatient,
  });

  @override
  State<CreatePatientPage> createState() => _CreatePatientPageState();
}

// 🔹 Estado interno de la pantalla
class _CreatePatientPageState extends State<CreatePatientPage> {
  // 🔹 Controlador para el campo nombre
  late final TextEditingController _nameController;

  // 🔹 Controlador para el campo apellidos
  late final TextEditingController _surnameController;

  // 🔹 Controlador para la fecha de nacimiento
  late final TextEditingController _birthDateController;

  // 🔹 Controlador para el diagnóstico inicial
  late final TextEditingController _diagnosisController;

  // 🔹 Controlador para observaciones
  late final TextEditingController _observationsController;

  // 🔹 Saber si estamos editando o creando
  bool get _isEditing => widget.initialPatient != null;

  @override
  void initState() {
    super.initState();

    // 🔹 Inicializamos cada controlador con datos vacíos o con los del paciente recibido
    _nameController = TextEditingController(
      text: widget.initialPatient?.name ?? '',
    );

    _surnameController = TextEditingController(
      text: widget.initialPatient?.surname ?? '',
    );

    _birthDateController = TextEditingController(
      text: widget.initialPatient?.birthDate ?? '',
    );

    _diagnosisController = TextEditingController(
      text: widget.initialPatient?.diagnosis ?? '',
    );

    _observationsController = TextEditingController(
      text: widget.initialPatient?.observations ?? '',
    );
  }

  @override
  void dispose() {
    // 🔹 Liberamos memoria de todos los controladores
    _nameController.dispose();
    _surnameController.dispose();
    _birthDateController.dispose();
    _diagnosisController.dispose();
    _observationsController.dispose();
    super.dispose();
  }

  // 🔹 Método encargado de validar y construir el paciente
  void _savePatient() {
    // 🔹 Limpiamos espacios sobrantes
    final name = _nameController.text.trim();
    final surname = _surnameController.text.trim();
    final birthDate = _birthDateController.text.trim();
    final diagnosis = _diagnosisController.text.trim();
    final observations = _observationsController.text.trim();

    // 🔹 Validación mínima de campos obligatorios
    if (name.isEmpty || surname.isEmpty || birthDate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Debe completar al menos nombre, apellidos y fecha de nacimiento.',
          ),
        ),
      );
      return;
    }

    // 🔹 Construimos el modelo del paciente en memoria
    final patient = PatientModel(
      id: widget.initialPatient?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      surname: surname,
      birthDate: birthDate,
      diagnosis: diagnosis,
      observations: observations,
    );

    // 🔹 Cerramos la pantalla devolviendo el paciente creado/editado
    Navigator.pop(context, patient);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 🔹 Cambiamos el título según si estamos creando o editando
        title: Text(
          _isEditing ? 'Editar Paciente' : 'Registrar Paciente',
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Bloque de información básica
            const Text(
              'Información Básica',
              style: AppTextStyles.title,
            ),

            const SizedBox(height: AppSpacing.md),

            AppTextField(
              label: 'Nombre',
              controller: _nameController,
            ),

            const SizedBox(height: AppSpacing.md),

            AppTextField(
              label: 'Apellidos',
              controller: _surnameController,
            ),

            const SizedBox(height: AppSpacing.md),

            AppTextField(
              label: 'Fecha de nacimiento',
              controller: _birthDateController,
              hint: 'Ej.: 20 / 03 / 2005',
            ),

            const SizedBox(height: AppSpacing.xl),

            // 🔹 Bloque de información clínica
            const Text(
              'Información Clínica',
              style: AppTextStyles.title,
            ),

            const SizedBox(height: AppSpacing.md),

            AppTextField(
              label: 'Diagnóstico inicial',
              controller: _diagnosisController,
              maxLines: 3,
            ),

            const SizedBox(height: AppSpacing.md),

            AppTextField(
              label: 'Observaciones',
              controller: _observationsController,
              maxLines: 4,
            ),

            const SizedBox(height: AppSpacing.xxl),

            // 🔹 Botón de guardado real
            AppButton(
              label: _isEditing ? 'Guardar Cambios' : 'Guardar Paciente',
              onPressed: _savePatient,
            ),
          ],
        ),
      ),
    );
  }
}
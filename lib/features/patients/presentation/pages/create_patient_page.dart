import 'package:flutter/material.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/utils/input_formatters.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../domain/models/patient_model.dart';

// Pantalla de alta y edición de pacientes.
class CreatePatientPage extends StatefulWidget {
  // Paciente opcional para reutilizar la vista en modo edición.
  final PatientModel? initialPatient;

  const CreatePatientPage({super.key, this.initialPatient});

  @override
  State<CreatePatientPage> createState() => _CreatePatientPageState();
}

class _CreatePatientPageState extends State<CreatePatientPage> {
  // Almacena el controlador del campo de nombre.
  late final TextEditingController _nameController;

  // Almacena el controlador del campo de apellidos.
  late final TextEditingController _surnameController;

  // Almacena la fecha de nacimiento seleccionada por el logopeda.
  DateTime? _birthDate;

  // Almacena el controlador del campo de diagnóstico inicial.
  late final TextEditingController _diagnosisController;

  // Almacena el controlador del campo de observaciones.
  late final TextEditingController _observationsController;

  // Determina si la pantalla está en modo edición o creación.
  bool get _isEditing => widget.initialPatient != null;

  @override
  void initState() {
    super.initState();

    // Inicializa los controladores con datos vacíos o con los del paciente recibido.
    _nameController = TextEditingController(
      text: widget.initialPatient?.name ?? '',
    );
    _surnameController = TextEditingController(
      text: widget.initialPatient?.surname ?? '',
    );
    _diagnosisController = TextEditingController(
      text: widget.initialPatient?.diagnosis ?? '',
    );
    _observationsController = TextEditingController(
      text: widget.initialPatient?.observations ?? '',
    );

    // Recupera la fecha de nacimiento del paciente recibido si existe.
    _birthDate = _parseBirthDate(widget.initialPatient?.birthDate);
  }

  @override
  void dispose() {
    // Libera la memoria reservada por los controladores al cerrar la pantalla.
    _nameController.dispose();
    _surnameController.dispose();
    _diagnosisController.dispose();
    _observationsController.dispose();
    super.dispose();
  }

  // Convierte una fecha en formato DD/MM/YYYY a un objeto DateTime utilizable.
  DateTime? _parseBirthDate(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;

    final parts = raw.split('/');
    if (parts.length != 3) return null;

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return null;

    try {
      return DateTime(year, month, day);
    } catch (_) {
      return null;
    }
  }

  // Formatea una fecha al formato DD/MM/YYYY para mostrarla y persistirla.
  String _formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year.toString();
    return '$d/$m/$y';
  }

  // Abre el calendario y actualiza la fecha de nacimiento seleccionada.
  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(now.year - 10),
      firstDate: DateTime(now.year - 120),
      lastDate: now,
    );

    if (picked != null) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  // Valida los campos y construye el modelo del paciente a devolver.
  void _savePatient() {
    final t = AppLocalizations.of(context)!;

    // Elimina los espacios sobrantes de los campos.
    final name = _nameController.text.trim();
    final surname = _surnameController.text.trim();
    final diagnosis = _diagnosisController.text.trim();
    final observations = _observationsController.text.trim();

    // Comprueba que los campos mínimos obligatorios estén informados.
    if (name.isEmpty || surname.isEmpty || _birthDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.errorPatientRequiredFields)));
      return;
    }

    // Construye el modelo del paciente en memoria.
    final patient = PatientModel(
      id:
          widget.initialPatient?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      surname: surname,
      birthDate: _formatDate(_birthDate!),
      diagnosis: diagnosis,
      observations: observations,
    );

    // Cierra la pantalla devolviendo el paciente creado o editado.
    Navigator.pop(context, patient);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        // Adapta el título según el modo activo de la pantalla.
        title: Text(_isEditing ? t.editPatientTitle : t.registerPatientTitle),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de información personal del paciente.
            Text(t.basicInfoSection, style: AppTextStyles.title),

            const SizedBox(height: AppSpacing.md),

            AppTextField(
              label: t.firstNameLabel,
              controller: _nameController,
              inputFormatters: [
                AppInputFormatters.nameFormatter(
                  context: context,
                  errorMessage: t.errorInvalidNameChar,
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            AppTextField(
              label: t.surnameLabel,
              controller: _surnameController,
              inputFormatters: [
                AppInputFormatters.nameFormatter(
                  context: context,
                  errorMessage: t.errorInvalidNameChar,
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            // Selector visual de la fecha de nacimiento del paciente.
            AppCard(
              child: ListTile(
                leading: const Icon(Icons.calendar_month),
                title: Text(t.birthDateLabelField, style: AppTextStyles.body),
                subtitle: Text(
                  _birthDate == null
                      ? t.birthDateHint
                      : _formatDate(_birthDate!),
                  style: AppTextStyles.bodySecondary,
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: _pickBirthDate,
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Sección de información clínica del paciente.
            Text(t.clinicalInfoSection, style: AppTextStyles.title),

            const SizedBox(height: AppSpacing.md),

            AppTextField(
              label: t.diagnosisLabelField,
              controller: _diagnosisController,
              maxLines: 3,
            ),

            const SizedBox(height: AppSpacing.md),

            AppTextField(
              label: t.observationsLabelField,
              controller: _observationsController,
              maxLines: 4,
            ),

            const SizedBox(height: AppSpacing.xxl),

            // Persiste el paciente y devuelve el resultado a la pantalla anterior.
            AppButton(
              label: _isEditing ? t.saveChanges : t.savePatient,
              onPressed: _savePatient,
            ),
          ],
        ),
      ),
    );
  }
}

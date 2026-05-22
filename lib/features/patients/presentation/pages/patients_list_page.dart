import 'package:flutter/material.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/session_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/patient_avatar.dart';
import '../../data/repositories/patient_firestore_repository.dart';
import '../../domain/models/patient_model.dart';
import 'patient_detail_page.dart';

// Pantalla reutilizable de listado y selección de pacientes.
class PatientsListPage extends StatefulWidget {
  // Activa el modo selector: al pulsar un paciente lo devuelve a la pantalla anterior.
  final bool selectionMode;

  const PatientsListPage({super.key, this.selectionMode = false});

  @override
  State<PatientsListPage> createState() => _PatientsListPageState();
}

class _PatientsListPageState extends State<PatientsListPage> {
  // Almacena la referencia al repositorio Firestore de pacientes.
  final PatientFirestoreRepository _patientRepository =
      PatientFirestoreRepository.instance;

  // Almacena el controlador del campo de búsqueda de pacientes.
  final TextEditingController _searchController = TextEditingController();

  // Mantiene el texto del filtro normalizado para evitar recalcularlo en cada rebuild.
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    // Escucha los cambios del campo de búsqueda y normaliza el texto introducido.
    _searchController.addListener(() {
      final normalized = _normalize(_searchController.text);
      if (normalized != _searchQuery) {
        setState(() {
          _searchQuery = normalized;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Normaliza el texto eliminando acentos, diacríticos y diferencias de mayúsculas.
  String _normalize(String input) {
    final lower = input.toLowerCase().trim();

    // Aplica descomposición canónica: separa cada carácter de su diacrítico.
    final decomposed = _unicodeDecompose(lower);

    // Elimina los diacríticos resultantes y deja solo las letras base.
    final stripped = decomposed.replaceAll(RegExp(r'[\u0300-\u036f]'), '');

    // Sustituye manualmente los caracteres que no se descomponen en Unicode.
    return stripped.replaceAll('ñ', 'n').replaceAll('ß', 'ss');
  }

  // Descompone los caracteres Unicode en su forma base más sus diacríticos.
  String _unicodeDecompose(String input) {
    final buffer = StringBuffer();
    for (final rune in input.runes) {
      buffer.write(_decomposeRune(rune));
    }
    return buffer.toString();
  }

  // Devuelve la descomposición canónica de un único carácter Unicode.
  String _decomposeRune(int rune) {
    const decomposed = {
      // Letras latinas con diacríticos (vocales).
      0x00C0: 'A\u0300', 0x00C1: 'A\u0301', 0x00C2: 'A\u0302',
      0x00C3: 'A\u0303', 0x00C4: 'A\u0308', 0x00C5: 'A\u030A',
      0x00C8: 'E\u0300', 0x00C9: 'E\u0301', 0x00CA: 'E\u0302',
      0x00CB: 'E\u0308',
      0x00CC: 'I\u0300', 0x00CD: 'I\u0301', 0x00CE: 'I\u0302',
      0x00CF: 'I\u0308',
      0x00D2: 'O\u0300', 0x00D3: 'O\u0301', 0x00D4: 'O\u0302',
      0x00D5: 'O\u0303', 0x00D6: 'O\u0308',
      0x00D9: 'U\u0300', 0x00DA: 'U\u0301', 0x00DB: 'U\u0302',
      0x00DC: 'U\u0308',
      0x00DD: 'Y\u0301',
      0x00E0: 'a\u0300', 0x00E1: 'a\u0301', 0x00E2: 'a\u0302',
      0x00E3: 'a\u0303', 0x00E4: 'a\u0308', 0x00E5: 'a\u030A',
      0x00E8: 'e\u0300', 0x00E9: 'e\u0301', 0x00EA: 'e\u0302',
      0x00EB: 'e\u0308',
      0x00EC: 'i\u0300', 0x00ED: 'i\u0301', 0x00EE: 'i\u0302',
      0x00EF: 'i\u0308',
      0x00F2: 'o\u0300', 0x00F3: 'o\u0301', 0x00F4: 'o\u0302',
      0x00F5: 'o\u0303', 0x00F6: 'o\u0308',
      0x00F9: 'u\u0300', 0x00FA: 'u\u0301', 0x00FB: 'u\u0302',
      0x00FC: 'u\u0308',
      0x00FD: 'y\u0301', 0x00FF: 'y\u0308',
      // Letras latinas con macron, breve, ogonek, caron y otros.
      0x0100: 'A\u0304', 0x0101: 'a\u0304',
      0x0102: 'A\u0306', 0x0103: 'a\u0306',
      0x0104: 'A\u0328', 0x0105: 'a\u0328',
      0x0106: 'C\u0301', 0x0107: 'c\u0301',
      0x010C: 'C\u030C', 0x010D: 'c\u030C',
      0x010E: 'D\u030C', 0x010F: 'd\u030C',
      0x0112: 'E\u0304', 0x0113: 'e\u0304',
      0x0114: 'E\u0306', 0x0115: 'e\u0306',
      0x0118: 'E\u0328', 0x0119: 'e\u0328',
      0x011A: 'E\u030C', 0x011B: 'e\u030C',
      0x011E: 'G\u0306', 0x011F: 'g\u0306',
      0x0128: 'I\u0303', 0x0129: 'i\u0303',
      0x012A: 'I\u0304', 0x012B: 'i\u0304',
      0x012E: 'I\u0328', 0x012F: 'i\u0328',
      0x0130: 'I\u0307',
      0x0139: 'L\u0301', 0x013A: 'l\u0301',
      0x013D: 'L\u030C', 0x013E: 'l\u030C',
      0x0143: 'N\u0301', 0x0144: 'n\u0301',
      0x0147: 'N\u030C', 0x0148: 'n\u030C',
      0x014C: 'O\u0304', 0x014D: 'o\u0304',
      0x014E: 'O\u0306', 0x014F: 'o\u0306',
      0x0150: 'O\u030B', 0x0151: 'o\u030B',
      0x0154: 'R\u0301', 0x0155: 'r\u0301',
      0x0158: 'R\u030C', 0x0159: 'r\u030C',
      0x015A: 'S\u0301', 0x015B: 's\u0301',
      0x015E: 'S\u0327', 0x015F: 's\u0327',
      0x0160: 'S\u030C', 0x0161: 's\u030C',
      0x0162: 'T\u0327', 0x0163: 't\u0327',
      0x0164: 'T\u030C', 0x0165: 't\u030C',
      0x0168: 'U\u0303', 0x0169: 'u\u0303',
      0x016A: 'U\u0304', 0x016B: 'u\u0304',
      0x016C: 'U\u0306', 0x016D: 'u\u0306',
      0x016E: 'U\u030A', 0x016F: 'u\u030A',
      0x0170: 'U\u030B', 0x0171: 'u\u030B',
      0x0172: 'U\u0328', 0x0173: 'u\u0328',
      0x0174: 'W\u0302', 0x0175: 'w\u0302',
      0x0176: 'Y\u0302', 0x0177: 'y\u0302',
      0x0178: 'Y\u0308',
      0x0179: 'Z\u0301', 0x017A: 'z\u0301',
      0x017B: 'Z\u0307', 0x017C: 'z\u0307',
      0x017D: 'Z\u030C', 0x017E: 'z\u030C',
      // Letras latinas con coma rumana y otros casos especiales.
      0x0218: 'S\u0326', 0x0219: 's\u0326',
      0x021A: 'T\u0326', 0x021B: 't\u0326',
      // Cedilla francesa, catalana, portuguesa, turca.
      0x00C7: 'C\u0327', 0x00E7: 'c\u0327',
    };

    return decomposed[rune] ?? String.fromCharCode(rune);
  }

  // Comprueba si un paciente coincide con el texto del filtro.
  bool _matchesQuery(PatientModel patient) {
    if (_searchQuery.isEmpty) return true;

    final haystack = _normalize(
      '${patient.name} ${patient.surname} ${patient.diagnosis}',
    );
    return haystack.contains(_searchQuery);
  }

  // Abre el formulario de alta y persiste el paciente creado en Firestore.
  Future<void> _openCreatePatient() async {
    final result = await Navigator.pushNamed(context, AppRoutes.createPatient);

    if (result is PatientModel) {
      await _patientRepository.addPatient(result);
    }
  }

  // Abre el detalle del paciente y actualiza sus datos en Firestore si fueron editados.
  Future<void> _openPatientDetail(PatientModel patient) async {
    final result = await Navigator.push<PatientModel>(
      context,
      MaterialPageRoute(
        builder: (context) => PatientDetailPage(patient: patient),
      ),
    );

    if (result != null) {
      await _patientRepository.updatePatient(result);
    }
  }

  // Gestiona el tap sobre un paciente según el modo activo de la pantalla.
  void _handlePatientTap(PatientModel patient) {
    if (widget.selectionMode) {
      Navigator.pop(context, patient);
      return;
    }

    _openPatientDetail(patient);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.selectionMode ? t.patientSelectorTitle : t.patientsListTitle,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            // Muestra el botón de alta solo en modo normal y si el usuario puede escribir.
            if (!widget.selectionMode && SessionService.instance.canWrite) ...[
              AppButton(label: t.addPatient, onPressed: _openCreatePatient),
              const SizedBox(height: AppSpacing.md),
            ],

            // Captura el texto de búsqueda del usuario.
            AppTextField(
              label: t.searchPatient,
              hint: t.searchPatientHint,
              controller: _searchController,
            ),

            const SizedBox(height: AppSpacing.md),

            // Escucha los cambios en Firestore y reconstruye la lista automáticamente.
            Expanded(
              child: ValueListenableBuilder<List<PatientModel>>(
                valueListenable: _patientRepository.patients,
                builder: (context, patients, _) {
                  if (patients.isEmpty) {
                    return Center(
                      child: Text(
                        t.noPatientsRegistered,
                        style: AppTextStyles.bodySecondary,
                      ),
                    );
                  }

                  // Aplica el filtro de búsqueda al listado completo de pacientes.
                  final filtered = patients.where(_matchesQuery).toList();

                  if (filtered.isEmpty) {
                    return Center(
                      child: Text(
                        t.noPatientsFound,
                        style: AppTextStyles.bodySecondary,
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final patient = filtered[index];

                      return _PatientCard(
                        patient: patient,
                        onTap: () => _handlePatientTap(patient),
                        noDiagnosisLabel: t.noInitialDiagnosis,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PatientCard extends StatelessWidget {
  final PatientModel patient;
  final VoidCallback onTap;
  final String noDiagnosisLabel;

  const _PatientCard({
    required this.patient,
    required this.onTap,
    required this.noDiagnosisLabel,
  });

  @override
  Widget build(BuildContext context) {
    final detail = patient.diagnosis.isNotEmpty
        ? '${patient.birthDate} / ${patient.diagnosis}'
        : '${patient.birthDate} / $noDiagnosisLabel';

    return GestureDetector(
      onTap: onTap,
      child: AppCard(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            PatientAvatar(patient: patient),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(patient.fullName, style: AppTextStyles.body),
                  const SizedBox(height: AppSpacing.xs),
                  Text(detail, style: AppTextStyles.bodySecondary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

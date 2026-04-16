import 'package:flutter/material.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_text_field.dart';


class PatientsListPage extends StatelessWidget {
  const PatientsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Pacientes'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            // Botón añadir paciente
            AppButton(
              label: 'Añadir Paciente',
              onPressed: () {},
            ),

            const SizedBox(height: AppSpacing.md),

            // Buscador
            const AppTextField(
              label: 'Buscar paciente',
              hint: 'Buscar paciente...',
            ),

            const SizedBox(height: AppSpacing.md),

            // Lista
            Expanded(
              child: ListView(
                children: const [
                  _PatientCard(
                    name: 'Aday Perdomo',
                    detail:
                        '20 años / Disgrafía, Retraso del Habla, TEL',
                  ),
                  _PatientCard(
                    name: 'Matías Ariel',
                    detail:
                        '20 años / Dislexia, Disfemia, TDAH',
                  ),
                  _PatientCard(
                    name: 'Amaro Morales',
                    detail:
                        '20 años / TID, TAS',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PatientCard extends StatelessWidget {
  final String name;
  final String detail;

  const _PatientCard({
    required this.name,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 25,
            child: Icon(Icons.person),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  detail,
                  style: AppTextStyles.bodySecondary,

                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
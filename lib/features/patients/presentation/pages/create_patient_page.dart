import 'package:flutter/material.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';


class CreatePatientPage extends StatelessWidget {
  const CreatePatientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Paciente'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Información Básica',
              style: AppTextStyles.title,
            ),

            const SizedBox(height: AppSpacing.md),

            const AppTextField(
              label: 'Nombre',
            ),

            const SizedBox(height: AppSpacing.md),

            const AppTextField(
              label: 'Apellidos',
            ),

            const SizedBox(height: AppSpacing.md),

            const AppTextField(
              label: 'Fecha de nacimiento',
            ),

            const SizedBox(height: AppSpacing.xl),

            const Text(
              'Información Clínica',
              style: AppTextStyles.title,
            ),

            const SizedBox(height: AppSpacing.md),

            const AppTextField(
              label: 'Diagnóstico inicial',
              maxLines: 3,
            ),

            const SizedBox(height: AppSpacing.md),

            const AppTextField(
              label: 'Observaciones',
              maxLines: 4,
            ),

            const SizedBox(height: AppSpacing.xxl),

            AppButton(
              label: 'Guardar Paciente',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
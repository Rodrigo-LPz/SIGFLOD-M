import 'package:flutter/material.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';


class CreateActivityPage extends StatelessWidget {
  const CreateActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Actividad'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: ListView(
          children: const [
            _PatientSection(),
            SizedBox(height: AppSpacing.xl),
            _TemplateSection(),
            SizedBox(height: AppSpacing.xl),
            _SettingsSection(),
            SizedBox(height: AppSpacing.xl),
            _StartButton(),
          ],
        ),
      ),
    );
  }
}

class _PatientSection extends StatelessWidget {
  const _PatientSection();

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
            title: const Text(
              'Matías Ariel',
              style: AppTextStyles.body,
            ),
            subtitle: const Text(
              '20 años',
              style: AppTextStyles.bodySecondary,
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.patientsList,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TemplateSection extends StatelessWidget {
  const _TemplateSection();

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
            title: const Text(
              'Fonemas / Pronunciación',
              style: AppTextStyles.body,
            ),
            subtitle: const Text(
              'Ejercicio de repetición',
              style: AppTextStyles.bodySecondary,
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.templates,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection();

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
            children: const [
              Icon(Icons.remove),
              SizedBox(width: AppSpacing.sm),
              Text(
                '3',
                style: AppTextStyles.body,
              ),
              SizedBox(width: AppSpacing.sm),
              Icon(Icons.add),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        _SettingTile(
          title: 'Tiempo (min)',
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.remove),
              SizedBox(width: AppSpacing.sm),
              Text(
                '5',
                style: AppTextStyles.body,
              ),
              SizedBox(width: AppSpacing.sm),
              Icon(Icons.add),
            ],
          ),
        ),
      ],
    );
  }
}

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

class _StartButton extends StatelessWidget {
  const _StartButton();

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: 'Iniciar Actividad',
      onPressed: () {
        Navigator.pushNamed(
          context,
          AppRoutes.templatePreview,
        );
      },
    );
  }
}
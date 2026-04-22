import 'package:flutter/material.dart';
import '../config/theme/app_theme.dart';
import '../core/routes/app_routes.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/role_selection_page.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';
import '../features/patients/presentation/pages/create_patient_page.dart';
import '../features/patients/presentation/pages/patient_detail_page.dart';
import '../features/patients/presentation/pages/patients_list_page.dart';
import '../features/templates/presentation/pages/template_config_page.dart';
import '../features/templates/presentation/pages/template_preview_page.dart';
import '../features/templates/presentation/pages/template_settings_page.dart';
import '../features/templates/presentation/pages/template_type_page.dart';
import '../features/templates/presentation/pages/template_words_page.dart';
import '../features/templates/presentation/pages/templates_page.dart';
import '../features/activities/presentation/pages/create_activity_page.dart';


class SigflodApp extends StatelessWidget {
  const SigflodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SIGFLOD',
      theme: AppTheme.getTheme(),
      initialRoute: AppRoutes.roleSelection,
      routes: {
        AppRoutes.roleSelection: (context) => const RoleSelectionPage(),
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.dashboard: (context) => const DashboardPage(),

        AppRoutes.patientsList: (context) => const PatientsListPage(),
        AppRoutes.patientDetail: (context) => const PatientDetailPage(),
        AppRoutes.createPatient: (context) => const CreatePatientPage(),

        AppRoutes.templates: (context) => const TemplatesPage(),
        AppRoutes.templateType: (context) => const TemplateTypePage(),
        AppRoutes.templateConfig: (context) => const TemplateConfigPage(),
        AppRoutes.templateWords: (context) => const TemplateWordsPage(),
        AppRoutes.templateSettings: (context) => const TemplateSettingsPage(),
        AppRoutes.templatePreview: (context) => const TemplatePreviewPage(),

        AppRoutes.createActivity: (context) => const CreateActivityPage(),
      },
    );
  }
}
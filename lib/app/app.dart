import 'package:flutter/material.dart';
import '../config/theme/app_theme.dart';
//import '../features/auth/presentation/bloc/login_page.dart';
//import '../features/dashboard/presentation/pages/dashboard_page.dart';
//import '../features/patients/presentation/pages/patients_list_page.dart';
//import '../features/patients/presentation/pages/patient_detail_page.dart';
//import '../features/templates/presentation/pages/templates_page.dart';
//import '../features/templates/presentation/pages/template_type_page.dart';
//import '../features/templates/presentation/pages/template_config_page.dart';
//import '../features/templates/presentation/pages/template_words_page.dart';
//import '../features/templates/presentation/pages/template_settings_page.dart';
//import '../features/templates/presentation/pages/template_preview_page.dart';
//import 'package:sigflod/features/patients/presentation/pages/create_patient_page.dart';
import 'package:sigflod/features/activities/presentation/pages/create_activity_page.dart';

class SigflodApp extends StatelessWidget {
  const SigflodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SIGFLOD',
      theme: AppTheme.getTheme(),
      //home: const Placeholder(),          // Temporal Path for the control panel page ("DashboardPage") 
      //home: const LoginPage(),            // Path pointer to login
      //home: const DashboardPage(),        // Temporal Path for the control panel page ("DashboardPage")
      //home: const PatientsListPage(),     // Temporal Path for the patients list page ("PatientsListPage")
      //home: const PatientDetailPage(),    // Temporal Path for the patient detail page ("PatientDetailPage")
      //home: const TemplatesPage(),        // Temporal Path for the templates page ("TemplatesPage")
      //home: const TemplateTypePage(),     // Temporal Path for the template type page ("TemplateTypePage")
      //home: const TemplateConfigPage(),   // Temporal Path for the template configuration page ("TemplateConfigPage")
      //home: const TemplateWordsPage(),    // Temporal Path for the template words page ("TemplateWordsPage")
      //home: const TemplateSettingsPage(), // Temporal Path for the template settings page ("TemplateSettingsPage")
      //home: const TemplatePreviewPage(),  // Temporal Path for the template preview page ("TemplatePreviewPage")
      //home: const CreatePatientPage(),    // Temporal Path for the create patient page ("CreatePatientPage")
      home: const CreateActivityPage(),     // Temporal Path for the create activity page ("CreateActivityPage"
    );
  }
}
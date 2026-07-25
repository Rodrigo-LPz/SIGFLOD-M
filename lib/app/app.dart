import 'package:flutter/material.dart';

import '../config/theme/app_theme.dart';
import '../core/routes/app_routes.dart';
import '../core/services/auth_service.dart';
import '../core/services/locale_service.dart';
import '../core/services/session_service.dart';
import '../features/activities/data/repositories/activity_firestore_repository.dart';
import '../features/activities/presentation/pages/create_activity_page.dart';
import '../features/auth/domain/models/app_user_model.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/role_selection_page.dart';
import '../features/splash/presentation/pages/splash_page.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';
import '../features/patients/data/repositories/patient_firestore_repository.dart';
import '../features/patients/presentation/pages/create_patient_page.dart';
import '../features/patients/presentation/pages/patients_list_page.dart';
import '../features/templates/data/repositories/template_firestore_repository.dart';
import '../features/templates/presentation/pages/template_config_page.dart';
import '../features/templates/presentation/pages/template_preview_page.dart';
import '../features/templates/presentation/pages/template_settings_page.dart';
import '../features/templates/presentation/pages/template_type_page.dart';
import '../features/templates/presentation/pages/template_words_page.dart';
import '../features/templates/presentation/pages/templates_page.dart';
import '../features/templates/presentation/pages/wizards/common/general_config_page.dart';
import '../features/templates/presentation/pages/wizards/custom/custom_content_page.dart';
import '../features/templates/presentation/pages/wizards/custom/custom_item_editor_page.dart';
import '../l10n/app_localizations.dart';

class SigflodApp extends StatefulWidget {
  const SigflodApp({super.key});

  @override
  State<SigflodApp> createState() => _SigflodAppState();
}

class _SigflodAppState extends State<SigflodApp> {
  // Almacena la referencia al servicio de autenticación.
  final AuthService _authService = AuthService.instance;

  // Controla si los repositorios ya están escuchando.
  bool _repositoriesStarted = false;

  // Mantiene una referencia global al navegador para redirigir tras logout.
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    // Reescucha los repositorios cuando se establece el usuario en sesión.
    SessionService.instance.currentUser.addListener(_onSessionChanged);
  }

  @override
  void dispose() {
    SessionService.instance.currentUser.removeListener(_onSessionChanged);
    super.dispose();
  }

  // Reacciona a la entrada del usuario en sesión para configurar los listeners.
  void _onSessionChanged() {
    final user = SessionService.instance.currentUser.value;
    if (user == null) return;
    _startRepositories(user);
  }

  // Arranca los listeners adaptando el filtrado al rol del usuario actual.
  void _startRepositories(AppUserModel user) {
    if (_repositoriesStarted) return;
    _repositoriesStarted = true;

    // Las plantillas son siempre globales para cualquier rol.
    TemplateFirestoreRepository.instance.startListening();

    // El familiar solo ve los pacientes a los que está vinculado.
    if (user.role == UserRole.familiar) {
      PatientFirestoreRepository.instance.startListening(
        restrictToIds: user.linkedPatientIds,
      );
      ActivityFirestoreRepository.instance.startListening(
        restrictToPatientIds: user.linkedPatientIds,
      );
      return;
    }

    // El logopeda ve todos los pacientes y actividades del sistema.
    PatientFirestoreRepository.instance.startListening();
    ActivityFirestoreRepository.instance.startListening();
  }

  // Resetea el estado al cerrar sesión para permitir un nuevo arranque.
  void _resetRepositories() {
    _repositoriesStarted = false;
    PatientFirestoreRepository.instance.patients.value = [];
    TemplateFirestoreRepository.instance.templates.value = [];
    ActivityFirestoreRepository.instance.activities.value = [];
    SessionService.instance.clearUser();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        // Al cerrar sesión limpia el estado y redirige a la selección de rol.
        if (!snapshot.hasData && _repositoriesStarted) {
          _resetRepositories();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final navigator = _navigatorKey.currentState;
            if (navigator != null) {
              navigator.pushNamedAndRemoveUntil(
                AppRoutes.roleSelection,
                (route) => false,
              );
            }
          });
        }

        return ValueListenableBuilder<Locale>(
          valueListenable: LocaleService.instance.currentLocale,
          builder: (context, locale, _) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'SIGFLOD',
              navigatorKey: _navigatorKey,
              theme: AppTheme.getTheme(),

              // Configura el idioma activo y los delegados de localización.
              locale: locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,

              // Arranca siempre por el splash, que decide a dónde redirigir.
              initialRoute: AppRoutes.splash,
              routes: {
                AppRoutes.splash: (context) => const SplashPage(),
                AppRoutes.roleSelection: (context) => const RoleSelectionPage(),
                AppRoutes.login: (context) => const LoginPage(),
                AppRoutes.dashboard: (context) => const DashboardPage(),

                AppRoutes.patientsList: (context) => const PatientsListPage(),
                AppRoutes.createPatient: (context) => const CreatePatientPage(),

                AppRoutes.templates: (context) => const TemplatesPage(),
                AppRoutes.templateType: (context) => const TemplateTypePage(),
                AppRoutes.templateConfig: (context) =>
                    const TemplateConfigPage(),
                AppRoutes.templateWords: (context) => const TemplateWordsPage(),
                AppRoutes.templateSettings: (context) =>
                    const TemplateSettingsPage(),
                AppRoutes.templatePreview: (context) =>
                    const TemplatePreviewPage(),

                AppRoutes.wizardGeneralConfig: (context) =>
                    const WizardGeneralConfigPage(),

                AppRoutes.wizardCustomContent: (context) =>
                    const CustomContentPage(),

                AppRoutes.wizardCustomItemEditor: (context) =>
                    const CustomItemEditorPage(),

                AppRoutes.createActivity: (context) =>
                    const CreateActivityPage(),
              },
            );
          },
        );
      },
    );
  }
}

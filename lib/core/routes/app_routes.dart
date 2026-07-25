class AppRoutes {
  static const String splash = '/splash';
  static const String roleSelection = '/';

  static const String login = '/login';
  static const String dashboard = '/dashboard';

  static const String patientsList = '/patients';
  static const String patientDetail = '/patients/detail';
  static const String createPatient = '/patients/create';

  static const String templates = '/templates';
  static const String templateType = '/templates/type';

  // Rutas antiguas del wizard genérico — DEPRECATED.
  // TODO: MIGRACION_PLANTILLAS — Eliminar estas rutas cuando los seis wizards especializados estén operativos y todas las referencias en el código apunten a las rutas nuevas.
  @Deprecated('Reemplazada por el wizard especializado por tipo de plantilla.')
  static const String templateConfig = '/templates/config';
  @Deprecated('Reemplazada por el wizard especializado por tipo de plantilla.')
  static const String templateWords = '/templates/words';
  @Deprecated('Reemplazada por el wizard especializado por tipo de plantilla.')
  static const String templateSettings = '/templates/settings';
  @Deprecated('Reemplazada por el wizard especializado por tipo de plantilla.')
  static const String templatePreview = '/templates/preview';

  // Pantalla común a todos los wizards: configuración general de la plantilla.
  static const String wizardGeneralConfig = '/templates/wizard/general-config';

  // Pantalla común a todos los wizards: previsualización final polimórfica.
  static const String wizardPreview = '/templates/wizard/preview';

  // Wizard especializado del tipo Custom (plantilla personalizada).
  static const String wizardCustomContent = '/templates/wizard/custom/content';
  static const String wizardCustomItemEditor =
      '/templates/wizard/custom/item-editor';
  static const String wizardCustomSettings =
      '/templates/wizard/custom/settings';

  // Wizard especializado del tipo Comprehension (plantilla de comprensión).
  static const String createActivity = '/activities/create';
}

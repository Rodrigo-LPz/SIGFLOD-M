import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'SIGFLOD'**
  String get appTitle;

  /// No description provided for @appSubtitle.
  ///
  /// In es, this message translates to:
  /// **'SIGFLOD ⁓ Logopedia'**
  String get appSubtitle;

  /// No description provided for @developedBy.
  ///
  /// In es, this message translates to:
  /// **'Desarrollado por Rodrigo López'**
  String get developedBy;

  /// No description provided for @portalTitle.
  ///
  /// In es, this message translates to:
  /// **'Portal de Gestión'**
  String get portalTitle;

  /// No description provided for @accessAs.
  ///
  /// In es, this message translates to:
  /// **'Acceder como:'**
  String get accessAs;

  /// No description provided for @roleLogopeda.
  ///
  /// In es, this message translates to:
  /// **'Logopeda'**
  String get roleLogopeda;

  /// No description provided for @roleFamiliar.
  ///
  /// In es, this message translates to:
  /// **'Familiar'**
  String get roleFamiliar;

  /// No description provided for @createAccount.
  ///
  /// In es, this message translates to:
  /// **'Crear cuenta'**
  String get createAccount;

  /// No description provided for @createAccountFutureNotice.
  ///
  /// In es, this message translates to:
  /// **'La creación de cuenta se implementará en una fase posterior.'**
  String get createAccountFutureNotice;

  /// No description provided for @emailLabel.
  ///
  /// In es, this message translates to:
  /// **'Correo electrónico'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In es, this message translates to:
  /// **'Ingrese su correo electrónico...'**
  String get emailHint;

  /// No description provided for @passwordLabel.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In es, this message translates to:
  /// **'Ingrese su contraseña...'**
  String get passwordHint;

  /// No description provided for @acceptTerms.
  ///
  /// In es, this message translates to:
  /// **'Acepto los Términos de Servicio y Política de Privacidad.'**
  String get acceptTerms;

  /// No description provided for @accessButton.
  ///
  /// In es, this message translates to:
  /// **'Acceder'**
  String get accessButton;

  /// No description provided for @noAccountQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿No tienes una cuenta? Registro.'**
  String get noAccountQuestion;

  /// No description provided for @errorInvalidEmail.
  ///
  /// In es, this message translates to:
  /// **'Introduce un correo electrónico válido.'**
  String get errorInvalidEmail;

  /// No description provided for @errorShortPassword.
  ///
  /// In es, this message translates to:
  /// **'La contraseña debe tener al menos 6 caracteres.'**
  String get errorShortPassword;

  /// No description provided for @errorTermsRequired.
  ///
  /// In es, this message translates to:
  /// **'Debes aceptar los términos y la política de privacidad.'**
  String get errorTermsRequired;

  /// No description provided for @errorSessionMissing.
  ///
  /// In es, this message translates to:
  /// **'No se pudo obtener la sesión del usuario.'**
  String get errorSessionMissing;

  /// No description provided for @errorProfileNotFound.
  ///
  /// In es, this message translates to:
  /// **'No se encontró el perfil del usuario en el sistema.'**
  String get errorProfileNotFound;

  /// No description provided for @errorRoleMismatch.
  ///
  /// In es, this message translates to:
  /// **'Las credenciales no corresponden al perfil seleccionado.'**
  String get errorRoleMismatch;

  /// No description provided for @errorUnexpected.
  ///
  /// In es, this message translates to:
  /// **'Ha ocurrido un error inesperado. Inténtalo de nuevo.'**
  String get errorUnexpected;

  /// No description provided for @errorUserNotFound.
  ///
  /// In es, this message translates to:
  /// **'No existe una cuenta con este correo electrónico.'**
  String get errorUserNotFound;

  /// No description provided for @errorWrongPassword.
  ///
  /// In es, this message translates to:
  /// **'La contraseña introducida es incorrecta.'**
  String get errorWrongPassword;

  /// No description provided for @errorBadEmailFormat.
  ///
  /// In es, this message translates to:
  /// **'El formato del correo electrónico no es válido.'**
  String get errorBadEmailFormat;

  /// No description provided for @errorUserDisabled.
  ///
  /// In es, this message translates to:
  /// **'Esta cuenta ha sido deshabilitada.'**
  String get errorUserDisabled;

  /// No description provided for @errorTooManyRequests.
  ///
  /// In es, this message translates to:
  /// **'Demasiados intentos fallidos. Inténtalo más tarde.'**
  String get errorTooManyRequests;

  /// No description provided for @errorInvalidCredential.
  ///
  /// In es, this message translates to:
  /// **'Credenciales incorrectas. Verifica tu correo y contraseña.'**
  String get errorInvalidCredential;

  /// No description provided for @errorGenericAuth.
  ///
  /// In es, this message translates to:
  /// **'Error de autenticación. Inténtalo de nuevo.'**
  String get errorGenericAuth;

  /// No description provided for @welcome.
  ///
  /// In es, this message translates to:
  /// **'Bienvenido/a'**
  String get welcome;

  /// No description provided for @quickAccess.
  ///
  /// In es, this message translates to:
  /// **'Accesos rápidos'**
  String get quickAccess;

  /// No description provided for @myPatients.
  ///
  /// In es, this message translates to:
  /// **'Mis Pacientes'**
  String get myPatients;

  /// No description provided for @templates.
  ///
  /// In es, this message translates to:
  /// **'Plantillas'**
  String get templates;

  /// No description provided for @newActivity.
  ///
  /// In es, this message translates to:
  /// **'Nueva Actividad'**
  String get newActivity;

  /// No description provided for @recommendedActivities.
  ///
  /// In es, this message translates to:
  /// **'Actividades Recomendadas'**
  String get recommendedActivities;

  /// No description provided for @noTemplatesAvailable.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay plantillas disponibles.'**
  String get noTemplatesAvailable;

  /// No description provided for @latestProgress.
  ///
  /// In es, this message translates to:
  /// **'Últimos Progresos'**
  String get latestProgress;

  /// No description provided for @noActivitiesYet.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay actividades registradas.'**
  String get noActivitiesYet;

  /// No description provided for @logoutTooltip.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get logoutTooltip;

  /// No description provided for @patientsListTitle.
  ///
  /// In es, this message translates to:
  /// **'Lista de Pacientes'**
  String get patientsListTitle;

  /// No description provided for @patientSelectorTitle.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar Paciente'**
  String get patientSelectorTitle;

  /// No description provided for @addPatient.
  ///
  /// In es, this message translates to:
  /// **'Añadir Paciente'**
  String get addPatient;

  /// No description provided for @searchPatient.
  ///
  /// In es, this message translates to:
  /// **'Buscar paciente'**
  String get searchPatient;

  /// No description provided for @searchPatientHint.
  ///
  /// In es, this message translates to:
  /// **'Buscar paciente...'**
  String get searchPatientHint;

  /// No description provided for @noPatientsRegistered.
  ///
  /// In es, this message translates to:
  /// **'Todavía no hay pacientes registrados.'**
  String get noPatientsRegistered;

  /// No description provided for @patientFileTitle.
  ///
  /// In es, this message translates to:
  /// **'Ficha del Paciente'**
  String get patientFileTitle;

  /// No description provided for @birthDateLabel.
  ///
  /// In es, this message translates to:
  /// **'Fecha de Nacimiento'**
  String get birthDateLabel;

  /// No description provided for @initialDiagnosisLabel.
  ///
  /// In es, this message translates to:
  /// **'Diagnóstico inicial'**
  String get initialDiagnosisLabel;

  /// No description provided for @noInitialDiagnosis.
  ///
  /// In es, this message translates to:
  /// **'Sin diagnóstico inicial'**
  String get noInitialDiagnosis;

  /// No description provided for @observationsLabel.
  ///
  /// In es, this message translates to:
  /// **'Observaciones'**
  String get observationsLabel;

  /// No description provided for @noObservations.
  ///
  /// In es, this message translates to:
  /// **'Sin observaciones registradas'**
  String get noObservations;

  /// No description provided for @addImage.
  ///
  /// In es, this message translates to:
  /// **'Añadir Imagen'**
  String get addImage;

  /// No description provided for @registerActivity.
  ///
  /// In es, this message translates to:
  /// **'Registrar Actividad'**
  String get registerActivity;

  /// No description provided for @editPatientFile.
  ///
  /// In es, this message translates to:
  /// **'Editar Ficha'**
  String get editPatientFile;

  /// No description provided for @imagesFutureNotice.
  ///
  /// In es, this message translates to:
  /// **'La gestión de imágenes se implementará en una fase posterior.'**
  String get imagesFutureNotice;

  /// No description provided for @activityHistory.
  ///
  /// In es, this message translates to:
  /// **'Historial de Actividades'**
  String get activityHistory;

  /// No description provided for @noActivitiesForPatient.
  ///
  /// In es, this message translates to:
  /// **'Este paciente todavía no tiene actividades registradas.'**
  String get noActivitiesForPatient;

  /// No description provided for @templatesTitle.
  ///
  /// In es, this message translates to:
  /// **'Plantillas'**
  String get templatesTitle;

  /// No description provided for @templateSelectorTitle.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar Plantilla'**
  String get templateSelectorTitle;

  /// No description provided for @createNewActivity.
  ///
  /// In es, this message translates to:
  /// **'Crear/Añadir Nueva Actividad'**
  String get createNewActivity;

  /// No description provided for @availableTemplates.
  ///
  /// In es, this message translates to:
  /// **'Plantillas Disponibles'**
  String get availableTemplates;

  /// No description provided for @registerActivityTitle.
  ///
  /// In es, this message translates to:
  /// **'Registrar Actividad'**
  String get registerActivityTitle;

  /// No description provided for @patientSection.
  ///
  /// In es, this message translates to:
  /// **'Paciente'**
  String get patientSection;

  /// No description provided for @selectPatient.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar paciente'**
  String get selectPatient;

  /// No description provided for @noneSelectedPatient.
  ///
  /// In es, this message translates to:
  /// **'Ninguno seleccionado'**
  String get noneSelectedPatient;

  /// No description provided for @templateSection.
  ///
  /// In es, this message translates to:
  /// **'Plantilla'**
  String get templateSection;

  /// No description provided for @selectTemplate.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar plantilla'**
  String get selectTemplate;

  /// No description provided for @noneSelectedTemplate.
  ///
  /// In es, this message translates to:
  /// **'Ninguna seleccionada'**
  String get noneSelectedTemplate;

  /// No description provided for @configurationSection.
  ///
  /// In es, this message translates to:
  /// **'Configuración'**
  String get configurationSection;

  /// No description provided for @repetitionsLabel.
  ///
  /// In es, this message translates to:
  /// **'Nº de repeticiones'**
  String get repetitionsLabel;

  /// No description provided for @timeLabel.
  ///
  /// In es, this message translates to:
  /// **'Tiempo (min)'**
  String get timeLabel;

  /// No description provided for @guidedModeLabel.
  ///
  /// In es, this message translates to:
  /// **'Modo guiado'**
  String get guidedModeLabel;

  /// No description provided for @startActivity.
  ///
  /// In es, this message translates to:
  /// **'Iniciar Actividad'**
  String get startActivity;

  /// No description provided for @errorSelectPatient.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un paciente para continuar.'**
  String get errorSelectPatient;

  /// No description provided for @errorSelectTemplate.
  ///
  /// In es, this message translates to:
  /// **'Selecciona una plantilla para continuar.'**
  String get errorSelectTemplate;

  /// No description provided for @activityRegistered.
  ///
  /// In es, this message translates to:
  /// **'Actividad registrada para {name}.'**
  String activityRegistered(Object name);

  /// No description provided for @repetitionsShort.
  ///
  /// In es, this message translates to:
  /// **'Repeticiones'**
  String get repetitionsShort;

  /// No description provided for @timeShort.
  ///
  /// In es, this message translates to:
  /// **'Tiempo'**
  String get timeShort;

  /// No description provided for @guidedShort.
  ///
  /// In es, this message translates to:
  /// **'Guiado'**
  String get guidedShort;

  /// No description provided for @yesShort.
  ///
  /// In es, this message translates to:
  /// **'Sí'**
  String get yesShort;

  /// No description provided for @noShort.
  ///
  /// In es, this message translates to:
  /// **'No'**
  String get noShort;

  /// No description provided for @editPatientTitle.
  ///
  /// In es, this message translates to:
  /// **'Editar Paciente'**
  String get editPatientTitle;

  /// No description provided for @registerPatientTitle.
  ///
  /// In es, this message translates to:
  /// **'Registrar Paciente'**
  String get registerPatientTitle;

  /// No description provided for @basicInfoSection.
  ///
  /// In es, this message translates to:
  /// **'Información Básica'**
  String get basicInfoSection;

  /// No description provided for @clinicalInfoSection.
  ///
  /// In es, this message translates to:
  /// **'Información Clínica'**
  String get clinicalInfoSection;

  /// No description provided for @firstNameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get firstNameLabel;

  /// No description provided for @surnameLabel.
  ///
  /// In es, this message translates to:
  /// **'Apellidos'**
  String get surnameLabel;

  /// No description provided for @birthDateLabelField.
  ///
  /// In es, this message translates to:
  /// **'Fecha de nacimiento'**
  String get birthDateLabelField;

  /// No description provided for @birthDateHint.
  ///
  /// In es, this message translates to:
  /// **'Selecciona una fecha'**
  String get birthDateHint;

  /// No description provided for @diagnosisLabelField.
  ///
  /// In es, this message translates to:
  /// **'Diagnóstico inicial'**
  String get diagnosisLabelField;

  /// No description provided for @observationsLabelField.
  ///
  /// In es, this message translates to:
  /// **'Observaciones'**
  String get observationsLabelField;

  /// No description provided for @saveChanges.
  ///
  /// In es, this message translates to:
  /// **'Guardar Cambios'**
  String get saveChanges;

  /// No description provided for @savePatient.
  ///
  /// In es, this message translates to:
  /// **'Guardar Paciente'**
  String get savePatient;

  /// No description provided for @errorPatientRequiredFields.
  ///
  /// In es, this message translates to:
  /// **'Debe completar al menos nombre, apellidos y fecha de nacimiento.'**
  String get errorPatientRequiredFields;

  /// No description provided for @templateTypeTitle.
  ///
  /// In es, this message translates to:
  /// **'Tipo de Plantilla'**
  String get templateTypeTitle;

  /// No description provided for @templateTypeQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Qué tipo de actividad quieres crear?'**
  String get templateTypeQuestion;

  /// No description provided for @templateTypeComprehension.
  ///
  /// In es, this message translates to:
  /// **'Comprensión'**
  String get templateTypeComprehension;

  /// No description provided for @templateTypeMotor.
  ///
  /// In es, this message translates to:
  /// **'Motora'**
  String get templateTypeMotor;

  /// No description provided for @templateTypeVocabulary.
  ///
  /// In es, this message translates to:
  /// **'Vocabulario'**
  String get templateTypeVocabulary;

  /// No description provided for @templateTypePhonemes.
  ///
  /// In es, this message translates to:
  /// **'Fonemas / Pronunciación'**
  String get templateTypePhonemes;

  /// No description provided for @templateTypeSequences.
  ///
  /// In es, this message translates to:
  /// **'Secuencias'**
  String get templateTypeSequences;

  /// No description provided for @templateTypeCustom.
  ///
  /// In es, this message translates to:
  /// **'Personalizado'**
  String get templateTypeCustom;

  /// No description provided for @templateConfigTitle.
  ///
  /// In es, this message translates to:
  /// **'Plantilla: {type}'**
  String templateConfigTitle(Object type);

  /// No description provided for @basicConfigSection.
  ///
  /// In es, this message translates to:
  /// **'Configuración Básica'**
  String get basicConfigSection;

  /// No description provided for @templateNameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre de la plantilla'**
  String get templateNameLabel;

  /// No description provided for @objectiveLabel.
  ///
  /// In es, this message translates to:
  /// **'Objetivo'**
  String get objectiveLabel;

  /// No description provided for @recommendedAgeLabel.
  ///
  /// In es, this message translates to:
  /// **'Edad recomendada'**
  String get recommendedAgeLabel;

  /// No description provided for @levelLabel.
  ///
  /// In es, this message translates to:
  /// **'Nivel'**
  String get levelLabel;

  /// No description provided for @levelInitial.
  ///
  /// In es, this message translates to:
  /// **'Inicial'**
  String get levelInitial;

  /// No description provided for @levelMedium.
  ///
  /// In es, this message translates to:
  /// **'Medio'**
  String get levelMedium;

  /// No description provided for @levelAdvanced.
  ///
  /// In es, this message translates to:
  /// **'Avanzado'**
  String get levelAdvanced;

  /// No description provided for @templateObservationsLabel.
  ///
  /// In es, this message translates to:
  /// **'Observaciones'**
  String get templateObservationsLabel;

  /// No description provided for @continueButton.
  ///
  /// In es, this message translates to:
  /// **'Continuar'**
  String get continueButton;

  /// No description provided for @errorTemplateRequiredFields.
  ///
  /// In es, this message translates to:
  /// **'Debe completar al menos nombre, objetivo y edad recomendada.'**
  String get errorTemplateRequiredFields;

  /// No description provided for @wordsTitle.
  ///
  /// In es, this message translates to:
  /// **'Palabras'**
  String get wordsTitle;

  /// No description provided for @noWordsYet.
  ///
  /// In es, this message translates to:
  /// **'Todavía no se han añadido palabras.'**
  String get noWordsYet;

  /// No description provided for @addNewWord.
  ///
  /// In es, this message translates to:
  /// **'Añadir nueva palabra'**
  String get addNewWord;

  /// No description provided for @newWordLabel.
  ///
  /// In es, this message translates to:
  /// **'Escriba una nueva palabra'**
  String get newWordLabel;

  /// No description provided for @newWordHint.
  ///
  /// In es, this message translates to:
  /// **'Escriba una palabra...'**
  String get newWordHint;

  /// No description provided for @addWordButton.
  ///
  /// In es, this message translates to:
  /// **'Añadir Palabra'**
  String get addWordButton;

  /// No description provided for @errorEmptyWord.
  ///
  /// In es, this message translates to:
  /// **'Debe escribir una palabra antes de añadirla.'**
  String get errorEmptyWord;

  /// No description provided for @errorDuplicatedWord.
  ///
  /// In es, this message translates to:
  /// **'Esa palabra ya está añadida en la plantilla.'**
  String get errorDuplicatedWord;

  /// No description provided for @errorTemplateMissing.
  ///
  /// In es, this message translates to:
  /// **'No se pudo recuperar la plantilla base.'**
  String get errorTemplateMissing;

  /// No description provided for @errorEmptyWordList.
  ///
  /// In es, this message translates to:
  /// **'Debe añadir al menos una palabra a la plantilla.'**
  String get errorEmptyWordList;

  /// No description provided for @finalSettingsTitle.
  ///
  /// In es, this message translates to:
  /// **'Ajustes Finales'**
  String get finalSettingsTitle;

  /// No description provided for @repetitionsSetting.
  ///
  /// In es, this message translates to:
  /// **'Nº de Repeticiones'**
  String get repetitionsSetting;

  /// No description provided for @guidedModeSetting.
  ///
  /// In es, this message translates to:
  /// **'Modo Guiado'**
  String get guidedModeSetting;

  /// No description provided for @timeLimitSetting.
  ///
  /// In es, this message translates to:
  /// **'Tiempo Límite (min)'**
  String get timeLimitSetting;

  /// No description provided for @soundsSetting.
  ///
  /// In es, this message translates to:
  /// **'Sonidos'**
  String get soundsSetting;

  /// No description provided for @feedbackSetting.
  ///
  /// In es, this message translates to:
  /// **'Retroalimentación'**
  String get feedbackSetting;

  /// No description provided for @positiveReinforcementSetting.
  ///
  /// In es, this message translates to:
  /// **'Refuerzo Positivo'**
  String get positiveReinforcementSetting;

  /// No description provided for @previewButton.
  ///
  /// In es, this message translates to:
  /// **'Previsualizar'**
  String get previewButton;

  /// No description provided for @errorTemplateConfigMissing.
  ///
  /// In es, this message translates to:
  /// **'No se pudo recuperar la plantilla configurada.'**
  String get errorTemplateConfigMissing;

  /// No description provided for @previewTitle.
  ///
  /// In es, this message translates to:
  /// **'Previsualización'**
  String get previewTitle;

  /// No description provided for @activityPreviewTitle.
  ///
  /// In es, this message translates to:
  /// **'Previsualización de Actividad'**
  String get activityPreviewTitle;

  /// No description provided for @errorPreviewTemplateMissing.
  ///
  /// In es, this message translates to:
  /// **'No se pudo cargar la plantilla para la previsualización.'**
  String get errorPreviewTemplateMissing;

  /// No description provided for @backToTemplates.
  ///
  /// In es, this message translates to:
  /// **'Volver a Plantillas'**
  String get backToTemplates;

  /// No description provided for @backToActivity.
  ///
  /// In es, this message translates to:
  /// **'Volver a la Actividad'**
  String get backToActivity;

  /// No description provided for @typeLabel.
  ///
  /// In es, this message translates to:
  /// **'Tipo'**
  String get typeLabel;

  /// No description provided for @repeatWordsLabel.
  ///
  /// In es, this message translates to:
  /// **'Repite las palabras:'**
  String get repeatWordsLabel;

  /// No description provided for @noWordsInTemplate.
  ///
  /// In es, this message translates to:
  /// **'La plantilla no contiene palabras.'**
  String get noWordsInTemplate;

  /// No description provided for @closePreview.
  ///
  /// In es, this message translates to:
  /// **'Cerrar Previsualización'**
  String get closePreview;

  /// No description provided for @saveButton.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get saveButton;

  /// No description provided for @attendanceSection.
  ///
  /// In es, this message translates to:
  /// **'Asistencia'**
  String get attendanceSection;

  /// No description provided for @attendedToggle.
  ///
  /// In es, this message translates to:
  /// **'Asistió'**
  String get attendedToggle;

  /// No description provided for @absentToggle.
  ///
  /// In es, this message translates to:
  /// **'Ausente'**
  String get absentToggle;

  /// No description provided for @appointmentDateLabel.
  ///
  /// In es, this message translates to:
  /// **'Fecha de la cita'**
  String get appointmentDateLabel;

  /// No description provided for @appointmentDateHint.
  ///
  /// In es, this message translates to:
  /// **'Selecciona una fecha'**
  String get appointmentDateHint;

  /// No description provided for @appointmentScheduleLabel.
  ///
  /// In es, this message translates to:
  /// **'Horario'**
  String get appointmentScheduleLabel;

  /// No description provided for @startTimeLabel.
  ///
  /// In es, this message translates to:
  /// **'Desde'**
  String get startTimeLabel;

  /// No description provided for @endTimeLabel.
  ///
  /// In es, this message translates to:
  /// **'Hasta'**
  String get endTimeLabel;

  /// No description provided for @selectTimeHint.
  ///
  /// In es, this message translates to:
  /// **'Selecciona hora'**
  String get selectTimeHint;

  /// No description provided for @registerAbsence.
  ///
  /// In es, this message translates to:
  /// **'Registrar Ausencia'**
  String get registerAbsence;

  /// No description provided for @absenceRegistered.
  ///
  /// In es, this message translates to:
  /// **'Ausencia registrada para {name}.'**
  String absenceRegistered(Object name);

  /// No description provided for @errorMissingAppointmentDate.
  ///
  /// In es, this message translates to:
  /// **'Selecciona la fecha de la cita.'**
  String get errorMissingAppointmentDate;

  /// No description provided for @errorMissingStartTime.
  ///
  /// In es, this message translates to:
  /// **'Selecciona la hora de inicio.'**
  String get errorMissingStartTime;

  /// No description provided for @errorMissingEndTime.
  ///
  /// In es, this message translates to:
  /// **'Selecciona la hora de fin.'**
  String get errorMissingEndTime;

  /// No description provided for @errorInvalidSchedule.
  ///
  /// In es, this message translates to:
  /// **'La hora de inicio debe ser anterior a la hora de fin.'**
  String get errorInvalidSchedule;

  /// No description provided for @absentBadge.
  ///
  /// In es, this message translates to:
  /// **'Ausencia'**
  String get absentBadge;

  /// No description provided for @attendedBadge.
  ///
  /// In es, this message translates to:
  /// **'Asistencia'**
  String get attendedBadge;

  /// No description provided for @exportFullReport.
  ///
  /// In es, this message translates to:
  /// **'Exportar informe completo'**
  String get exportFullReport;

  /// No description provided for @exportRangeReport.
  ///
  /// In es, this message translates to:
  /// **'Exportar informe por fechas'**
  String get exportRangeReport;

  /// No description provided for @rangeReportTitle.
  ///
  /// In es, this message translates to:
  /// **'Informe por fechas'**
  String get rangeReportTitle;

  /// No description provided for @rangeStartLabel.
  ///
  /// In es, this message translates to:
  /// **'Desde'**
  String get rangeStartLabel;

  /// No description provided for @rangeEndLabel.
  ///
  /// In es, this message translates to:
  /// **'Hasta'**
  String get rangeEndLabel;

  /// No description provided for @rangePickHint.
  ///
  /// In es, this message translates to:
  /// **'Selecciona una fecha'**
  String get rangePickHint;

  /// No description provided for @generateReport.
  ///
  /// In es, this message translates to:
  /// **'Generar informe'**
  String get generateReport;

  /// No description provided for @errorMissingRangeStart.
  ///
  /// In es, this message translates to:
  /// **'Selecciona la fecha de inicio.'**
  String get errorMissingRangeStart;

  /// No description provided for @errorMissingRangeEnd.
  ///
  /// In es, this message translates to:
  /// **'Selecciona la fecha de fin.'**
  String get errorMissingRangeEnd;

  /// No description provided for @errorInvalidRange.
  ///
  /// In es, this message translates to:
  /// **'La fecha de inicio debe ser anterior o igual a la fecha de fin.'**
  String get errorInvalidRange;

  /// No description provided for @errorNoActivitiesInRange.
  ///
  /// In es, this message translates to:
  /// **'No hay actividades registradas en el rango seleccionado.'**
  String get errorNoActivitiesInRange;

  /// No description provided for @noPatientsFound.
  ///
  /// In es, this message translates to:
  /// **'Ningún paciente coincide con la búsqueda.'**
  String get noPatientsFound;

  /// No description provided for @errorInvalidNameChar.
  ///
  /// In es, this message translates to:
  /// **'Solo se admiten letras, espacios, guiones y apóstrofes.'**
  String get errorInvalidNameChar;

  /// No description provided for @errorInvalidTemplateNameChar.
  ///
  /// In es, this message translates to:
  /// **'Solo se admiten letras, números, espacios, guiones y guiones bajos.'**
  String get errorInvalidTemplateNameChar;

  /// No description provided for @errorInvalidAgeChar.
  ///
  /// In es, this message translates to:
  /// **'Solo se admiten números y guiones para indicar el rango.'**
  String get errorInvalidAgeChar;

  /// No description provided for @recommendedAgeHint.
  ///
  /// In es, this message translates to:
  /// **'Ej.: 5 - 8'**
  String get recommendedAgeHint;

  /// No description provided for @deletePatient.
  ///
  /// In es, this message translates to:
  /// **'Eliminar Paciente'**
  String get deletePatient;

  /// No description provided for @deleteTemplate.
  ///
  /// In es, this message translates to:
  /// **'Eliminar Plantilla'**
  String get deleteTemplate;

  /// No description provided for @confirmDeletePatientTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar paciente?'**
  String get confirmDeletePatientTitle;

  /// No description provided for @confirmDeletePatientMessage.
  ///
  /// In es, this message translates to:
  /// **'Esta acción eliminará al paciente y todas sus actividades registradas. No se puede deshacer.'**
  String get confirmDeletePatientMessage;

  /// No description provided for @confirmDeleteTemplateTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar plantilla?'**
  String get confirmDeleteTemplateTitle;

  /// No description provided for @confirmDeleteTemplateMessage.
  ///
  /// In es, this message translates to:
  /// **'Esta acción eliminará la plantilla, pero las actividades de los pacientes que la hayan utilizado se conservarán en su historial. No se puede deshacer.'**
  String get confirmDeleteTemplateMessage;

  /// No description provided for @cancelAction.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancelAction;

  /// No description provided for @confirmAction.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get confirmAction;

  /// No description provided for @patientDeleted.
  ///
  /// In es, this message translates to:
  /// **'Paciente eliminado correctamente.'**
  String get patientDeleted;

  /// No description provided for @templateDeleted.
  ///
  /// In es, this message translates to:
  /// **'Plantilla eliminada correctamente.'**
  String get templateDeleted;

  /// No description provided for @editTemplateTitle.
  ///
  /// In es, this message translates to:
  /// **'Editar Plantilla'**
  String get editTemplateTitle;

  /// No description provided for @editTemplate.
  ///
  /// In es, this message translates to:
  /// **'Editar Plantilla'**
  String get editTemplate;

  /// No description provided for @createAccountTitle.
  ///
  /// In es, this message translates to:
  /// **'Crear cuenta'**
  String get createAccountTitle;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Acceso para familiares'**
  String get createAccountSubtitle;

  /// No description provided for @firstNameRegisterLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get firstNameRegisterLabel;

  /// No description provided for @firstSurnameLabel.
  ///
  /// In es, this message translates to:
  /// **'Primer apellido'**
  String get firstSurnameLabel;

  /// No description provided for @secondSurnameLabel.
  ///
  /// In es, this message translates to:
  /// **'Segundo apellido'**
  String get secondSurnameLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In es, this message translates to:
  /// **'Confirmar contraseña'**
  String get confirmPasswordLabel;

  /// No description provided for @invitationCodeLabel.
  ///
  /// In es, this message translates to:
  /// **'Código de invitación del paciente'**
  String get invitationCodeLabel;

  /// No description provided for @invitationCodeHint.
  ///
  /// In es, this message translates to:
  /// **'Ej.: A3X9-B2K7'**
  String get invitationCodeHint;

  /// No description provided for @registerButton.
  ///
  /// In es, this message translates to:
  /// **'Registrarse'**
  String get registerButton;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In es, this message translates to:
  /// **'¿Ya tienes cuenta? Inicia sesión.'**
  String get alreadyHaveAccount;

  /// No description provided for @errorAllFieldsRequired.
  ///
  /// In es, this message translates to:
  /// **'Debes completar todos los campos.'**
  String get errorAllFieldsRequired;

  /// No description provided for @errorPasswordMismatch.
  ///
  /// In es, this message translates to:
  /// **'Las contraseñas no coinciden.'**
  String get errorPasswordMismatch;

  /// No description provided for @errorEmailInUse.
  ///
  /// In es, this message translates to:
  /// **'Ya existe una cuenta con este correo electrónico.'**
  String get errorEmailInUse;

  /// No description provided for @errorWeakPassword.
  ///
  /// In es, this message translates to:
  /// **'La contraseña es demasiado débil.'**
  String get errorWeakPassword;

  /// No description provided for @errorInvitationNotFound.
  ///
  /// In es, this message translates to:
  /// **'El código de invitación no es válido o ya fue utilizado.'**
  String get errorInvitationNotFound;

  /// No description provided for @errorPatientNotFound.
  ///
  /// In es, this message translates to:
  /// **'El paciente asociado a la invitación no existe.'**
  String get errorPatientNotFound;

  /// No description provided for @registrationSuccessTitle.
  ///
  /// In es, this message translates to:
  /// **'Cuenta creada correctamente'**
  String get registrationSuccessTitle;

  /// No description provided for @registrationSuccessMessage.
  ///
  /// In es, this message translates to:
  /// **'Te hemos enviado un correo de verificación. Revísalo para activar tu cuenta antes de iniciar sesión.'**
  String get registrationSuccessMessage;

  /// No description provided for @continueAction.
  ///
  /// In es, this message translates to:
  /// **'Continuar'**
  String get continueAction;

  /// No description provided for @emailNotVerifiedTitle.
  ///
  /// In es, this message translates to:
  /// **'Verifica tu correo electrónico'**
  String get emailNotVerifiedTitle;

  /// No description provided for @emailNotVerifiedMessage.
  ///
  /// In es, this message translates to:
  /// **'Antes de continuar, abre el enlace que te hemos enviado por correo y vuelve a intentarlo.'**
  String get emailNotVerifiedMessage;

  /// No description provided for @resendVerification.
  ///
  /// In es, this message translates to:
  /// **'Reenviar correo de verificación'**
  String get resendVerification;

  /// No description provided for @verificationSent.
  ///
  /// In es, this message translates to:
  /// **'Correo de verificación reenviado.'**
  String get verificationSent;

  /// No description provided for @checkAgainButton.
  ///
  /// In es, this message translates to:
  /// **'Ya he verificado'**
  String get checkAgainButton;

  /// No description provided for @generateInvitationCode.
  ///
  /// In es, this message translates to:
  /// **'Generar código de invitación'**
  String get generateInvitationCode;

  /// No description provided for @invitationCodeGeneratedTitle.
  ///
  /// In es, this message translates to:
  /// **'Código generado'**
  String get invitationCodeGeneratedTitle;

  /// No description provided for @invitationCodeGeneratedMessage.
  ///
  /// In es, this message translates to:
  /// **'Entrégale este código al familiar para que pueda registrarse. Solo se puede usar una vez.'**
  String get invitationCodeGeneratedMessage;

  /// No description provided for @copyCodeAction.
  ///
  /// In es, this message translates to:
  /// **'Copiar código'**
  String get copyCodeAction;

  /// No description provided for @codeCopiedSnack.
  ///
  /// In es, this message translates to:
  /// **'Código copiado al portapapeles.'**
  String get codeCopiedSnack;

  /// No description provided for @choosePhotoSource.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo quieres añadir la foto?'**
  String get choosePhotoSource;

  /// No description provided for @photoFromGallery.
  ///
  /// In es, this message translates to:
  /// **'Elegir de la galería'**
  String get photoFromGallery;

  /// No description provided for @photoFromCamera.
  ///
  /// In es, this message translates to:
  /// **'Hacer una foto'**
  String get photoFromCamera;

  /// No description provided for @removePhoto.
  ///
  /// In es, this message translates to:
  /// **'Quitar foto'**
  String get removePhoto;

  /// No description provided for @changePhoto.
  ///
  /// In es, this message translates to:
  /// **'Cambiar foto'**
  String get changePhoto;

  /// No description provided for @confirmRemovePhotoTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Quitar la foto?'**
  String get confirmRemovePhotoTitle;

  /// No description provided for @confirmRemovePhotoMessage.
  ///
  /// In es, this message translates to:
  /// **'La foto actual del paciente se eliminará. Podrás añadir otra cuando quieras.'**
  String get confirmRemovePhotoMessage;

  /// No description provided for @photoUpdated.
  ///
  /// In es, this message translates to:
  /// **'Foto actualizada correctamente.'**
  String get photoUpdated;

  /// No description provided for @photoRemoved.
  ///
  /// In es, this message translates to:
  /// **'Foto eliminada correctamente.'**
  String get photoRemoved;

  /// Mensaje mostrado cuando falla la subida de la foto del paciente a Storage.
  ///
  /// In es, this message translates to:
  /// **'Error al subir la foto. Inténtalo de nuevo.'**
  String get errorPhotoUploadFailed;

  /// No description provided for @phonemeTypeSimple.
  ///
  /// In es, this message translates to:
  /// **'Simple'**
  String get phonemeTypeSimple;

  /// No description provided for @phonemeTypeMultiple.
  ///
  /// In es, this message translates to:
  /// **'Múltiple'**
  String get phonemeTypeMultiple;

  /// No description provided for @phonemeTypeBlend.
  ///
  /// In es, this message translates to:
  /// **'Sinfón'**
  String get phonemeTypeBlend;

  /// No description provided for @phonemePositionInitial.
  ///
  /// In es, this message translates to:
  /// **'Inicial'**
  String get phonemePositionInitial;

  /// No description provided for @phonemePositionMiddle.
  ///
  /// In es, this message translates to:
  /// **'Media'**
  String get phonemePositionMiddle;

  /// No description provided for @phonemePositionFinal.
  ///
  /// In es, this message translates to:
  /// **'Final'**
  String get phonemePositionFinal;

  /// No description provided for @phonemePositionBlend.
  ///
  /// In es, this message translates to:
  /// **'Trabada'**
  String get phonemePositionBlend;

  /// No description provided for @motorGroupLips.
  ///
  /// In es, this message translates to:
  /// **'Labios'**
  String get motorGroupLips;

  /// No description provided for @motorGroupTongue.
  ///
  /// In es, this message translates to:
  /// **'Lengua'**
  String get motorGroupTongue;

  /// No description provided for @motorGroupCheeks.
  ///
  /// In es, this message translates to:
  /// **'Mejillas'**
  String get motorGroupCheeks;

  /// No description provided for @motorGroupJaw.
  ///
  /// In es, this message translates to:
  /// **'Mandíbula'**
  String get motorGroupJaw;

  /// No description provided for @motorGroupPalate.
  ///
  /// In es, this message translates to:
  /// **'Paladar'**
  String get motorGroupPalate;

  /// No description provided for @motorGroupBreath.
  ///
  /// In es, this message translates to:
  /// **'Soplo'**
  String get motorGroupBreath;

  /// No description provided for @comprehensionModalityReading.
  ///
  /// In es, this message translates to:
  /// **'Lectora'**
  String get comprehensionModalityReading;

  /// No description provided for @comprehensionModalityListening.
  ///
  /// In es, this message translates to:
  /// **'Auditiva'**
  String get comprehensionModalityListening;

  /// No description provided for @vocabularyModeNaming.
  ///
  /// In es, this message translates to:
  /// **'Denominación'**
  String get vocabularyModeNaming;

  /// No description provided for @vocabularyModeRiddle.
  ///
  /// In es, this message translates to:
  /// **'Adivinanza'**
  String get vocabularyModeRiddle;

  /// No description provided for @vocabularyModeCategorization.
  ///
  /// In es, this message translates to:
  /// **'Categorización'**
  String get vocabularyModeCategorization;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

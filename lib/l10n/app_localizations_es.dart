// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'SIGFLOD';

  @override
  String get appSubtitle => 'SIGFLOD ⁓ Logopedia';

  @override
  String get developedBy => 'Desarrollado por Rodrigo López';

  @override
  String get portalTitle => 'Portal de Gestión';

  @override
  String get accessAs => 'Acceder como:';

  @override
  String get roleLogopeda => 'Logopeda';

  @override
  String get roleFamiliar => 'Familiar';

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get createAccountFutureNotice =>
      'La creación de cuenta se implementará en una fase posterior.';

  @override
  String get emailLabel => 'Correo electrónico';

  @override
  String get emailHint => 'Ingrese su correo electrónico...';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get passwordHint => 'Ingrese su contraseña...';

  @override
  String get acceptTerms =>
      'Acepto los Términos de Servicio y Política de Privacidad.';

  @override
  String get accessButton => 'Acceder';

  @override
  String get noAccountQuestion => '¿No tienes una cuenta? Registro.';

  @override
  String get errorInvalidEmail => 'Introduce un correo electrónico válido.';

  @override
  String get errorShortPassword =>
      'La contraseña debe tener al menos 6 caracteres.';

  @override
  String get errorTermsRequired =>
      'Debes aceptar los términos y la política de privacidad.';

  @override
  String get errorSessionMissing => 'No se pudo obtener la sesión del usuario.';

  @override
  String get errorProfileNotFound =>
      'No se encontró el perfil del usuario en el sistema.';

  @override
  String get errorRoleMismatch =>
      'Las credenciales no corresponden al perfil seleccionado.';

  @override
  String get errorUnexpected =>
      'Ha ocurrido un error inesperado. Inténtalo de nuevo.';

  @override
  String get errorUserNotFound =>
      'No existe una cuenta con este correo electrónico.';

  @override
  String get errorWrongPassword => 'La contraseña introducida es incorrecta.';

  @override
  String get errorBadEmailFormat =>
      'El formato del correo electrónico no es válido.';

  @override
  String get errorUserDisabled => 'Esta cuenta ha sido deshabilitada.';

  @override
  String get errorTooManyRequests =>
      'Demasiados intentos fallidos. Inténtalo más tarde.';

  @override
  String get errorInvalidCredential =>
      'Credenciales incorrectas. Verifica tu correo y contraseña.';

  @override
  String get errorGenericAuth => 'Error de autenticación. Inténtalo de nuevo.';

  @override
  String get welcome => 'Bienvenido/a';

  @override
  String get quickAccess => 'Accesos rápidos';

  @override
  String get myPatients => 'Mis Pacientes';

  @override
  String get templates => 'Plantillas';

  @override
  String get newActivity => 'Nueva Actividad';

  @override
  String get recommendedActivities => 'Actividades Recomendadas';

  @override
  String get noTemplatesAvailable => 'Todavía no hay plantillas disponibles.';

  @override
  String get latestProgress => 'Últimos Progresos';

  @override
  String get noActivitiesYet => 'Todavía no hay actividades registradas.';

  @override
  String get logoutTooltip => 'Cerrar sesión';

  @override
  String get patientsListTitle => 'Lista de Pacientes';

  @override
  String get patientSelectorTitle => 'Seleccionar Paciente';

  @override
  String get addPatient => 'Añadir Paciente';

  @override
  String get searchPatient => 'Buscar paciente';

  @override
  String get searchPatientHint => 'Buscar paciente...';

  @override
  String get noPatientsRegistered => 'Todavía no hay pacientes registrados.';

  @override
  String get patientFileTitle => 'Ficha del Paciente';

  @override
  String get birthDateLabel => 'Fecha de Nacimiento';

  @override
  String get initialDiagnosisLabel => 'Diagnóstico inicial';

  @override
  String get noInitialDiagnosis => 'Sin diagnóstico inicial';

  @override
  String get observationsLabel => 'Observaciones';

  @override
  String get noObservations => 'Sin observaciones registradas';

  @override
  String get addImage => 'Añadir Imagen';

  @override
  String get registerActivity => 'Registrar Actividad';

  @override
  String get editPatientFile => 'Editar Ficha';

  @override
  String get imagesFutureNotice =>
      'La gestión de imágenes se implementará en una fase posterior.';

  @override
  String get activityHistory => 'Historial de Actividades';

  @override
  String get noActivitiesForPatient =>
      'Este paciente todavía no tiene actividades registradas.';

  @override
  String get templatesTitle => 'Plantillas';

  @override
  String get templateSelectorTitle => 'Seleccionar Plantilla';

  @override
  String get createNewActivity => 'Crear/Añadir Nueva Actividad';

  @override
  String get availableTemplates => 'Plantillas Disponibles';

  @override
  String get registerActivityTitle => 'Registrar Actividad';

  @override
  String get patientSection => 'Paciente';

  @override
  String get selectPatient => 'Seleccionar paciente';

  @override
  String get noneSelectedPatient => 'Ninguno seleccionado';

  @override
  String get templateSection => 'Plantilla';

  @override
  String get selectTemplate => 'Seleccionar plantilla';

  @override
  String get noneSelectedTemplate => 'Ninguna seleccionada';

  @override
  String get configurationSection => 'Configuración';

  @override
  String get repetitionsLabel => 'Nº de repeticiones';

  @override
  String get timeLabel => 'Tiempo (min)';

  @override
  String get guidedModeLabel => 'Modo guiado';

  @override
  String get startActivity => 'Iniciar Actividad';

  @override
  String get errorSelectPatient => 'Selecciona un paciente para continuar.';

  @override
  String get errorSelectTemplate => 'Selecciona una plantilla para continuar.';

  @override
  String activityRegistered(Object name) {
    return 'Actividad registrada para $name.';
  }

  @override
  String get repetitionsShort => 'Repeticiones';

  @override
  String get timeShort => 'Tiempo';

  @override
  String get guidedShort => 'Guiado';

  @override
  String get yesShort => 'Sí';

  @override
  String get noShort => 'No';

  @override
  String get editPatientTitle => 'Editar Paciente';

  @override
  String get registerPatientTitle => 'Registrar Paciente';

  @override
  String get basicInfoSection => 'Información Básica';

  @override
  String get clinicalInfoSection => 'Información Clínica';

  @override
  String get firstNameLabel => 'Nombre';

  @override
  String get surnameLabel => 'Apellidos';

  @override
  String get birthDateLabelField => 'Fecha de nacimiento';

  @override
  String get birthDateHint => 'Selecciona una fecha';

  @override
  String get diagnosisLabelField => 'Diagnóstico inicial';

  @override
  String get observationsLabelField => 'Observaciones';

  @override
  String get saveChanges => 'Guardar Cambios';

  @override
  String get savePatient => 'Guardar Paciente';

  @override
  String get errorPatientRequiredFields =>
      'Debe completar al menos nombre, apellidos y fecha de nacimiento.';

  @override
  String get templateTypeTitle => 'Tipo de Plantilla';

  @override
  String get templateTypeQuestion => '¿Qué tipo de actividad quieres crear?';

  @override
  String get templateTypeComprehension => 'Comprensión';

  @override
  String get templateTypeMotor => 'Motora';

  @override
  String get templateTypeVocabulary => 'Vocabulario';

  @override
  String get templateTypePhonemes => 'Fonemas / Pronunciación';

  @override
  String get templateTypeSequences => 'Secuencias';

  @override
  String get templateTypeCustom => 'Personalizado';

  @override
  String templateConfigTitle(Object type) {
    return 'Plantilla: $type';
  }

  @override
  String get basicConfigSection => 'Configuración Básica';

  @override
  String get templateNameLabel => 'Nombre de la plantilla';

  @override
  String get objectiveLabel => 'Objetivo';

  @override
  String get recommendedAgeLabel => 'Edad recomendada';

  @override
  String get levelLabel => 'Nivel';

  @override
  String get levelInitial => 'Inicial';

  @override
  String get levelMedium => 'Medio';

  @override
  String get levelAdvanced => 'Avanzado';

  @override
  String get templateObservationsLabel => 'Observaciones';

  @override
  String get continueButton => 'Continuar';

  @override
  String get errorTemplateRequiredFields =>
      'Debe completar al menos nombre, objetivo y edad recomendada.';

  @override
  String get wordsTitle => 'Palabras';

  @override
  String get noWordsYet => 'Todavía no se han añadido palabras.';

  @override
  String get addNewWord => 'Añadir nueva palabra';

  @override
  String get newWordLabel => 'Escriba una nueva palabra';

  @override
  String get newWordHint => 'Escriba una palabra...';

  @override
  String get addWordButton => 'Añadir Palabra';

  @override
  String get errorEmptyWord => 'Debe escribir una palabra antes de añadirla.';

  @override
  String get errorDuplicatedWord =>
      'Esa palabra ya está añadida en la plantilla.';

  @override
  String get errorTemplateMissing => 'No se pudo recuperar la plantilla base.';

  @override
  String get errorEmptyWordList =>
      'Debe añadir al menos una palabra a la plantilla.';

  @override
  String get finalSettingsTitle => 'Ajustes Finales';

  @override
  String get repetitionsSetting => 'Nº de Repeticiones';

  @override
  String get guidedModeSetting => 'Modo Guiado';

  @override
  String get timeLimitSetting => 'Tiempo Límite (min)';

  @override
  String get soundsSetting => 'Sonidos';

  @override
  String get feedbackSetting => 'Retroalimentación';

  @override
  String get positiveReinforcementSetting => 'Refuerzo Positivo';

  @override
  String get previewButton => 'Previsualizar';

  @override
  String get errorTemplateConfigMissing =>
      'No se pudo recuperar la plantilla configurada.';

  @override
  String get previewTitle => 'Previsualización';

  @override
  String get activityPreviewTitle => 'Previsualización de Actividad';

  @override
  String get errorPreviewTemplateMissing =>
      'No se pudo cargar la plantilla para la previsualización.';

  @override
  String get backToTemplates => 'Volver a Plantillas';

  @override
  String get backToActivity => 'Volver a la Actividad';

  @override
  String get typeLabel => 'Tipo';

  @override
  String get repeatWordsLabel => 'Repite las palabras:';

  @override
  String get noWordsInTemplate => 'La plantilla no contiene palabras.';

  @override
  String get closePreview => 'Cerrar Previsualización';

  @override
  String get saveButton => 'Guardar';

  @override
  String get attendanceSection => 'Asistencia';

  @override
  String get attendedToggle => 'Asistió';

  @override
  String get absentToggle => 'Ausente';

  @override
  String get appointmentDateLabel => 'Fecha de la cita';

  @override
  String get appointmentDateHint => 'Selecciona una fecha';

  @override
  String get appointmentScheduleLabel => 'Horario';

  @override
  String get startTimeLabel => 'Desde';

  @override
  String get endTimeLabel => 'Hasta';

  @override
  String get selectTimeHint => 'Selecciona hora';

  @override
  String get registerAbsence => 'Registrar Ausencia';

  @override
  String absenceRegistered(Object name) {
    return 'Ausencia registrada para $name.';
  }

  @override
  String get errorMissingAppointmentDate => 'Selecciona la fecha de la cita.';

  @override
  String get errorMissingStartTime => 'Selecciona la hora de inicio.';

  @override
  String get errorMissingEndTime => 'Selecciona la hora de fin.';

  @override
  String get errorInvalidSchedule =>
      'La hora de inicio debe ser anterior a la hora de fin.';

  @override
  String get absentBadge => 'Ausencia';

  @override
  String get attendedBadge => 'Asistencia';

  @override
  String get exportFullReport => 'Exportar informe completo';

  @override
  String get exportRangeReport => 'Exportar informe por fechas';

  @override
  String get rangeReportTitle => 'Informe por fechas';

  @override
  String get rangeStartLabel => 'Desde';

  @override
  String get rangeEndLabel => 'Hasta';

  @override
  String get rangePickHint => 'Selecciona una fecha';

  @override
  String get generateReport => 'Generar informe';

  @override
  String get errorMissingRangeStart => 'Selecciona la fecha de inicio.';

  @override
  String get errorMissingRangeEnd => 'Selecciona la fecha de fin.';

  @override
  String get errorInvalidRange =>
      'La fecha de inicio debe ser anterior o igual a la fecha de fin.';

  @override
  String get errorNoActivitiesInRange =>
      'No hay actividades registradas en el rango seleccionado.';

  @override
  String get noPatientsFound => 'Ningún paciente coincide con la búsqueda.';

  @override
  String get errorInvalidNameChar =>
      'Solo se admiten letras, espacios, guiones y apóstrofes.';

  @override
  String get errorInvalidTemplateNameChar =>
      'Solo se admiten letras, números, espacios, guiones y guiones bajos.';

  @override
  String get errorInvalidAgeChar =>
      'Solo se admiten números y guiones para indicar el rango.';

  @override
  String get recommendedAgeHint => 'Ej.: 5 - 8';

  @override
  String get deletePatient => 'Eliminar Paciente';

  @override
  String get deleteTemplate => 'Eliminar Plantilla';

  @override
  String get confirmDeletePatientTitle => '¿Eliminar paciente?';

  @override
  String get confirmDeletePatientMessage =>
      'Esta acción eliminará al paciente y todas sus actividades registradas. No se puede deshacer.';

  @override
  String get confirmDeleteTemplateTitle => '¿Eliminar plantilla?';

  @override
  String get confirmDeleteTemplateMessage =>
      'Esta acción eliminará la plantilla, pero las actividades de los pacientes que la hayan utilizado se conservarán en su historial. No se puede deshacer.';

  @override
  String get cancelAction => 'Cancelar';

  @override
  String get confirmAction => 'Eliminar';

  @override
  String get patientDeleted => 'Paciente eliminado correctamente.';

  @override
  String get templateDeleted => 'Plantilla eliminada correctamente.';

  @override
  String get editTemplateTitle => 'Editar Plantilla';

  @override
  String get editTemplate => 'Editar Plantilla';

  @override
  String get createAccountTitle => 'Crear cuenta';

  @override
  String get createAccountSubtitle => 'Acceso para familiares';

  @override
  String get firstNameRegisterLabel => 'Nombre';

  @override
  String get firstSurnameLabel => 'Primer apellido';

  @override
  String get secondSurnameLabel => 'Segundo apellido';

  @override
  String get confirmPasswordLabel => 'Confirmar contraseña';

  @override
  String get invitationCodeLabel => 'Código de invitación del paciente';

  @override
  String get invitationCodeHint => 'Ej.: A3X9-B2K7';

  @override
  String get registerButton => 'Registrarse';

  @override
  String get alreadyHaveAccount => '¿Ya tienes cuenta? Inicia sesión.';

  @override
  String get errorAllFieldsRequired => 'Debes completar todos los campos.';

  @override
  String get errorPasswordMismatch => 'Las contraseñas no coinciden.';

  @override
  String get errorEmailInUse =>
      'Ya existe una cuenta con este correo electrónico.';

  @override
  String get errorWeakPassword => 'La contraseña es demasiado débil.';

  @override
  String get errorInvitationNotFound =>
      'El código de invitación no es válido o ya fue utilizado.';

  @override
  String get errorPatientNotFound =>
      'El paciente asociado a la invitación no existe.';

  @override
  String get registrationSuccessTitle => 'Cuenta creada correctamente';

  @override
  String get registrationSuccessMessage =>
      'Te hemos enviado un correo de verificación. Revísalo para activar tu cuenta antes de iniciar sesión.';

  @override
  String get continueAction => 'Continuar';

  @override
  String get emailNotVerifiedTitle => 'Verifica tu correo electrónico';

  @override
  String get emailNotVerifiedMessage =>
      'Antes de continuar, abre el enlace que te hemos enviado por correo y vuelve a intentarlo.';

  @override
  String get resendVerification => 'Reenviar correo de verificación';

  @override
  String get verificationSent => 'Correo de verificación reenviado.';

  @override
  String get checkAgainButton => 'Ya he verificado';

  @override
  String get generateInvitationCode => 'Generar código de invitación';

  @override
  String get invitationCodeGeneratedTitle => 'Código generado';

  @override
  String get invitationCodeGeneratedMessage =>
      'Entrégale este código al familiar para que pueda registrarse. Solo se puede usar una vez.';

  @override
  String get copyCodeAction => 'Copiar código';

  @override
  String get codeCopiedSnack => 'Código copiado al portapapeles.';

  @override
  String get choosePhotoSource => '¿Cómo quieres añadir la foto?';

  @override
  String get photoFromGallery => 'Elegir de la galería';

  @override
  String get photoFromCamera => 'Hacer una foto';

  @override
  String get removePhoto => 'Quitar foto';

  @override
  String get changePhoto => 'Cambiar foto';

  @override
  String get confirmRemovePhotoTitle => '¿Quitar la foto?';

  @override
  String get confirmRemovePhotoMessage =>
      'La foto actual del paciente se eliminará. Podrás añadir otra cuando quieras.';

  @override
  String get photoUpdated => 'Foto actualizada correctamente.';

  @override
  String get photoRemoved => 'Foto eliminada correctamente.';

  @override
  String get errorPhotoUploadFailed =>
      'Error al subir la foto. Inténtalo de nuevo.';

  @override
  String get phonemeTypeSimple => 'Simple';

  @override
  String get phonemeTypeMultiple => 'Múltiple';

  @override
  String get phonemeTypeBlend => 'Sinfón';

  @override
  String get phonemePositionInitial => 'Inicial';

  @override
  String get phonemePositionMiddle => 'Media';

  @override
  String get phonemePositionFinal => 'Final';

  @override
  String get phonemePositionBlend => 'Trabada';

  @override
  String get motorGroupLips => 'Labios';

  @override
  String get motorGroupTongue => 'Lengua';

  @override
  String get motorGroupCheeks => 'Mejillas';

  @override
  String get motorGroupJaw => 'Mandíbula';

  @override
  String get motorGroupPalate => 'Paladar';

  @override
  String get motorGroupBreath => 'Soplo';

  @override
  String get comprehensionModalityReading => 'Lectora';

  @override
  String get comprehensionModalityListening => 'Auditiva';

  @override
  String get vocabularyModeNaming => 'Denominación';

  @override
  String get vocabularyModeRiddle => 'Adivinanza';

  @override
  String get vocabularyModeCategorization => 'Categorización';

  @override
  String get customItemEditorTitleNew => 'Nuevo elemento';

  @override
  String get customItemEditorTitleEdit => 'Editar elemento';

  @override
  String get customItemTextLabel => 'Texto del elemento';

  @override
  String get customItemTextHint => 'Introduce el texto que verá el paciente';

  @override
  String get customItemSectionImage => 'Imagen';

  @override
  String get customItemSectionAudio => 'Audio';

  @override
  String get customItemSectionVideo => 'Vídeo';

  @override
  String get customItemAddImage => 'Añadir imagen';

  @override
  String get customItemChangeImage => 'Cambiar imagen';

  @override
  String get customItemRemoveImage => 'Eliminar imagen';

  @override
  String get customItemAddAudio => 'Añadir audio';

  @override
  String get customItemChangeAudio => 'Cambiar audio';

  @override
  String get customItemRemoveAudio => 'Eliminar audio';

  @override
  String get customItemAddVideo => 'Añadir vídeo';

  @override
  String get customItemChangeVideo => 'Cambiar vídeo';

  @override
  String get customItemRemoveVideo => 'Eliminar vídeo';

  @override
  String get customItemSaveButton => 'Guardar elemento';

  @override
  String get customItemImagePreview => 'Imagen seleccionada';

  @override
  String get customItemAudioPreview => 'Audio seleccionado';

  @override
  String get customItemVideoPreview => 'Vídeo seleccionado';

  @override
  String get customItemErrorEmptyText =>
      'El texto del elemento no puede estar vacío.';

  @override
  String get customItemConfirmRemoveImageTitle => 'Eliminar imagen';

  @override
  String get customItemConfirmRemoveImageMessage =>
      '¿Seguro que quieres eliminar la imagen de este elemento?';

  @override
  String get customItemConfirmRemoveAudioTitle => 'Eliminar audio';

  @override
  String get customItemConfirmRemoveAudioMessage =>
      '¿Seguro que quieres eliminar el audio de este elemento?';

  @override
  String get customItemConfirmRemoveVideoTitle => 'Eliminar vídeo';

  @override
  String get customItemConfirmRemoveVideoMessage =>
      '¿Seguro que quieres eliminar el vídeo de este elemento?';

  @override
  String get customContentTitle => 'Contenido de la plantilla';

  @override
  String get customContentEmpty => 'Todavía no has añadido ningún elemento.';

  @override
  String get customContentEmptyHint => 'Pulsa el botón para crear el primero.';

  @override
  String get customContentAddItem => 'Añadir elemento';

  @override
  String customContentItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementos',
      one: '1 elemento',
      zero: 'Sin elementos',
    );
    return '$_temp0';
  }

  @override
  String get customContentReorderHint =>
      'Mantén pulsado un elemento y arrástralo para reordenar la lista.';

  @override
  String get customContentConfirmRemoveItemTitle => 'Eliminar elemento';

  @override
  String get customContentConfirmRemoveItemMessage =>
      '¿Seguro que quieres eliminar este elemento de la plantilla?';

  @override
  String get customContentErrorEmpty =>
      'Debes añadir al menos un elemento antes de continuar.';

  @override
  String get customContentContinueButton => 'Continuar a los ajustes';

  @override
  String get customItemBadgeImage => 'Imagen';

  @override
  String get customItemBadgeAudio => 'Audio';

  @override
  String get customItemBadgeVideo => 'Vídeo';

  @override
  String get mediaViewerClose => 'Cerrar';

  @override
  String get mediaViewerImageTitle => 'Vista previa de imagen';

  @override
  String get mediaViewerAudioTitle => 'Reproductor de audio';

  @override
  String get mediaViewerVideoTitle => 'Reproductor de vídeo';

  @override
  String get mediaViewerImageHint =>
      'Pellizca para ampliar o reducir la imagen.';

  @override
  String get mediaViewerAudioPlay => 'Reproducir';

  @override
  String get mediaViewerAudioPause => 'Pausar';

  @override
  String get mediaViewerErrorLoad =>
      'No se pudo cargar el archivo. Inténtalo de nuevo.';

  @override
  String get mediaViewerSkipBack => 'Retroceder 10 segundos';

  @override
  String get mediaViewerSkipForward => 'Avanzar 10 segundos';

  @override
  String get mediaViewerSpeed => 'Velocidad de reproducción';

  @override
  String mediaViewerSpeedCurrent(String speed) {
    return '${speed}x';
  }
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SIGFLOD';

  @override
  String get appSubtitle => 'SIGFLOD ⁓ Speech Therapy';

  @override
  String get developedBy => 'Developed by Rodrigo López';

  @override
  String get portalTitle => 'Management Portal';

  @override
  String get accessAs => 'Sign in as:';

  @override
  String get roleLogopeda => 'Speech Therapist';

  @override
  String get roleFamiliar => 'Family Member';

  @override
  String get createAccount => 'Create account';

  @override
  String get createAccountFutureNotice =>
      'Account creation will be implemented in a later phase.';

  @override
  String get emailLabel => 'Email address';

  @override
  String get emailHint => 'Enter your email address...';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => 'Enter your password...';

  @override
  String get acceptTerms => 'I accept the Terms of Service and Privacy Policy.';

  @override
  String get accessButton => 'Sign in';

  @override
  String get noAccountQuestion => 'Don\'t have an account? Sign up.';

  @override
  String get errorInvalidEmail => 'Enter a valid email address.';

  @override
  String get errorShortPassword =>
      'The password must be at least 6 characters long.';

  @override
  String get errorTermsRequired =>
      'You must accept the terms and privacy policy.';

  @override
  String get errorSessionMissing => 'The user session could not be retrieved.';

  @override
  String get errorProfileNotFound =>
      'The user profile was not found in the system.';

  @override
  String get errorRoleMismatch =>
      'The credentials do not match the selected profile.';

  @override
  String get errorUnexpected =>
      'An unexpected error occurred. Please try again.';

  @override
  String get errorUserNotFound => 'No account exists with this email address.';

  @override
  String get errorWrongPassword => 'The password entered is incorrect.';

  @override
  String get errorBadEmailFormat => 'The email address format is not valid.';

  @override
  String get errorUserDisabled => 'This account has been disabled.';

  @override
  String get errorTooManyRequests =>
      'Too many failed attempts. Please try again later.';

  @override
  String get errorInvalidCredential =>
      'Invalid credentials. Check your email and password.';

  @override
  String get errorGenericAuth => 'Authentication error. Please try again.';

  @override
  String get welcome => 'Welcome';

  @override
  String get quickAccess => 'Quick access';

  @override
  String get myPatients => 'My Patients';

  @override
  String get templates => 'Templates';

  @override
  String get newActivity => 'New Activity';

  @override
  String get recommendedActivities => 'Recommended Activities';

  @override
  String get noTemplatesAvailable => 'No templates available yet.';

  @override
  String get latestProgress => 'Latest Progress';

  @override
  String get noActivitiesYet => 'No activities registered yet.';

  @override
  String get logoutTooltip => 'Sign out';

  @override
  String get patientsListTitle => 'Patient List';

  @override
  String get patientSelectorTitle => 'Select Patient';

  @override
  String get addPatient => 'Add Patient';

  @override
  String get searchPatient => 'Search patient';

  @override
  String get searchPatientHint => 'Search patient...';

  @override
  String get noPatientsRegistered => 'No patients registered yet.';

  @override
  String get patientFileTitle => 'Patient File';

  @override
  String get birthDateLabel => 'Date of Birth';

  @override
  String get initialDiagnosisLabel => 'Initial diagnosis';

  @override
  String get noInitialDiagnosis => 'No initial diagnosis';

  @override
  String get observationsLabel => 'Observations';

  @override
  String get noObservations => 'No observations recorded';

  @override
  String get addImage => 'Add Image';

  @override
  String get registerActivity => 'Register Activity';

  @override
  String get editPatientFile => 'Edit File';

  @override
  String get imagesFutureNotice =>
      'Image management will be implemented in a later phase.';

  @override
  String get activityHistory => 'Activity History';

  @override
  String get noActivitiesForPatient =>
      'This patient has no activities registered yet.';

  @override
  String get templatesTitle => 'Templates';

  @override
  String get templateSelectorTitle => 'Select Template';

  @override
  String get createNewActivity => 'Create/Add New Activity';

  @override
  String get availableTemplates => 'Available Templates';

  @override
  String get registerActivityTitle => 'Register Activity';

  @override
  String get patientSection => 'Patient';

  @override
  String get selectPatient => 'Select patient';

  @override
  String get noneSelectedPatient => 'None selected';

  @override
  String get templateSection => 'Template';

  @override
  String get selectTemplate => 'Select template';

  @override
  String get noneSelectedTemplate => 'None selected';

  @override
  String get configurationSection => 'Configuration';

  @override
  String get repetitionsLabel => 'No. of repetitions';

  @override
  String get timeLabel => 'Time (min)';

  @override
  String get guidedModeLabel => 'Guided mode';

  @override
  String get startActivity => 'Start Activity';

  @override
  String get errorSelectPatient => 'Select a patient to continue.';

  @override
  String get errorSelectTemplate => 'Select a template to continue.';

  @override
  String activityRegistered(Object name) {
    return 'Activity registered for $name.';
  }

  @override
  String get repetitionsShort => 'Repetitions';

  @override
  String get timeShort => 'Time';

  @override
  String get guidedShort => 'Guided';

  @override
  String get yesShort => 'Yes';

  @override
  String get noShort => 'No';

  @override
  String get editPatientTitle => 'Edit Patient';

  @override
  String get registerPatientTitle => 'Register Patient';

  @override
  String get basicInfoSection => 'Basic Information';

  @override
  String get clinicalInfoSection => 'Clinical Information';

  @override
  String get firstNameLabel => 'First name';

  @override
  String get surnameLabel => 'Surname';

  @override
  String get birthDateLabelField => 'Date of birth';

  @override
  String get birthDateHint => 'Select a date';

  @override
  String get diagnosisLabelField => 'Initial diagnosis';

  @override
  String get observationsLabelField => 'Observations';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get savePatient => 'Save Patient';

  @override
  String get errorPatientRequiredFields =>
      'You must fill in at least first name, surname, and date of birth.';

  @override
  String get templateTypeTitle => 'Template Type';

  @override
  String get templateTypeQuestion =>
      'What type of activity do you want to create?';

  @override
  String get templateTypeComprehension => 'Comprehension';

  @override
  String get templateTypeMotor => 'Motor';

  @override
  String get templateTypeVocabulary => 'Vocabulary';

  @override
  String get templateTypePhonemes => 'Phonemes / Pronunciation';

  @override
  String get templateTypeSequences => 'Sequences';

  @override
  String get templateTypeCustom => 'Custom';

  @override
  String templateConfigTitle(Object type) {
    return 'Template: $type';
  }

  @override
  String get basicConfigSection => 'Basic Configuration';

  @override
  String get templateNameLabel => 'Template name';

  @override
  String get objectiveLabel => 'Objective';

  @override
  String get recommendedAgeLabel => 'Recommended age';

  @override
  String get levelLabel => 'Level';

  @override
  String get levelInitial => 'Initial';

  @override
  String get levelMedium => 'Medium';

  @override
  String get levelAdvanced => 'Advanced';

  @override
  String get templateObservationsLabel => 'Observations';

  @override
  String get continueButton => 'Continue';

  @override
  String get errorTemplateRequiredFields =>
      'You must fill in at least name, objective, and recommended age.';

  @override
  String get wordsTitle => 'Words';

  @override
  String get noWordsYet => 'No words have been added yet.';

  @override
  String get addNewWord => 'Add new word';

  @override
  String get newWordLabel => 'Type a new word';

  @override
  String get newWordHint => 'Type a word...';

  @override
  String get addWordButton => 'Add Word';

  @override
  String get errorEmptyWord => 'You must type a word before adding it.';

  @override
  String get errorDuplicatedWord => 'That word is already in the template.';

  @override
  String get errorTemplateMissing =>
      'The base template could not be retrieved.';

  @override
  String get errorEmptyWordList =>
      'You must add at least one word to the template.';

  @override
  String get finalSettingsTitle => 'Final Settings';

  @override
  String get repetitionsSetting => 'No. of Repetitions';

  @override
  String get guidedModeSetting => 'Guided Mode';

  @override
  String get timeLimitSetting => 'Time Limit (min)';

  @override
  String get soundsSetting => 'Sounds';

  @override
  String get feedbackSetting => 'Feedback';

  @override
  String get positiveReinforcementSetting => 'Positive Reinforcement';

  @override
  String get previewButton => 'Preview';

  @override
  String get errorTemplateConfigMissing =>
      'The configured template could not be retrieved.';

  @override
  String get previewTitle => 'Preview';

  @override
  String get activityPreviewTitle => 'Activity Preview';

  @override
  String get errorPreviewTemplateMissing =>
      'The template could not be loaded for preview.';

  @override
  String get backToTemplates => 'Back to Templates';

  @override
  String get backToActivity => 'Back to Activity';

  @override
  String get typeLabel => 'Type';

  @override
  String get repeatWordsLabel => 'Repeat the words:';

  @override
  String get noWordsInTemplate => 'The template contains no words.';

  @override
  String get closePreview => 'Close Preview';

  @override
  String get saveButton => 'Save';

  @override
  String get attendanceSection => 'Attendance';

  @override
  String get attendedToggle => 'Attended';

  @override
  String get absentToggle => 'Absent';

  @override
  String get appointmentDateLabel => 'Appointment date';

  @override
  String get appointmentDateHint => 'Select a date';

  @override
  String get appointmentScheduleLabel => 'Schedule';

  @override
  String get startTimeLabel => 'From';

  @override
  String get endTimeLabel => 'To';

  @override
  String get selectTimeHint => 'Select time';

  @override
  String get registerAbsence => 'Register Absence';

  @override
  String absenceRegistered(Object name) {
    return 'Absence registered for $name.';
  }

  @override
  String get errorMissingAppointmentDate => 'Select the appointment date.';

  @override
  String get errorMissingStartTime => 'Select the start time.';

  @override
  String get errorMissingEndTime => 'Select the end time.';

  @override
  String get errorInvalidSchedule =>
      'The start time must be earlier than the end time.';

  @override
  String get absentBadge => 'Absence';

  @override
  String get attendedBadge => 'Attendance';

  @override
  String get exportFullReport => 'Export full report';

  @override
  String get exportRangeReport => 'Export report by date';

  @override
  String get rangeReportTitle => 'Report by date';

  @override
  String get rangeStartLabel => 'From';

  @override
  String get rangeEndLabel => 'To';

  @override
  String get rangePickHint => 'Select a date';

  @override
  String get generateReport => 'Generate report';

  @override
  String get errorMissingRangeStart => 'Select the start date.';

  @override
  String get errorMissingRangeEnd => 'Select the end date.';

  @override
  String get errorInvalidRange =>
      'The start date must be earlier than or equal to the end date.';

  @override
  String get errorNoActivitiesInRange =>
      'No activities recorded in the selected range.';

  @override
  String get noPatientsFound => 'No patients match the search.';

  @override
  String get errorInvalidNameChar =>
      'Only letters, spaces, hyphens, and apostrophes are allowed.';

  @override
  String get errorInvalidTemplateNameChar =>
      'Only letters, numbers, spaces, hyphens, and underscores are allowed.';

  @override
  String get errorInvalidAgeChar =>
      'Only numbers and hyphens are allowed to indicate the range.';

  @override
  String get recommendedAgeHint => 'E.g.: 5 - 8';

  @override
  String get deletePatient => 'Delete Patient';

  @override
  String get deleteTemplate => 'Delete Template';

  @override
  String get confirmDeletePatientTitle => 'Delete patient?';

  @override
  String get confirmDeletePatientMessage =>
      'This will delete the patient and all their recorded activities. This action cannot be undone.';

  @override
  String get confirmDeleteTemplateTitle => 'Delete template?';

  @override
  String get confirmDeleteTemplateMessage =>
      'This will delete the template, but the activities of patients who used it will remain in their history. This action cannot be undone.';

  @override
  String get cancelAction => 'Cancel';

  @override
  String get confirmAction => 'Delete';

  @override
  String get patientDeleted => 'Patient deleted successfully.';

  @override
  String get templateDeleted => 'Template deleted successfully.';

  @override
  String get editTemplateTitle => 'Edit Template';

  @override
  String get editTemplate => 'Edit Template';

  @override
  String get createAccountTitle => 'Create account';

  @override
  String get createAccountSubtitle => 'Access for family members';

  @override
  String get firstNameRegisterLabel => 'First name';

  @override
  String get firstSurnameLabel => 'First surname';

  @override
  String get secondSurnameLabel => 'Second surname';

  @override
  String get confirmPasswordLabel => 'Confirm password';

  @override
  String get invitationCodeLabel => 'Patient invitation code';

  @override
  String get invitationCodeHint => 'E.g.: A3X9-B2K7';

  @override
  String get registerButton => 'Register';

  @override
  String get alreadyHaveAccount => 'Already have an account? Sign in.';

  @override
  String get errorAllFieldsRequired => 'All fields are required.';

  @override
  String get errorPasswordMismatch => 'Passwords do not match.';

  @override
  String get errorEmailInUse =>
      'An account already exists with this email address.';

  @override
  String get errorWeakPassword => 'The password is too weak.';

  @override
  String get errorInvitationNotFound =>
      'The invitation code is invalid or has already been used.';

  @override
  String get errorPatientNotFound =>
      'The patient linked to the invitation does not exist.';

  @override
  String get registrationSuccessTitle => 'Account created successfully';

  @override
  String get registrationSuccessMessage =>
      'We have sent you a verification email. Please open it to activate your account before signing in.';

  @override
  String get continueAction => 'Continue';

  @override
  String get emailNotVerifiedTitle => 'Verify your email address';

  @override
  String get emailNotVerifiedMessage =>
      'Before continuing, please open the link we sent to your email and try again.';

  @override
  String get resendVerification => 'Resend verification email';

  @override
  String get verificationSent => 'Verification email resent.';

  @override
  String get checkAgainButton => 'I have verified';

  @override
  String get generateInvitationCode => 'Generate invitation code';

  @override
  String get invitationCodeGeneratedTitle => 'Code generated';

  @override
  String get invitationCodeGeneratedMessage =>
      'Hand this code to the family member so they can register. It can only be used once.';

  @override
  String get copyCodeAction => 'Copy code';

  @override
  String get codeCopiedSnack => 'Code copied to clipboard.';

  @override
  String get choosePhotoSource => 'How do you want to add the photo?';

  @override
  String get photoFromGallery => 'Choose from gallery';

  @override
  String get photoFromCamera => 'Take a photo';

  @override
  String get removePhoto => 'Remove photo';

  @override
  String get changePhoto => 'Change photo';

  @override
  String get confirmRemovePhotoTitle => 'Remove photo?';

  @override
  String get confirmRemovePhotoMessage =>
      'The patient\'s current photo will be removed. You can add another whenever you want.';

  @override
  String get photoUpdated => 'Photo updated successfully.';

  @override
  String get photoRemoved => 'Photo removed successfully.';

  @override
  String get errorPhotoUploadFailed =>
      'Failed to upload the photo. Please try again.';
}

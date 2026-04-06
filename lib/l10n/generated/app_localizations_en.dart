// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get localizationBootstrap => 'App localization is configured.';

  @override
  String get errorInvalidCredentials => 'Invalid email or password.';

  @override
  String get errorAnonymousAuthDisabled =>
      'Guest sign-in is currently disabled.';

  @override
  String get errorEmail => 'Check the email address and try again.';

  @override
  String get errorPassword => 'Check the password and try again.';

  @override
  String get errorNetwork => 'Connection problem. Try again.';

  @override
  String get errorDeleteAccountSetupRequired =>
      'Delete account still requires additional Supabase setup.';

  @override
  String get errorDeleteAccountFailed =>
      'Could not delete the account. Try again.';

  @override
  String get errorSharedUsersSetupRequired =>
      'The shared_users table is missing or its schema does not match the template.';

  @override
  String get errorDeleteAccountNotImplemented =>
      'Delete account is not ready yet.';

  @override
  String get errorUnknown => 'An unexpected error occurred.';

  @override
  String errorWithKey(Object errorKey) {
    return 'An error occurred: $errorKey';
  }

  @override
  String get guestDisplayName => 'Guest';

  @override
  String get registeredUserDisplayName => 'User';

  @override
  String get loadingLabel => 'Loading...';

  @override
  String get sessionErrorTitle => 'Session error';

  @override
  String get accountTypeGuest => 'guest';

  @override
  String get accountTypeRegistered => 'signed in';

  @override
  String get commonYes => 'yes';

  @override
  String get commonNo => 'no';

  @override
  String get userTierGuest => 'guest';

  @override
  String get userTierRegistered => 'account';

  @override
  String get userTierPro => 'Pro';

  @override
  String get homeTitle => 'Home';

  @override
  String get currentSessionTitle => 'Current session';

  @override
  String sessionUserId(Object value) {
    return 'User ID: $value';
  }

  @override
  String sessionAccountType(Object value) {
    return 'Account type: $value';
  }

  @override
  String sessionPlan(Object value) {
    return 'Plan: $value';
  }

  @override
  String sessionPro(Object value) {
    return 'Pro: $value';
  }

  @override
  String sessionEmail(Object value) {
    return 'Email: $value';
  }

  @override
  String sessionDisplayNameValue(Object value) {
    return 'Display name: $value';
  }

  @override
  String sessionFirstName(Object value) {
    return 'First name: $value';
  }

  @override
  String get developerToolsTitle => 'Developer tools';

  @override
  String get retryButtonLabel => 'Try again';

  @override
  String get welcomeTitle => 'Welcome';

  @override
  String get welcomeBody =>
      'Continue as a guest or sign in to an existing account.';

  @override
  String get continueAsGuestButtonLabel => 'Continue as guest';

  @override
  String get loginButtonLabel => 'Log in';

  @override
  String get loginScreenTitle => 'Log in';

  @override
  String get loginExistingAccountTitle => 'Log in to an existing account';

  @override
  String get loginExistingAccountBody =>
      'Use your email address and password to switch to an existing account.';

  @override
  String get emailFieldLabel => 'Email';

  @override
  String get passwordFieldLabel => 'Password';

  @override
  String get switchAccountWarningTitle => 'You\'re switching accounts';

  @override
  String get switchAccountWarningBody =>
      'Logging in here will switch you from the current guest account to another account. Guest data and Pro access are not merged automatically.';

  @override
  String get registerScreenTitle => 'Sign up';

  @override
  String get secureGuestAccountTitle => 'Secure this guest account';

  @override
  String get secureGuestAccountBody =>
      'This will keep your current data and connect this guest account to an email address and password.';

  @override
  String get registerButtonLabel => 'Sign up';

  @override
  String get profileSavedSnackbar => 'Profile saved';

  @override
  String get proEnabledSnackbar => 'Pro enabled';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileLanguageSectionTitle => 'App language';

  @override
  String get profileLanguageSectionDescription =>
      'Choose whether the app should use the device language, Polish, or English.';

  @override
  String get firstNameFieldLabel => 'First name';

  @override
  String get languageOptionSystem => 'Automatic';

  @override
  String get languageOptionSystemDescription =>
      'Uses the device language. For unsupported languages, the app falls back to English.';

  @override
  String get languageOptionPolish => 'Polski';

  @override
  String get languageOptionEnglish => 'English';

  @override
  String get saveFirstNameButtonLabel => 'Save first name';

  @override
  String get accountSecuredSnackbar => 'Account secured';

  @override
  String get logoutButtonLabel => 'Log out';

  @override
  String get buyProButtonLabel => 'Buy Pro';

  @override
  String get deleteAccountButtonLabel => 'Delete account';

  @override
  String get discardChangesTitle => 'Discard changes?';

  @override
  String get discardChangesBody =>
      'You have unsaved changes. If you leave now, they will be lost.';

  @override
  String get stayButtonLabel => 'Stay';

  @override
  String get discardButtonLabel => 'Discard';

  @override
  String get closeButtonLabel => 'Close';

  @override
  String get protectProBannerTitle => 'Protect access to Pro';

  @override
  String get protectProBannerBody =>
      'This guest account already has Pro. Register this account so you do not lose access in the future.';

  @override
  String get developerDiagnosticsTitle => 'Debug-only diagnostics';

  @override
  String get developerDiagnosticsBody =>
      'Use this screen to inspect the local app configuration and integration status.';

  @override
  String get revenueCatDisconnectedTitle => 'RevenueCat is not connected';

  @override
  String get revenueCatDisconnectedBody =>
      'Add RevenueCat keys to config/api-keys.json when you\'re ready to test subscriptions.';

  @override
  String get sessionSectionTitle => 'Session';

  @override
  String get loggedInLabel => 'Signed in';

  @override
  String get anonymousLabel => 'Anonymous';

  @override
  String get planLabel => 'Plan';

  @override
  String get proLabel => 'Pro';

  @override
  String get userIdLabel => 'User ID';

  @override
  String get emailLabel => 'Email';

  @override
  String get displayNameLabel => 'Display name';

  @override
  String get supabaseSectionTitle => 'Supabase';

  @override
  String get keysConfiguredLabel => 'Keys configured';

  @override
  String get supabaseUrlLabel => 'Supabase URL';

  @override
  String get revenueCatSectionTitle => 'RevenueCat';

  @override
  String get supportedPlatformLabel => 'Supported platform';

  @override
  String get sdkActiveLabel => 'SDK active';

  @override
  String get currentKeySourceLabel => 'Current key source';

  @override
  String get missingValueLabel => 'missing';

  @override
  String get debugForceProTitle => 'Debug: force Pro status';

  @override
  String get debugForceProSubtitle =>
      'Works only without active RevenueCat and only in the debug tool.';

  @override
  String get missingSupabaseAgentPrompt =>
      'Connect `Supabase MCP` to my Supabase project and fill `config/api-keys.json` with `SUPABASE_URL` and `SUPABASE_ANON_KEY`.';

  @override
  String get missingSupabaseTitle => 'Supabase keys are missing';

  @override
  String get missingSupabaseBody =>
      'Add Supabase keys to the config file and restart the app.';

  @override
  String get missingSupabaseFileLabel => 'Fill in this file';

  @override
  String get missingSupabaseFilePath => 'config/api-keys.json';

  @override
  String get missingSupabaseStep1Title => 'Step 1: install `Supabase MCP`';

  @override
  String get missingSupabaseStep1Body =>
      'First add `Supabase MCP` to your AI agent.';

  @override
  String get missingSupabaseStep2Title =>
      'Step 2: paste this prompt into the agent';

  @override
  String get copyPromptButtonLabel => 'Copy prompt';

  @override
  String get promptCopiedSnackbar => 'Prompt copied';

  @override
  String get missingSupabaseStep3Title => 'Step 3: close and reopen the app';

  @override
  String get missingSupabaseStep3Body =>
      'When the agent fills in the keys file, close the app and launch it again.';

  @override
  String get sharedUsersAgentPrompt =>
      'Run task `docs/tasks/02_SUPABASE_SHARED_USERS_SETUP.md` and bring the `shared_users` table to minimal compatibility with this project using `Supabase MCP`.';

  @override
  String get sharedUsersSetupTitle =>
      'The `shared_users` table is missing in Supabase';

  @override
  String get sharedUsersSetupBody =>
      'The app cannot load additional user data, such as the first name, because the `shared_users` table does not exist or its structure does not match the minimal assumptions.';

  @override
  String get sharedUsersGuideLabel => 'Use the prepared guide:';

  @override
  String get sharedUsersGuideFile => '02_SUPABASE_SHARED_USERS_SETUP.md';

  @override
  String get sharedUsersAiPromptTitle => 'Paste this prompt into your AI agent';

  @override
  String get sharedUsersAiHelpBody =>
      'If your AI agent has access to Supabase MCP, it can configure everything for you automatically using the prepared guide.';

  @override
  String get deleteAccountSetupAgentPrompt =>
      'Run task `docs/tasks/03_SUPABASE_DELETE_ACCOUNT_SETUP.md`, finish deploying `delete-account` in Supabase, and switch the profile to the ready flow using `Supabase MCP`.';

  @override
  String get deleteAccountSetupTitle =>
      'Delete account requires additional setup';

  @override
  String get deleteAccountSetupBody =>
      'The `Delete account` logic is already scaffolded in the template, but the `delete-account` function has not yet been deployed in this project, and the profile still leads to this setup screen.';

  @override
  String get deleteAccountGuideLabel => 'Use the prepared guide:';

  @override
  String get deleteAccountGuideFile => '03_SUPABASE_DELETE_ACCOUNT_SETUP.md';

  @override
  String get deleteAccountAiPromptTitle =>
      'Paste this prompt into your AI agent';

  @override
  String get deleteAccountAiHelpBody =>
      'If your AI agent has access to Supabase MCP, it can deploy the `delete-account` function, verify `verify_jwt`, switch the profile to the ready flow, and update the tests.';

  @override
  String get deleteAccountDialogTitle => 'Delete account?';

  @override
  String get deleteAccountDialogBody =>
      'Are you sure you want to delete your account? This action is permanent and cannot be undone. All your data and Pro access will be lost.';

  @override
  String get deleteAccountCancelButtonLabel => 'Cancel';

  @override
  String get deleteAccountConfirmButtonLabel => 'Delete';

  @override
  String get carBrandLabel => 'Brand';

  @override
  String get carModelNameLabel => 'Model name';

  @override
  String get carSeriesLabel => 'Series';

  @override
  String get carPurchasePriceLabel => 'Purchase price';

  @override
  String get carEstimatedValueLabel => 'Estimated value';

  @override
  String get carPhotoLabel => 'Photo';

  @override
  String get garageTitle => 'My Garage';

  @override
  String get garageEmptyStateTitle => 'Your garage is empty';

  @override
  String get garageEmptyStateSubtitle =>
      'Add your first 1/64 model to start your collection.';

  @override
  String get garageAddFirstCarButton => 'Add first model';

  @override
  String get garageTotalValue => 'Collection value';

  @override
  String get garageTotalItems => 'Items in garage';

  @override
  String get garageCarDetails => 'Details';

  @override
  String get garageDeleteCarConfirm =>
      'Are you sure you want to delete this model?';

  @override
  String get garageSuccessDeleted => 'Model has been deleted';

  @override
  String get carFormAddTitle => 'Add model';

  @override
  String get carFormEditTitle => 'Edit model';

  @override
  String get carFormSaveButton => 'Save';

  @override
  String get carFormAddPhotoLabel => 'Add photo';

  @override
  String get carFormChangePhotoLabel => 'Change photo';

  @override
  String get carFormSuccessAdded => 'Model added successfully';

  @override
  String get carFormSuccessEdited => 'Model edited successfully';

  @override
  String get carProducerLabel => 'Toy Producer (Logo)';

  @override
  String get carPurchaseDateLabel => 'Purchase Date';

  @override
  String get carGalleryLabel => 'Photo Gallery';

  @override
  String get carSearchPhotosLabel => 'Search Internet Photos';

  @override
  String get carAiEstimateLabel => 'AI Valuation';

  @override
  String get carFormAddPhotoPlaceholder => 'Add up to 5 photos';

  @override
  String get cameraButtonLabel => 'Camera';

  @override
  String get galleryButtonLabel => 'Gallery';

  @override
  String get newsTitle => 'Nowości';

  @override
  String get errorLoadingNews =>
      'Nie udało się wczytać nowości ze świata 1/64.';
}

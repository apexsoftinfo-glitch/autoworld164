import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_pl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
  static const List<Locale> supportedLocales = <Locale>[Locale('pl')];

  /// Technical placeholder used to bootstrap Flutter localization before migrating existing UI strings.
  ///
  /// In pl, this message translates to:
  /// **'Lokalizacja aplikacji jest skonfigurowana.'**
  String get localizationBootstrap;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In pl, this message translates to:
  /// **'Nieprawidłowy email lub hasło.'**
  String get errorInvalidCredentials;

  /// No description provided for @errorAnonymousAuthDisabled.
  ///
  /// In pl, this message translates to:
  /// **'Logowanie jako gość jest obecnie wyłączone.'**
  String get errorAnonymousAuthDisabled;

  /// No description provided for @errorEmail.
  ///
  /// In pl, this message translates to:
  /// **'Sprawdź adres email i spróbuj ponownie.'**
  String get errorEmail;

  /// No description provided for @errorPassword.
  ///
  /// In pl, this message translates to:
  /// **'Sprawdź hasło i spróbuj ponownie.'**
  String get errorPassword;

  /// No description provided for @errorNetwork.
  ///
  /// In pl, this message translates to:
  /// **'Problem z połączeniem. Spróbuj ponownie.'**
  String get errorNetwork;

  /// No description provided for @errorDeleteAccountSetupRequired.
  ///
  /// In pl, this message translates to:
  /// **'Delete account wymaga jeszcze dokończenia setupu w Supabase.'**
  String get errorDeleteAccountSetupRequired;

  /// No description provided for @errorDeleteAccountFailed.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się usunąć konta. Spróbuj ponownie.'**
  String get errorDeleteAccountFailed;

  /// No description provided for @errorSharedUsersSetupRequired.
  ///
  /// In pl, this message translates to:
  /// **'Brakuje tabeli shared_users albo jej schema nie zgadza się z template.'**
  String get errorSharedUsersSetupRequired;

  /// No description provided for @errorDeleteAccountNotImplemented.
  ///
  /// In pl, this message translates to:
  /// **'Usuwanie konta nie jest jeszcze gotowe.'**
  String get errorDeleteAccountNotImplemented;

  /// No description provided for @errorUnknown.
  ///
  /// In pl, this message translates to:
  /// **'Wystąpił nieoczekiwany błąd.'**
  String get errorUnknown;

  /// Fallback error message for unknown error keys.
  ///
  /// In pl, this message translates to:
  /// **'Wystąpił błąd: {errorKey}'**
  String errorWithKey(Object errorKey);

  /// No description provided for @guestDisplayName.
  ///
  /// In pl, this message translates to:
  /// **'Gość'**
  String get guestDisplayName;

  /// No description provided for @registeredUserDisplayName.
  ///
  /// In pl, this message translates to:
  /// **'Użytkownik'**
  String get registeredUserDisplayName;

  /// No description provided for @loadingLabel.
  ///
  /// In pl, this message translates to:
  /// **'Ładowanie...'**
  String get loadingLabel;

  /// No description provided for @sessionErrorTitle.
  ///
  /// In pl, this message translates to:
  /// **'Błąd sesji'**
  String get sessionErrorTitle;

  /// No description provided for @accountTypeGuest.
  ///
  /// In pl, this message translates to:
  /// **'gość'**
  String get accountTypeGuest;

  /// No description provided for @accountTypeRegistered.
  ///
  /// In pl, this message translates to:
  /// **'zalogowany'**
  String get accountTypeRegistered;

  /// No description provided for @commonYes.
  ///
  /// In pl, this message translates to:
  /// **'tak'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In pl, this message translates to:
  /// **'nie'**
  String get commonNo;

  /// No description provided for @userTierGuest.
  ///
  /// In pl, this message translates to:
  /// **'gość'**
  String get userTierGuest;

  /// No description provided for @userTierRegistered.
  ///
  /// In pl, this message translates to:
  /// **'konto'**
  String get userTierRegistered;

  /// No description provided for @userTierPro.
  ///
  /// In pl, this message translates to:
  /// **'Pro'**
  String get userTierPro;

  /// No description provided for @homeTitle.
  ///
  /// In pl, this message translates to:
  /// **'Start'**
  String get homeTitle;

  /// No description provided for @currentSessionTitle.
  ///
  /// In pl, this message translates to:
  /// **'Aktualna sesja'**
  String get currentSessionTitle;

  /// No description provided for @sessionUserId.
  ///
  /// In pl, this message translates to:
  /// **'ID użytkownika: {value}'**
  String sessionUserId(Object value);

  /// No description provided for @sessionAccountType.
  ///
  /// In pl, this message translates to:
  /// **'Typ konta: {value}'**
  String sessionAccountType(Object value);

  /// No description provided for @sessionPlan.
  ///
  /// In pl, this message translates to:
  /// **'Plan: {value}'**
  String sessionPlan(Object value);

  /// No description provided for @sessionPro.
  ///
  /// In pl, this message translates to:
  /// **'Pro: {value}'**
  String sessionPro(Object value);

  /// No description provided for @sessionEmail.
  ///
  /// In pl, this message translates to:
  /// **'E-mail: {value}'**
  String sessionEmail(Object value);

  /// No description provided for @sessionDisplayNameValue.
  ///
  /// In pl, this message translates to:
  /// **'Nazwa wyświetlana: {value}'**
  String sessionDisplayNameValue(Object value);

  /// No description provided for @sessionFirstName.
  ///
  /// In pl, this message translates to:
  /// **'Imię: {value}'**
  String sessionFirstName(Object value);

  /// No description provided for @developerToolsTitle.
  ///
  /// In pl, this message translates to:
  /// **'Narzędzia deweloperskie'**
  String get developerToolsTitle;

  /// No description provided for @retryButtonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Spróbuj ponownie'**
  String get retryButtonLabel;

  /// No description provided for @welcomeTitle.
  ///
  /// In pl, this message translates to:
  /// **'Witaj'**
  String get welcomeTitle;

  /// No description provided for @welcomeBody.
  ///
  /// In pl, this message translates to:
  /// **'Kontynuuj jako gość albo zaloguj się na istniejące konto.'**
  String get welcomeBody;

  /// No description provided for @continueAsGuestButtonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Kontynuuj jako gość'**
  String get continueAsGuestButtonLabel;

  /// No description provided for @loginButtonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Zaloguj się'**
  String get loginButtonLabel;

  /// No description provided for @loginScreenTitle.
  ///
  /// In pl, this message translates to:
  /// **'Logowanie'**
  String get loginScreenTitle;

  /// No description provided for @loginExistingAccountTitle.
  ///
  /// In pl, this message translates to:
  /// **'Zaloguj się na istniejące konto'**
  String get loginExistingAccountTitle;

  /// No description provided for @loginExistingAccountBody.
  ///
  /// In pl, this message translates to:
  /// **'Użyj adresu e-mail i hasła, aby przełączyć się na istniejące konto.'**
  String get loginExistingAccountBody;

  /// No description provided for @emailFieldLabel.
  ///
  /// In pl, this message translates to:
  /// **'E-mail'**
  String get emailFieldLabel;

  /// No description provided for @passwordFieldLabel.
  ///
  /// In pl, this message translates to:
  /// **'Hasło'**
  String get passwordFieldLabel;

  /// No description provided for @switchAccountWarningTitle.
  ///
  /// In pl, this message translates to:
  /// **'Przełączasz konto'**
  String get switchAccountWarningTitle;

  /// No description provided for @switchAccountWarningBody.
  ///
  /// In pl, this message translates to:
  /// **'Logowanie w tym miejscu przełączy Cię z obecnego konta gościa na inne konto. Dane gościa i Pro nie łączą się automatycznie.'**
  String get switchAccountWarningBody;

  /// No description provided for @registerScreenTitle.
  ///
  /// In pl, this message translates to:
  /// **'Rejestracja'**
  String get registerScreenTitle;

  /// No description provided for @secureGuestAccountTitle.
  ///
  /// In pl, this message translates to:
  /// **'Zabezpiecz to konto gościa'**
  String get secureGuestAccountTitle;

  /// No description provided for @secureGuestAccountBody.
  ///
  /// In pl, this message translates to:
  /// **'To zachowa Twoje obecne dane i połączy to konto gościa z adresem e-mail oraz hasłem.'**
  String get secureGuestAccountBody;

  /// No description provided for @registerButtonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Zarejestruj się'**
  String get registerButtonLabel;

  /// No description provided for @profileSavedSnackbar.
  ///
  /// In pl, this message translates to:
  /// **'Profil zapisany'**
  String get profileSavedSnackbar;

  /// No description provided for @proEnabledSnackbar.
  ///
  /// In pl, this message translates to:
  /// **'Pro aktywowane'**
  String get proEnabledSnackbar;

  /// No description provided for @profileTitle.
  ///
  /// In pl, this message translates to:
  /// **'Profil'**
  String get profileTitle;

  /// No description provided for @firstNameFieldLabel.
  ///
  /// In pl, this message translates to:
  /// **'Imię'**
  String get firstNameFieldLabel;

  /// No description provided for @saveFirstNameButtonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Zapisz imię'**
  String get saveFirstNameButtonLabel;

  /// No description provided for @accountSecuredSnackbar.
  ///
  /// In pl, this message translates to:
  /// **'Konto zabezpieczone'**
  String get accountSecuredSnackbar;

  /// No description provided for @logoutButtonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Wyloguj się'**
  String get logoutButtonLabel;

  /// No description provided for @buyProButtonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Kup Pro'**
  String get buyProButtonLabel;

  /// No description provided for @deleteAccountButtonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Usuń konto'**
  String get deleteAccountButtonLabel;

  /// No description provided for @discardChangesTitle.
  ///
  /// In pl, this message translates to:
  /// **'Odrzucić zmiany?'**
  String get discardChangesTitle;

  /// No description provided for @discardChangesBody.
  ///
  /// In pl, this message translates to:
  /// **'Masz niezapisane zmiany. Jeśli wyjdziesz teraz, zostaną utracone.'**
  String get discardChangesBody;

  /// No description provided for @stayButtonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Zostań'**
  String get stayButtonLabel;

  /// No description provided for @discardButtonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Odrzuć'**
  String get discardButtonLabel;

  /// No description provided for @closeButtonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Zamknij'**
  String get closeButtonLabel;

  /// No description provided for @protectProBannerTitle.
  ///
  /// In pl, this message translates to:
  /// **'Zabezpiecz dostęp do Pro'**
  String get protectProBannerTitle;

  /// No description provided for @protectProBannerBody.
  ///
  /// In pl, this message translates to:
  /// **'To konto gościa ma już Pro. Zarejestruj to konto, aby nie stracić dostępu w przyszłości.'**
  String get protectProBannerBody;

  /// No description provided for @developerDiagnosticsTitle.
  ///
  /// In pl, this message translates to:
  /// **'Diagnostyka tylko dla debug'**
  String get developerDiagnosticsTitle;

  /// No description provided for @developerDiagnosticsBody.
  ///
  /// In pl, this message translates to:
  /// **'Użyj tego ekranu, aby sprawdzić lokalną konfigurację aplikacji i status integracji.'**
  String get developerDiagnosticsBody;

  /// No description provided for @revenueCatDisconnectedTitle.
  ///
  /// In pl, this message translates to:
  /// **'RevenueCat nie jest podłączony'**
  String get revenueCatDisconnectedTitle;

  /// No description provided for @revenueCatDisconnectedBody.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj klucze RevenueCat do config/api-keys.json, gdy będziesz gotowy testować subskrypcje.'**
  String get revenueCatDisconnectedBody;

  /// No description provided for @sessionSectionTitle.
  ///
  /// In pl, this message translates to:
  /// **'Sesja'**
  String get sessionSectionTitle;

  /// No description provided for @loggedInLabel.
  ///
  /// In pl, this message translates to:
  /// **'Zalogowany'**
  String get loggedInLabel;

  /// No description provided for @anonymousLabel.
  ///
  /// In pl, this message translates to:
  /// **'Anonimowy'**
  String get anonymousLabel;

  /// No description provided for @planLabel.
  ///
  /// In pl, this message translates to:
  /// **'Plan'**
  String get planLabel;

  /// No description provided for @proLabel.
  ///
  /// In pl, this message translates to:
  /// **'Pro'**
  String get proLabel;

  /// No description provided for @userIdLabel.
  ///
  /// In pl, this message translates to:
  /// **'ID użytkownika'**
  String get userIdLabel;

  /// No description provided for @emailLabel.
  ///
  /// In pl, this message translates to:
  /// **'E-mail'**
  String get emailLabel;

  /// No description provided for @displayNameLabel.
  ///
  /// In pl, this message translates to:
  /// **'Nazwa wyświetlana'**
  String get displayNameLabel;

  /// No description provided for @supabaseSectionTitle.
  ///
  /// In pl, this message translates to:
  /// **'Supabase'**
  String get supabaseSectionTitle;

  /// No description provided for @keysConfiguredLabel.
  ///
  /// In pl, this message translates to:
  /// **'Klucze skonfigurowane'**
  String get keysConfiguredLabel;

  /// No description provided for @supabaseUrlLabel.
  ///
  /// In pl, this message translates to:
  /// **'Supabase URL'**
  String get supabaseUrlLabel;

  /// No description provided for @revenueCatSectionTitle.
  ///
  /// In pl, this message translates to:
  /// **'RevenueCat'**
  String get revenueCatSectionTitle;

  /// No description provided for @supportedPlatformLabel.
  ///
  /// In pl, this message translates to:
  /// **'Wspierana platforma'**
  String get supportedPlatformLabel;

  /// No description provided for @sdkActiveLabel.
  ///
  /// In pl, this message translates to:
  /// **'SDK aktywne'**
  String get sdkActiveLabel;

  /// No description provided for @currentKeySourceLabel.
  ///
  /// In pl, this message translates to:
  /// **'Aktualne źródło klucza'**
  String get currentKeySourceLabel;

  /// No description provided for @missingValueLabel.
  ///
  /// In pl, this message translates to:
  /// **'brak'**
  String get missingValueLabel;

  /// No description provided for @debugForceProTitle.
  ///
  /// In pl, this message translates to:
  /// **'Debug: wymuś status Pro'**
  String get debugForceProTitle;

  /// No description provided for @debugForceProSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Działa tylko bez aktywnego RevenueCat i tylko w debugowym narzędziu.'**
  String get debugForceProSubtitle;

  /// No description provided for @missingSupabaseAgentPrompt.
  ///
  /// In pl, this message translates to:
  /// **'Połącz `Supabase MCP` z moim projektem Supabase i uzupełnij `config/api-keys.json` wartościami `SUPABASE_URL` oraz `SUPABASE_ANON_KEY`.'**
  String get missingSupabaseAgentPrompt;

  /// No description provided for @missingSupabaseTitle.
  ///
  /// In pl, this message translates to:
  /// **'Brakuje kluczy Supabase'**
  String get missingSupabaseTitle;

  /// No description provided for @missingSupabaseBody.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj klucze Supabase do pliku konfiguracyjnego i uruchom aplikację ponownie.'**
  String get missingSupabaseBody;

  /// No description provided for @missingSupabaseFileLabel.
  ///
  /// In pl, this message translates to:
  /// **'Uzupełnij ten plik'**
  String get missingSupabaseFileLabel;

  /// No description provided for @missingSupabaseFilePath.
  ///
  /// In pl, this message translates to:
  /// **'config/api-keys.json'**
  String get missingSupabaseFilePath;

  /// No description provided for @missingSupabaseStep1Title.
  ///
  /// In pl, this message translates to:
  /// **'Krok 1: zainstaluj `Supabase MCP`'**
  String get missingSupabaseStep1Title;

  /// No description provided for @missingSupabaseStep1Body.
  ///
  /// In pl, this message translates to:
  /// **'Najpierw dodaj `Supabase MCP` do swojego agenta AI.'**
  String get missingSupabaseStep1Body;

  /// No description provided for @missingSupabaseStep2Title.
  ///
  /// In pl, this message translates to:
  /// **'Krok 2: wklej ten prompt agentowi'**
  String get missingSupabaseStep2Title;

  /// No description provided for @copyPromptButtonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Kopiuj prompt'**
  String get copyPromptButtonLabel;

  /// No description provided for @promptCopiedSnackbar.
  ///
  /// In pl, this message translates to:
  /// **'Prompt skopiowany'**
  String get promptCopiedSnackbar;

  /// No description provided for @missingSupabaseStep3Title.
  ///
  /// In pl, this message translates to:
  /// **'Krok 3: zamknij i otwórz aplikację ponownie'**
  String get missingSupabaseStep3Title;

  /// No description provided for @missingSupabaseStep3Body.
  ///
  /// In pl, this message translates to:
  /// **'Gdy agent uzupełni plik z kluczami, zamknij aplikację i uruchom ją jeszcze raz.'**
  String get missingSupabaseStep3Body;

  /// No description provided for @sharedUsersAgentPrompt.
  ///
  /// In pl, this message translates to:
  /// **'Uruchom task `docs/tasks/02_SUPABASE_SHARED_USERS_SETUP.md` i doprowadź tabelę `shared_users` do minimalnej zgodności z tym projektem używając `Supabase MCP`.'**
  String get sharedUsersAgentPrompt;

  /// No description provided for @sharedUsersSetupTitle.
  ///
  /// In pl, this message translates to:
  /// **'Brakuje tabeli `shared_users` w Supabase'**
  String get sharedUsersSetupTitle;

  /// No description provided for @sharedUsersSetupBody.
  ///
  /// In pl, this message translates to:
  /// **'Aplikacja nie może wczytać dodatkowych danych użytkowników (takich jak np. imię), bo tabela `shared_users` nie istnieje albo jej struktura nie zgadza się z założeniami minimalnymi.'**
  String get sharedUsersSetupBody;

  /// No description provided for @sharedUsersGuideLabel.
  ///
  /// In pl, this message translates to:
  /// **'Skorzystaj z gotowej instrukcji:'**
  String get sharedUsersGuideLabel;

  /// No description provided for @sharedUsersGuideFile.
  ///
  /// In pl, this message translates to:
  /// **'02_SUPABASE_SHARED_USERS_SETUP.md'**
  String get sharedUsersGuideFile;

  /// No description provided for @sharedUsersAiPromptTitle.
  ///
  /// In pl, this message translates to:
  /// **'Wklej ten prompt agentowi AI'**
  String get sharedUsersAiPromptTitle;

  /// No description provided for @sharedUsersAiHelpBody.
  ///
  /// In pl, this message translates to:
  /// **'Jeżeli Twój agent AI ma dostęp do Supabase MCP, ustawi wszystko wg. przygotowanej instrukcji za Ciebie autmatycznie.'**
  String get sharedUsersAiHelpBody;

  /// No description provided for @deleteAccountSetupAgentPrompt.
  ///
  /// In pl, this message translates to:
  /// **'Uruchom task `docs/tasks/03_SUPABASE_DELETE_ACCOUNT_SETUP.md` i dokończ deployment `delete-account` w Supabase oraz przepnij profil na gotowy flow używając `Supabase MCP`.'**
  String get deleteAccountSetupAgentPrompt;

  /// No description provided for @deleteAccountSetupTitle.
  ///
  /// In pl, this message translates to:
  /// **'Delete account wymaga dodatkowego setupu'**
  String get deleteAccountSetupTitle;

  /// No description provided for @deleteAccountSetupBody.
  ///
  /// In pl, this message translates to:
  /// **'Logika `Delete account` jest już wstępnie przygotowana w template, ale funkcja `delete-account` nie została jeszcze wdrożona w tym projekcie, a profil nadal prowadzi do tego ekranu setupu.'**
  String get deleteAccountSetupBody;

  /// No description provided for @deleteAccountGuideLabel.
  ///
  /// In pl, this message translates to:
  /// **'Skorzystaj z gotowej instrukcji:'**
  String get deleteAccountGuideLabel;

  /// No description provided for @deleteAccountGuideFile.
  ///
  /// In pl, this message translates to:
  /// **'03_SUPABASE_DELETE_ACCOUNT_SETUP.md'**
  String get deleteAccountGuideFile;

  /// No description provided for @deleteAccountAiPromptTitle.
  ///
  /// In pl, this message translates to:
  /// **'Wklej ten prompt agentowi AI'**
  String get deleteAccountAiPromptTitle;

  /// No description provided for @deleteAccountAiHelpBody.
  ///
  /// In pl, this message translates to:
  /// **'Jeżeli Twój agent AI ma dostęp do Supabase MCP, może wdrożyć funkcję `delete-account`, sprawdzić `verify_jwt`, przepiąć profil na gotowy flow i zaktualizować testy.'**
  String get deleteAccountAiHelpBody;
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
      <String>['pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'pl':
      return AppLocalizationsPl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

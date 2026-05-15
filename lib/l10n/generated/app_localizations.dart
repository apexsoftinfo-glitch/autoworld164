import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pl'),
  ];

  /// No description provided for @newsOriginalArticle.
  ///
  /// In pl, this message translates to:
  /// **'Oryginalny artykuł'**
  String get newsOriginalArticle;

  /// No description provided for @newsReadMore.
  ///
  /// In pl, this message translates to:
  /// **'CZYTAJ WIĘCEJ'**
  String get newsReadMore;

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

  /// No description provided for @errorEmailAlreadyInUse.
  ///
  /// In pl, this message translates to:
  /// **'Ten adres e-mail jest już zajęty. Jeśli masz już konto, użyj opcji \'Zaloguj\'.'**
  String get errorEmailAlreadyInUse;

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

  /// No description provided for @errorRateLimitExceeded.
  ///
  /// In pl, this message translates to:
  /// **'Zbyt wiele prób wysłania e-maila. Spróbuj ponownie za chwilę.'**
  String get errorRateLimitExceeded;

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

  /// No description provided for @profileLanguageSectionTitle.
  ///
  /// In pl, this message translates to:
  /// **'Język aplikacji'**
  String get profileLanguageSectionTitle;

  /// No description provided for @profileLanguageSectionDescription.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz, czy aplikacja ma używać języka urządzenia, polskiego czy angielskiego.'**
  String get profileLanguageSectionDescription;

  /// No description provided for @firstNameFieldLabel.
  ///
  /// In pl, this message translates to:
  /// **'Imię'**
  String get firstNameFieldLabel;

  /// No description provided for @languageOptionSystem.
  ///
  /// In pl, this message translates to:
  /// **'Automatyczny'**
  String get languageOptionSystem;

  /// No description provided for @languageOptionSystemDescription.
  ///
  /// In pl, this message translates to:
  /// **'Używa języka urządzenia. Dla nieobsługiwanych języków aplikacja wraca do English.'**
  String get languageOptionSystemDescription;

  /// No description provided for @languageOptionPolish.
  ///
  /// In pl, this message translates to:
  /// **'Polski'**
  String get languageOptionPolish;

  /// No description provided for @languageOptionEnglish.
  ///
  /// In pl, this message translates to:
  /// **'English'**
  String get languageOptionEnglish;

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

  /// No description provided for @deleteAccountDialogTitle.
  ///
  /// In pl, this message translates to:
  /// **'Usunąć konto?'**
  String get deleteAccountDialogTitle;

  /// No description provided for @deleteAccountDialogBody.
  ///
  /// In pl, this message translates to:
  /// **'Czy na pewno chcesz usunąć swoje konto? Ta operacja jest nieodwracalna. Wszystkie Twoje dane oraz dostęp Pro zostaną utracone.'**
  String get deleteAccountDialogBody;

  /// No description provided for @deleteAccountCancelButtonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Anuluj'**
  String get deleteAccountCancelButtonLabel;

  /// No description provided for @deleteAccountConfirmButtonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Usuń'**
  String get deleteAccountConfirmButtonLabel;

  /// No description provided for @carBrandLabel.
  ///
  /// In pl, this message translates to:
  /// **'Marka'**
  String get carBrandLabel;

  /// No description provided for @carModelNameLabel.
  ///
  /// In pl, this message translates to:
  /// **'Nazwa modelu'**
  String get carModelNameLabel;

  /// No description provided for @carSeriesLabel.
  ///
  /// In pl, this message translates to:
  /// **'Seria'**
  String get carSeriesLabel;

  /// No description provided for @carPurchasePriceLabel.
  ///
  /// In pl, this message translates to:
  /// **'Cena zakupu'**
  String get carPurchasePriceLabel;

  /// No description provided for @carEstimatedValueLabel.
  ///
  /// In pl, this message translates to:
  /// **'Szacowana wartość'**
  String get carEstimatedValueLabel;

  /// No description provided for @carPhotoLabel.
  ///
  /// In pl, this message translates to:
  /// **'Zdjęcie'**
  String get carPhotoLabel;

  /// No description provided for @garageTitle.
  ///
  /// In pl, this message translates to:
  /// **'Mój Garaż'**
  String get garageTitle;

  /// No description provided for @garageEmptyStateTitle.
  ///
  /// In pl, this message translates to:
  /// **'Twój garaż jest pusty'**
  String get garageEmptyStateTitle;

  /// No description provided for @garageEmptyStateSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj swój pierwszy model 1/64, aby zacząć kolekcję.'**
  String get garageEmptyStateSubtitle;

  /// No description provided for @garageAddFirstCarButton.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj pierwszy model'**
  String get garageAddFirstCarButton;

  /// No description provided for @garageTotalValue.
  ///
  /// In pl, this message translates to:
  /// **'Wartość kolekcji'**
  String get garageTotalValue;

  /// No description provided for @garageTotalItems.
  ///
  /// In pl, this message translates to:
  /// **'Sztuk w garażu'**
  String get garageTotalItems;

  /// No description provided for @garageCarDetails.
  ///
  /// In pl, this message translates to:
  /// **'Szczegóły'**
  String get garageCarDetails;

  /// No description provided for @garageDeleteCarConfirm.
  ///
  /// In pl, this message translates to:
  /// **'Czy na pewno chcesz usunąć ten model?'**
  String get garageDeleteCarConfirm;

  /// No description provided for @garageSuccessDeleted.
  ///
  /// In pl, this message translates to:
  /// **'Model został usunięty'**
  String get garageSuccessDeleted;

  /// No description provided for @carFormAddTitle.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj model'**
  String get carFormAddTitle;

  /// No description provided for @carFormEditTitle.
  ///
  /// In pl, this message translates to:
  /// **'Edytuj model'**
  String get carFormEditTitle;

  /// No description provided for @carFormSaveButton.
  ///
  /// In pl, this message translates to:
  /// **'Zapisz'**
  String get carFormSaveButton;

  /// No description provided for @carFormAddPhotoLabel.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj zdjęcie'**
  String get carFormAddPhotoLabel;

  /// No description provided for @carFormChangePhotoLabel.
  ///
  /// In pl, this message translates to:
  /// **'Zmień zdjęcie'**
  String get carFormChangePhotoLabel;

  /// No description provided for @carFormSuccessAdded.
  ///
  /// In pl, this message translates to:
  /// **'Pomyślnie dodano model'**
  String get carFormSuccessAdded;

  /// No description provided for @carFormSuccessEdited.
  ///
  /// In pl, this message translates to:
  /// **'Pomyślnie edytowano model'**
  String get carFormSuccessEdited;

  /// No description provided for @carProducerLabel.
  ///
  /// In pl, this message translates to:
  /// **'Producent (Logo)'**
  String get carProducerLabel;

  /// No description provided for @carPurchaseDateLabel.
  ///
  /// In pl, this message translates to:
  /// **'Data zakupu'**
  String get carPurchaseDateLabel;

  /// No description provided for @carGalleryLabel.
  ///
  /// In pl, this message translates to:
  /// **'Galeria zdjęć'**
  String get carGalleryLabel;

  /// No description provided for @carSearchPhotosLabel.
  ///
  /// In pl, this message translates to:
  /// **'Zdjęcia z internetu'**
  String get carSearchPhotosLabel;

  /// No description provided for @carAiEstimateLabel.
  ///
  /// In pl, this message translates to:
  /// **'Wycena AI'**
  String get carAiEstimateLabel;

  /// No description provided for @carFormAddPhotoPlaceholder.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj do 5 zdjęć'**
  String get carFormAddPhotoPlaceholder;

  /// No description provided for @cameraButtonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Aparat'**
  String get cameraButtonLabel;

  /// No description provided for @galleryButtonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Galeria'**
  String get galleryButtonLabel;

  /// No description provided for @newsTitle.
  ///
  /// In pl, this message translates to:
  /// **'Nowości'**
  String get newsTitle;

  /// No description provided for @errorLoadingNews.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się wczytać nowości ze świata 1/64.'**
  String get errorLoadingNews;

  /// No description provided for @settingsTitle.
  ///
  /// In pl, this message translates to:
  /// **'Ustawienia'**
  String get settingsTitle;

  /// No description provided for @settingsSectionProfile.
  ///
  /// In pl, this message translates to:
  /// **'Profil'**
  String get settingsSectionProfile;

  /// No description provided for @settingsSectionCurrency.
  ///
  /// In pl, this message translates to:
  /// **'Waluta'**
  String get settingsSectionCurrency;

  /// No description provided for @settingsSectionLanguage.
  ///
  /// In pl, this message translates to:
  /// **'Język'**
  String get settingsSectionLanguage;

  /// No description provided for @settingsSectionBackup.
  ///
  /// In pl, this message translates to:
  /// **'Backup garażu'**
  String get settingsSectionBackup;

  /// No description provided for @settingsUsernameLabel.
  ///
  /// In pl, this message translates to:
  /// **'Nazwa użytkownika'**
  String get settingsUsernameLabel;

  /// No description provided for @settingsGarageNameLabel.
  ///
  /// In pl, this message translates to:
  /// **'Nazwa garażu'**
  String get settingsGarageNameLabel;

  /// No description provided for @settingsProfilePhotoLabel.
  ///
  /// In pl, this message translates to:
  /// **'Zdjęcie profilowe'**
  String get settingsProfilePhotoLabel;

  /// No description provided for @settingsChangeLoginLabel.
  ///
  /// In pl, this message translates to:
  /// **'Zmień login'**
  String get settingsChangeLoginLabel;

  /// No description provided for @settingsChangePasswordLabel.
  ///
  /// In pl, this message translates to:
  /// **'Zmień hasło'**
  String get settingsChangePasswordLabel;

  /// No description provided for @settingsBackupCreate.
  ///
  /// In pl, this message translates to:
  /// **'Utwórz kopię zapasową'**
  String get settingsBackupCreate;

  /// No description provided for @settingsBackupRestore.
  ///
  /// In pl, this message translates to:
  /// **'Wgraj kopię zapasową'**
  String get settingsBackupRestore;

  /// No description provided for @settingsBackupDescription.
  ///
  /// In pl, this message translates to:
  /// **'Kopia zawiera wszystkie dane oraz zdjęcia modeli. Zdjęcia są przechowywane lokalnie na urządzeniu.'**
  String get settingsBackupDescription;

  /// No description provided for @settingsCurrencyPLN.
  ///
  /// In pl, this message translates to:
  /// **'PLN (Złoty)'**
  String get settingsCurrencyPLN;

  /// No description provided for @settingsCurrencyUSD.
  ///
  /// In pl, this message translates to:
  /// **'USD (Dolar)'**
  String get settingsCurrencyUSD;

  /// No description provided for @settingsCurrencyEUR.
  ///
  /// In pl, this message translates to:
  /// **'EUR (Euro)'**
  String get settingsCurrencyEUR;

  /// No description provided for @error_loading_settings.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się załadować ustawień.'**
  String get error_loading_settings;

  /// No description provided for @error_updating_garage_name.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się zaktualizować nazwy garażu.'**
  String get error_updating_garage_name;

  /// No description provided for @error_updating_profile.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się zaktualizować profilu.'**
  String get error_updating_profile;

  /// No description provided for @error_updating_currency.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się zaktualizować waluty.'**
  String get error_updating_currency;

  /// No description provided for @error_updating_language.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się zaktualizować języka.'**
  String get error_updating_language;

  /// No description provided for @saveSuccess.
  ///
  /// In pl, this message translates to:
  /// **'Zmiany zostały zapisane'**
  String get saveSuccess;

  /// No description provided for @error_exporting_backup.
  ///
  /// In pl, this message translates to:
  /// **'Błąd podczas tworzenia kopii zapasowej.'**
  String get error_exporting_backup;

  /// No description provided for @error_importing_backup.
  ///
  /// In pl, this message translates to:
  /// **'Błąd podczas wczytywania kopii zapasowej.'**
  String get error_importing_backup;

  /// No description provided for @backup_restored_successfully.
  ///
  /// In pl, this message translates to:
  /// **'Kopia zapasowa została przywrócona.'**
  String get backup_restored_successfully;

  /// No description provided for @backup_restore_confirm_title.
  ///
  /// In pl, this message translates to:
  /// **'Przywrócić kopię zapasową?'**
  String get backup_restore_confirm_title;

  /// No description provided for @backup_restore_confirm_body.
  ///
  /// In pl, this message translates to:
  /// **'To nadpisze obecne dane w tym garażu. Czy chcesz kontynuować?'**
  String get backup_restore_confirm_body;

  /// No description provided for @error_unauthenticated.
  ///
  /// In pl, this message translates to:
  /// **'Musisz być zalogowany, aby wykonać tę operację.'**
  String get error_unauthenticated;

  /// No description provided for @error_invalid_backup_file.
  ///
  /// In pl, this message translates to:
  /// **'Nieprawidłowy plik kopii zapasowej.'**
  String get error_invalid_backup_file;

  /// No description provided for @settingsEmailLabel.
  ///
  /// In pl, this message translates to:
  /// **'ADRES E-MAIL'**
  String get settingsEmailLabel;

  /// No description provided for @settingsPasswordLabel.
  ///
  /// In pl, this message translates to:
  /// **'HASŁO'**
  String get settingsPasswordLabel;

  /// No description provided for @settingsRegisterButton.
  ///
  /// In pl, this message translates to:
  /// **'ZAREJESTRUJ KONTO'**
  String get settingsRegisterButton;

  /// No description provided for @account_upgraded_successfully.
  ///
  /// In pl, this message translates to:
  /// **'Konto zostało ulepszone! Sprawdź e-mail, aby potwierdzić rejestrację.'**
  String get account_upgraded_successfully;

  /// No description provided for @error_upgrading_account.
  ///
  /// In pl, this message translates to:
  /// **'Błąd podczas ulepszania konta.'**
  String get error_upgrading_account;

  /// No description provided for @settingsSectionAppearance.
  ///
  /// In pl, this message translates to:
  /// **'Wygląd garażu'**
  String get settingsSectionAppearance;

  /// No description provided for @settingsGarageBackgroundLabel.
  ///
  /// In pl, this message translates to:
  /// **'Tło garażu'**
  String get settingsGarageBackgroundLabel;

  /// No description provided for @error_updating_background.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się zaktualizować tła garażu.'**
  String get error_updating_background;

  /// No description provided for @settingsUploadingPhoto.
  ///
  /// In pl, this message translates to:
  /// **'Trwa zmiana zdjęcia...'**
  String get settingsUploadingPhoto;

  /// No description provided for @settingsPhotoOptimisticNotice.
  ///
  /// In pl, this message translates to:
  /// **'Zmiana pojawi się za chwilę w całej aplikacji.'**
  String get settingsPhotoOptimisticNotice;

  /// No description provided for @settingsAddCustomBackground.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj tło'**
  String get settingsAddCustomBackground;

  /// No description provided for @homeMyGarage.
  ///
  /// In pl, this message translates to:
  /// **'MÓJ GARAŻ'**
  String get homeMyGarage;

  /// No description provided for @homeNews.
  ///
  /// In pl, this message translates to:
  /// **'NOWOŚCI'**
  String get homeNews;

  /// No description provided for @homeHotHunt.
  ///
  /// In pl, this message translates to:
  /// **'WYMIANA/SPRZEDAŻ'**
  String get homeHotHunt;

  /// No description provided for @homeAddCar.
  ///
  /// In pl, this message translates to:
  /// **'DODAJ MODEL'**
  String get homeAddCar;

  /// No description provided for @homeLoadingGarage.
  ///
  /// In pl, this message translates to:
  /// **'Pobieranie danych z garażu...'**
  String get homeLoadingGarage;

  /// No description provided for @homeTotalValueTitle.
  ///
  /// In pl, this message translates to:
  /// **'WARTOŚĆ KOLEKCJI'**
  String get homeTotalValueTitle;

  /// No description provided for @homeTotalItemsTitle.
  ///
  /// In pl, this message translates to:
  /// **'SZTUK W GARAŻU'**
  String get homeTotalItemsTitle;

  /// No description provided for @homeLatestArrivals.
  ///
  /// In pl, this message translates to:
  /// **'NOWOŚCI W GARAŻU'**
  String get homeLatestArrivals;

  /// No description provided for @homeSeeAll.
  ///
  /// In pl, this message translates to:
  /// **'ZOBACZ WSZYSTKO'**
  String get homeSeeAll;

  /// No description provided for @homeNoModelsTitle.
  ///
  /// In pl, this message translates to:
  /// **'BRAK MODELI'**
  String get homeNoModelsTitle;

  /// No description provided for @homeNoModelsSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Twój garaż czeka na pierwszy model'**
  String get homeNoModelsSubtitle;

  /// No description provided for @carDetailsBrand.
  ///
  /// In pl, this message translates to:
  /// **'MARKA'**
  String get carDetailsBrand;

  /// No description provided for @carDetailsSeries.
  ///
  /// In pl, this message translates to:
  /// **'SERIA'**
  String get carDetailsSeries;

  /// No description provided for @carDetailsCondition.
  ///
  /// In pl, this message translates to:
  /// **'STAN'**
  String get carDetailsCondition;

  /// No description provided for @carDetailsPrice.
  ///
  /// In pl, this message translates to:
  /// **'CENA'**
  String get carDetailsPrice;

  /// No description provided for @carDetailsValue.
  ///
  /// In pl, this message translates to:
  /// **'WARTOŚĆ'**
  String get carDetailsValue;

  /// No description provided for @carDetailsDate.
  ///
  /// In pl, this message translates to:
  /// **'DATA'**
  String get carDetailsDate;

  /// No description provided for @carDetailsOtherPhotos.
  ///
  /// In pl, this message translates to:
  /// **'INNE ZDJĘCIA'**
  String get carDetailsOtherPhotos;

  /// No description provided for @carDetailsDeleteConfirmTitle.
  ///
  /// In pl, this message translates to:
  /// **'USUWANIE MODELU'**
  String get carDetailsDeleteConfirmTitle;

  /// No description provided for @carDetailsDeleteConfirmBody.
  ///
  /// In pl, this message translates to:
  /// **'Czy na pewno chcesz bezpowrotnie usunąć ten model z garażu?'**
  String get carDetailsDeleteConfirmBody;

  /// No description provided for @carFormBrandPlaceholder.
  ///
  /// In pl, this message translates to:
  /// **'np. Hot Wheels'**
  String get carFormBrandPlaceholder;

  /// No description provided for @carFormModelPlaceholder.
  ///
  /// In pl, this message translates to:
  /// **'np. Porsche 911 GT3'**
  String get carFormModelPlaceholder;

  /// No description provided for @carFormProducerOther.
  ///
  /// In pl, this message translates to:
  /// **'INNY'**
  String get carFormProducerOther;

  /// No description provided for @carFormProducerDialogTitle.
  ///
  /// In pl, this message translates to:
  /// **'PODAJ PRODUCENTA'**
  String get carFormProducerDialogTitle;

  /// No description provided for @carFormProducerPlaceholder.
  ///
  /// In pl, this message translates to:
  /// **'np. Inno64'**
  String get carFormProducerPlaceholder;

  /// No description provided for @carFormConditionLabel.
  ///
  /// In pl, this message translates to:
  /// **'STAN'**
  String get carFormConditionLabel;

  /// No description provided for @carFormCameraLabel.
  ///
  /// In pl, this message translates to:
  /// **'APARAT'**
  String get carFormCameraLabel;

  /// No description provided for @carFormGalleryLabel.
  ///
  /// In pl, this message translates to:
  /// **'GALERIA'**
  String get carFormGalleryLabel;

  /// No description provided for @carFormInternetLabel.
  ///
  /// In pl, this message translates to:
  /// **'INTERNET'**
  String get carFormInternetLabel;

  /// No description provided for @huntingTitle.
  ///
  /// In pl, this message translates to:
  /// **'WYMIANA/SPRZEDAŻ'**
  String get huntingTitle;

  /// No description provided for @marketAddManual.
  ///
  /// In pl, this message translates to:
  /// **'DODAJ RĘCZNIE'**
  String get marketAddManual;

  /// No description provided for @marketAddFromGarage.
  ///
  /// In pl, this message translates to:
  /// **'WYBIERZ Z GARAŻU'**
  String get marketAddFromGarage;

  /// No description provided for @marketSelectModelTitle.
  ///
  /// In pl, this message translates to:
  /// **'WYBIERZ MODEL Z GARAŻU'**
  String get marketSelectModelTitle;

  /// No description provided for @huntingSearchHint.
  ///
  /// In pl, this message translates to:
  /// **'Wpisz model (np. Supra RLC)'**
  String get huntingSearchHint;

  /// No description provided for @huntingEmptyTitle.
  ///
  /// In pl, this message translates to:
  /// **'ZNAJDŹ SWÓJ WYMARZONY MODEL'**
  String get huntingEmptyTitle;

  /// No description provided for @huntingEmptySubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Przeszukaj najpopularniejsze platformy w poszukiwaniu okazji i promocji.'**
  String get huntingEmptySubtitle;

  /// No description provided for @huntingSearchButton.
  ///
  /// In pl, this message translates to:
  /// **'SZUKAJ'**
  String get huntingSearchButton;

  /// No description provided for @huntingPromoButton.
  ///
  /// In pl, this message translates to:
  /// **'PROMOCJE'**
  String get huntingPromoButton;

  /// No description provided for @huntingError.
  ///
  /// In pl, this message translates to:
  /// **'Wystąpił błąd podczas wyszukiwania'**
  String get huntingError;

  /// No description provided for @huntingLaunchError.
  ///
  /// In pl, this message translates to:
  /// **'Nie można otworzyć linku'**
  String get huntingLaunchError;

  /// No description provided for @newsEmptyState.
  ///
  /// In pl, this message translates to:
  /// **'Brak nowych wiadomości'**
  String get newsEmptyState;

  /// No description provided for @newsLearnMore.
  ///
  /// In pl, this message translates to:
  /// **'DOWIEDZ SIĘ WIĘCEJ'**
  String get newsLearnMore;

  /// No description provided for @newsRefreshTooltip.
  ///
  /// In pl, this message translates to:
  /// **'Odśwież nowości'**
  String get newsRefreshTooltip;

  /// No description provided for @settingsNoUser.
  ///
  /// In pl, this message translates to:
  /// **'Brak użytkownika'**
  String get settingsNoUser;

  /// No description provided for @homePiecesCount.
  ///
  /// In pl, this message translates to:
  /// **'sztuk.'**
  String get homePiecesCount;

  /// No description provided for @homeTotalValue.
  ///
  /// In pl, this message translates to:
  /// **'Wartość.'**
  String get homeTotalValue;

  /// No description provided for @carDetailsPurchasePrice.
  ///
  /// In pl, this message translates to:
  /// **'Cena zakupu'**
  String get carDetailsPurchasePrice;

  /// No description provided for @carDetailsEstimatedValue.
  ///
  /// In pl, this message translates to:
  /// **'Szac. wartość'**
  String get carDetailsEstimatedValue;

  /// No description provided for @carDetailsEditData.
  ///
  /// In pl, this message translates to:
  /// **'Redaguj dane'**
  String get carDetailsEditData;

  /// No description provided for @carGalleryCameraLabel.
  ///
  /// In pl, this message translates to:
  /// **'APARAT'**
  String get carGalleryCameraLabel;

  /// No description provided for @carGalleryGalleryLabel.
  ///
  /// In pl, this message translates to:
  /// **'GALERIA'**
  String get carGalleryGalleryLabel;

  /// No description provided for @carGalleryInternetLabel.
  ///
  /// In pl, this message translates to:
  /// **'INTERNET'**
  String get carGalleryInternetLabel;

  /// No description provided for @homeGarageTitle.
  ///
  /// In pl, this message translates to:
  /// **'GARAŻ'**
  String get homeGarageTitle;

  /// No description provided for @homeGarageTitleWithName.
  ///
  /// In pl, this message translates to:
  /// **'GARAŻ {name}'**
  String homeGarageTitleWithName(Object name);

  /// No description provided for @carFormMaxPhotos.
  ///
  /// In pl, this message translates to:
  /// **'Maksymalnie 5 zdjęć'**
  String get carFormMaxPhotos;

  /// No description provided for @carFormImageError.
  ///
  /// In pl, this message translates to:
  /// **'Błąd podczas otwierania galerii/aparatu'**
  String get carFormImageError;

  /// No description provided for @carFormEstimatingTitle.
  ///
  /// In pl, this message translates to:
  /// **'SZUKANIE SZACUNKOWEJ WARTOŚCI'**
  String get carFormEstimatingTitle;

  /// No description provided for @carFormEstimatingBody.
  ///
  /// In pl, this message translates to:
  /// **'Przeszukujemy bazy danych, aby podać Ci jak najdokładniejszą cenę rynkową...'**
  String get carFormEstimatingBody;

  /// No description provided for @carFormCancelEstimation.
  ///
  /// In pl, this message translates to:
  /// **'ZREZYGNUJ I WPISZ RĘCZNIE'**
  String get carFormCancelEstimation;

  /// No description provided for @garageSearchHint.
  ///
  /// In pl, this message translates to:
  /// **'Szukaj modelu...'**
  String get garageSearchHint;

  /// No description provided for @garageAddNewCarButton.
  ///
  /// In pl, this message translates to:
  /// **'DODAJ NOWY MODEL'**
  String get garageAddNewCarButton;

  /// No description provided for @garageProducersTitle.
  ///
  /// In pl, this message translates to:
  /// **'PRODUCENCI'**
  String get garageProducersTitle;

  /// No description provided for @garageRemoveFilter.
  ///
  /// In pl, this message translates to:
  /// **'USUŃ FILTR'**
  String get garageRemoveFilter;

  /// No description provided for @carProducerPlaceholder.
  ///
  /// In pl, this message translates to:
  /// **'PRODUCENT'**
  String get carProducerPlaceholder;

  /// No description provided for @cancelButtonLabel.
  ///
  /// In pl, this message translates to:
  /// **'ANULUJ'**
  String get cancelButtonLabel;

  /// No description provided for @carFormSeriesDialogTitle.
  ///
  /// In pl, this message translates to:
  /// **'PODAJ NAZWĘ SERII'**
  String get carFormSeriesDialogTitle;

  /// No description provided for @carFormSeriesPlaceholder.
  ///
  /// In pl, this message translates to:
  /// **'np. Team Transport'**
  String get carFormSeriesPlaceholder;

  /// No description provided for @errorCannotOpenLink.
  ///
  /// In pl, this message translates to:
  /// **'Nie można otworzyć linku'**
  String get errorCannotOpenLink;

  /// No description provided for @carConditionNew.
  ///
  /// In pl, this message translates to:
  /// **'Nowy'**
  String get carConditionNew;

  /// No description provided for @carConditionMint.
  ///
  /// In pl, this message translates to:
  /// **'Idealny'**
  String get carConditionMint;

  /// No description provided for @carConditionGood.
  ///
  /// In pl, this message translates to:
  /// **'Dobry'**
  String get carConditionGood;

  /// No description provided for @carConditionFair.
  ///
  /// In pl, this message translates to:
  /// **'Lekko uszkodzony'**
  String get carConditionFair;

  /// No description provided for @carConditionPoor.
  ///
  /// In pl, this message translates to:
  /// **'Uszkodzony'**
  String get carConditionPoor;

  /// No description provided for @carConditionLoose.
  ///
  /// In pl, this message translates to:
  /// **'Luzak (bez opakowania)'**
  String get carConditionLoose;

  /// No description provided for @carConditionOther.
  ///
  /// In pl, this message translates to:
  /// **'Inne'**
  String get carConditionOther;

  /// No description provided for @commonOther.
  ///
  /// In pl, this message translates to:
  /// **'Inne...'**
  String get commonOther;

  /// No description provided for @carFormSearchRequiredTitle.
  ///
  /// In pl, this message translates to:
  /// **'Wymagane dane'**
  String get carFormSearchRequiredTitle;

  /// No description provided for @carFormSearchRequiredBody.
  ///
  /// In pl, this message translates to:
  /// **'Aby szukać zdjęć w internecie, musisz najpierw wpisać: Markę/Model, Producenta oraz Serię.'**
  String get carFormSearchRequiredBody;
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
      <String>['en', 'pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
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

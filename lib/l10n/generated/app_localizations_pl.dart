// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get localizationBootstrap =>
      'Lokalizacja aplikacji jest skonfigurowana.';

  @override
  String get errorInvalidCredentials => 'Nieprawidłowy email lub hasło.';

  @override
  String get errorAnonymousAuthDisabled =>
      'Logowanie jako gość jest obecnie wyłączone.';

  @override
  String get errorEmail => 'Sprawdź adres email i spróbuj ponownie.';

  @override
  String get errorPassword => 'Sprawdź hasło i spróbuj ponownie.';

  @override
  String get errorNetwork => 'Problem z połączeniem. Spróbuj ponownie.';

  @override
  String get errorDeleteAccountSetupRequired =>
      'Delete account wymaga jeszcze dokończenia setupu w Supabase.';

  @override
  String get errorDeleteAccountFailed =>
      'Nie udało się usunąć konta. Spróbuj ponownie.';

  @override
  String get errorSharedUsersSetupRequired =>
      'Brakuje tabeli shared_users albo jej schema nie zgadza się z template.';

  @override
  String get errorDeleteAccountNotImplemented =>
      'Usuwanie konta nie jest jeszcze gotowe.';

  @override
  String get errorUnknown => 'Wystąpił nieoczekiwany błąd.';

  @override
  String errorWithKey(Object errorKey) {
    return 'Wystąpił błąd: $errorKey';
  }

  @override
  String get guestDisplayName => 'Gość';

  @override
  String get registeredUserDisplayName => 'Użytkownik';

  @override
  String get loadingLabel => 'Ładowanie...';

  @override
  String get sessionErrorTitle => 'Błąd sesji';

  @override
  String get accountTypeGuest => 'gość';

  @override
  String get accountTypeRegistered => 'zalogowany';

  @override
  String get commonYes => 'tak';

  @override
  String get commonNo => 'nie';

  @override
  String get userTierGuest => 'gość';

  @override
  String get userTierRegistered => 'konto';

  @override
  String get userTierPro => 'Pro';

  @override
  String get homeTitle => 'Start';

  @override
  String get currentSessionTitle => 'Aktualna sesja';

  @override
  String sessionUserId(Object value) {
    return 'ID użytkownika: $value';
  }

  @override
  String sessionAccountType(Object value) {
    return 'Typ konta: $value';
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
    return 'E-mail: $value';
  }

  @override
  String sessionDisplayNameValue(Object value) {
    return 'Nazwa wyświetlana: $value';
  }

  @override
  String sessionFirstName(Object value) {
    return 'Imię: $value';
  }

  @override
  String get developerToolsTitle => 'Narzędzia deweloperskie';

  @override
  String get retryButtonLabel => 'Spróbuj ponownie';

  @override
  String get welcomeTitle => 'Witaj';

  @override
  String get welcomeBody =>
      'Kontynuuj jako gość albo zaloguj się na istniejące konto.';

  @override
  String get continueAsGuestButtonLabel => 'Kontynuuj jako gość';

  @override
  String get loginButtonLabel => 'Zaloguj się';

  @override
  String get loginScreenTitle => 'Logowanie';

  @override
  String get loginExistingAccountTitle => 'Zaloguj się na istniejące konto';

  @override
  String get loginExistingAccountBody =>
      'Użyj adresu e-mail i hasła, aby przełączyć się na istniejące konto.';

  @override
  String get emailFieldLabel => 'E-mail';

  @override
  String get passwordFieldLabel => 'Hasło';

  @override
  String get switchAccountWarningTitle => 'Przełączasz konto';

  @override
  String get switchAccountWarningBody =>
      'Logowanie w tym miejscu przełączy Cię z obecnego konta gościa na inne konto. Dane gościa i Pro nie łączą się automatycznie.';

  @override
  String get registerScreenTitle => 'Rejestracja';

  @override
  String get secureGuestAccountTitle => 'Zabezpiecz to konto gościa';

  @override
  String get secureGuestAccountBody =>
      'To zachowa Twoje obecne dane i połączy to konto gościa z adresem e-mail oraz hasłem.';

  @override
  String get registerButtonLabel => 'Zarejestruj się';

  @override
  String get profileSavedSnackbar => 'Profil zapisany';

  @override
  String get proEnabledSnackbar => 'Pro aktywowane';

  @override
  String get profileTitle => 'Profil';

  @override
  String get firstNameFieldLabel => 'Imię';

  @override
  String get saveFirstNameButtonLabel => 'Zapisz imię';

  @override
  String get accountSecuredSnackbar => 'Konto zabezpieczone';

  @override
  String get logoutButtonLabel => 'Wyloguj się';

  @override
  String get buyProButtonLabel => 'Kup Pro';

  @override
  String get deleteAccountButtonLabel => 'Usuń konto';

  @override
  String get discardChangesTitle => 'Odrzucić zmiany?';

  @override
  String get discardChangesBody =>
      'Masz niezapisane zmiany. Jeśli wyjdziesz teraz, zostaną utracone.';

  @override
  String get stayButtonLabel => 'Zostań';

  @override
  String get discardButtonLabel => 'Odrzuć';

  @override
  String get closeButtonLabel => 'Zamknij';

  @override
  String get protectProBannerTitle => 'Zabezpiecz dostęp do Pro';

  @override
  String get protectProBannerBody =>
      'To konto gościa ma już Pro. Zarejestruj to konto, aby nie stracić dostępu w przyszłości.';

  @override
  String get developerDiagnosticsTitle => 'Diagnostyka tylko dla debug';

  @override
  String get developerDiagnosticsBody =>
      'Użyj tego ekranu, aby sprawdzić lokalną konfigurację aplikacji i status integracji.';

  @override
  String get revenueCatDisconnectedTitle => 'RevenueCat nie jest podłączony';

  @override
  String get revenueCatDisconnectedBody =>
      'Dodaj klucze RevenueCat do config/api-keys.json, gdy będziesz gotowy testować subskrypcje.';

  @override
  String get sessionSectionTitle => 'Sesja';

  @override
  String get loggedInLabel => 'Zalogowany';

  @override
  String get anonymousLabel => 'Anonimowy';

  @override
  String get planLabel => 'Plan';

  @override
  String get proLabel => 'Pro';

  @override
  String get userIdLabel => 'ID użytkownika';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get displayNameLabel => 'Nazwa wyświetlana';

  @override
  String get supabaseSectionTitle => 'Supabase';

  @override
  String get keysConfiguredLabel => 'Klucze skonfigurowane';

  @override
  String get supabaseUrlLabel => 'Supabase URL';

  @override
  String get revenueCatSectionTitle => 'RevenueCat';

  @override
  String get supportedPlatformLabel => 'Wspierana platforma';

  @override
  String get sdkActiveLabel => 'SDK aktywne';

  @override
  String get currentKeySourceLabel => 'Aktualne źródło klucza';

  @override
  String get missingValueLabel => 'brak';

  @override
  String get debugForceProTitle => 'Debug: wymuś status Pro';

  @override
  String get debugForceProSubtitle =>
      'Działa tylko bez aktywnego RevenueCat i tylko w debugowym narzędziu.';

  @override
  String get missingSupabaseAgentPrompt =>
      'Połącz `Supabase MCP` z moim projektem Supabase i uzupełnij `config/api-keys.json` wartościami `SUPABASE_URL` oraz `SUPABASE_ANON_KEY`.';

  @override
  String get missingSupabaseTitle => 'Brakuje kluczy Supabase';

  @override
  String get missingSupabaseBody =>
      'Dodaj klucze Supabase do pliku konfiguracyjnego i uruchom aplikację ponownie.';

  @override
  String get missingSupabaseFileLabel => 'Uzupełnij ten plik';

  @override
  String get missingSupabaseFilePath => 'config/api-keys.json';

  @override
  String get missingSupabaseStep1Title => 'Krok 1: zainstaluj `Supabase MCP`';

  @override
  String get missingSupabaseStep1Body =>
      'Najpierw dodaj `Supabase MCP` do swojego agenta AI.';

  @override
  String get missingSupabaseStep2Title => 'Krok 2: wklej ten prompt agentowi';

  @override
  String get copyPromptButtonLabel => 'Kopiuj prompt';

  @override
  String get promptCopiedSnackbar => 'Prompt skopiowany';

  @override
  String get missingSupabaseStep3Title =>
      'Krok 3: zamknij i otwórz aplikację ponownie';

  @override
  String get missingSupabaseStep3Body =>
      'Gdy agent uzupełni plik z kluczami, zamknij aplikację i uruchom ją jeszcze raz.';

  @override
  String get sharedUsersAgentPrompt =>
      'Uruchom task `docs/tasks/02_SUPABASE_SHARED_USERS_SETUP.md` i doprowadź tabelę `shared_users` do minimalnej zgodności z tym projektem używając `Supabase MCP`.';

  @override
  String get sharedUsersSetupTitle =>
      'Brakuje tabeli `shared_users` w Supabase';

  @override
  String get sharedUsersSetupBody =>
      'Aplikacja nie może wczytać dodatkowych danych użytkowników (takich jak np. imię), bo tabela `shared_users` nie istnieje albo jej struktura nie zgadza się z założeniami minimalnymi.';

  @override
  String get sharedUsersGuideLabel => 'Skorzystaj z gotowej instrukcji:';

  @override
  String get sharedUsersGuideFile => '02_SUPABASE_SHARED_USERS_SETUP.md';

  @override
  String get sharedUsersAiPromptTitle => 'Wklej ten prompt agentowi AI';

  @override
  String get sharedUsersAiHelpBody =>
      'Jeżeli Twój agent AI ma dostęp do Supabase MCP, ustawi wszystko wg. przygotowanej instrukcji za Ciebie autmatycznie.';

  @override
  String get deleteAccountSetupAgentPrompt =>
      'Uruchom task `docs/tasks/03_SUPABASE_DELETE_ACCOUNT_SETUP.md` i dokończ deployment `delete-account` w Supabase oraz przepnij profil na gotowy flow używając `Supabase MCP`.';

  @override
  String get deleteAccountSetupTitle =>
      'Delete account wymaga dodatkowego setupu';

  @override
  String get deleteAccountSetupBody =>
      'Logika `Delete account` jest już wstępnie przygotowana w template, ale funkcja `delete-account` nie została jeszcze wdrożona w tym projekcie, a profil nadal prowadzi do tego ekranu setupu.';

  @override
  String get deleteAccountGuideLabel => 'Skorzystaj z gotowej instrukcji:';

  @override
  String get deleteAccountGuideFile => '03_SUPABASE_DELETE_ACCOUNT_SETUP.md';

  @override
  String get deleteAccountAiPromptTitle => 'Wklej ten prompt agentowi AI';

  @override
  String get deleteAccountAiHelpBody =>
      'Jeżeli Twój agent AI ma dostęp do Supabase MCP, może wdrożyć funkcję `delete-account`, sprawdzić `verify_jwt`, przepiąć profil na gotowy flow i zaktualizować testy.';
}

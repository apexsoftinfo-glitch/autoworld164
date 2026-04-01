# Intro

Twoim zadaniem jako agenta AI jest zrealizowanie poniższych poleceń.

CEL: Wykonanie konfiguracji `Supabase delete account` dla tego projektu.

# Task

1. Sprawdź, czy masz działające połączenie z `Supabase MCP`.
2. Sprawdź, czy w projekcie `Supabase` istnieje wdrożona Edge Function `delete-account`.
3. Jeżeli jej nie ma albo jest nieaktualna, wdroż funkcję z pliku:
- `supabase/functions/delete-account/index.ts`
4. Przy wdrożeniu upewnij się, że `verify_jwt` jest włączone.
5. Sprawdź w `lib/features/profiles/presentation/ui/profile_screen.dart`, czy kod Fluttera ma już podpięty prawdziwy flow `Delete account` w profilu.
    - Jeżeli nie, podepnij istniejące elementy template tak, aby przycisk `Usuń konto` wykonywał realne usuwanie konta, a nie otwierał placeholder lub ekran setupu.
6. Wykorzystaj istniejące elementy, jeśli już są dostępne:
- `lib/app/profile/presentation/cubit/account_actions_cubit.dart`
- `lib/features/auth/data/repositories/auth_repository.dart`
- `lib/features/auth/data/datasources/auth_data_source.dart`
7. Jeżeli wprowadziłeś zmiany w plikach, wykonaj teraz commit.

Gdy skończysz, poinformuj użytkownika o rezultacie.

Gdy odpowie "next", przejdź do wykonania polecenia zawartego w `docs/commands/00_init/12_init-checklist.md`.

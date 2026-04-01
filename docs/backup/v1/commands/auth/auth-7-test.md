# KROK 12: Smoke Test

1. **Nowy user:** Welcome → "Rozpocznij" → Guided Onboarding → Home
2. **Powracający:** restart app → od razu Home
3. **Logout:** Settings → Wyloguj → Welcome
4. **Login flow:** Welcome → "Mam konto" → Login → Home
5. **RC sync:** Verify RC logIn called after signIn (check debug logs)
6. **App resume:** Background → foreground → entitlements refreshed (throttle 30s)

**Status:** `ready-to-test`

---

# KROK 13: Test & Feedback

**Dostosuj do `communication_mode` z CLAUDE.md:**

**Dla beginner:**
```
Teraz sprawdź czy autentykacja działa.

Uruchom aplikację:
flutter run

Przetestuj jako NOWY USER:
1. Powinieneś zobaczyć Welcome screen
2. Kliknij "Rozpocznij" → powinien zalogować anonimowo i przejść do Guided Onboarding
3. Przejdź cały onboarding → czy trafiasz na Home?

Przetestuj POWRÓT:
4. Zamknij aplikację
5. Otwórz ponownie → czy od razu Home (bez Welcome)?

Przetestuj LOGOUT:
6. Settings → Wyloguj → czy wraca do Welcome?

Przetestuj "Mam konto":
7. Na Welcome → "Mam konto" → czy otwiera Login screen?

Jak wszystko działa, napisz "ok". Jak coś nie działa - powiedz co.
```

**Dla intermediate/advanced:**
```
`flutter run` - przetestuj:
- signInAnonymously flow (Welcome→Guided Onboarding→Home)
- Session persistence (restart app → still logged in)
- Logout flow
- Login/Register screens dostępne
Jak OK, napisz "ok".
```

**Po "ok" - weryfikacja w bazie:**
```sql
SELECT id, email, is_anonymous FROM auth.users ORDER BY created_at DESC LIMIT 5;
SELECT * FROM profiles ORDER BY created_at DESC LIMIT 5;
SELECT * FROM {prefix}_[tabela] ORDER BY created_at DESC LIMIT 5;
```

**Sprawdź:**
1. Czy w `auth.users` jest nowy rekord?
2. Czy w `profiles` jest profil z `onboarding_completed = true`?
3. Czy dane mają poprawne `user_id`?

**CZEKAJ na "ok" od usera!**

- **błąd / problem** → napraw i powtórz test
- **"ok"** → **NATYCHMIAST wykonaj KROK 14 poniżej (NIE kończ tury, NIE czekaj na kolejny input!)**

---

# KROK 14: Finalizacja

> **⚠️ WYKONAJ NATYCHMIAST po "ok" od usera! Nie wyświetlaj komunikatu i nie czekaj — od razu rób poniższe kroki.**

1. **Flutter analyze (OBOWIĄZKOWE!):**
```bash
flutter analyze
```
**Wyczyść WSZYSTKO** - zero błędów, zero warningów, zero info!

2. **CLAUDE.md:** Status `/auth` → `done`
3. **Commit:**
```
feat(auth): implement authentication with full SessionRepository and RevenueCat

- Add Login/Register/Reset Password screens
- Implement SupabaseAuthDataSource (signInAnonymously, linkEmail, etc.)
- Add SupabaseProfileDataSource with realtime
- Add SecureStorageProfileLocalDataSource (cache)
- Add ConnectivityPlusDataSource
- Implement SessionRepositoryImpl (4/4 sources, full RC integration)
- Evolve SubscriptionDataSource from bool isPro to full CustomerInfo stream
- Extend RevenueCatDataSource with logIn/logOut/purchase/offerings/restore
- Sync RC logIn/logOut with auth state changes
- Add AppLifecycleObserver for refresh on resume (throttle 30s)
- Update AppGate to use SessionCubit
- Tier fully computed: isPro from RC entitlements, guest/registered/pro
- Add shouldShowRegisterCTA for anonymous subscribers
```

4. **Zapowiedź** (dopiero TERAZ, po done + commit): `"Auth gotowy! Commit wykonany. Wpisz /limits gdy będziesz gotowy."`

---

## Reguły dla Agenta AI

> 📖 Pełna lista anty-wzorców: `.claude/skills/supabase-auth/SKILL.md` → sekcja "Anty-wzorce"

### KRYTYCZNE
- **Tier jest COMPUTED, nie stored!** Nigdy nie dodawaj kolumny tier do DB
- **switchMap + combineLatest** jak w `docs/SESSION_ARCHITECTURE.md`
- **Error handling w każdym stream source** - fallback, nie error do combineLatest (onErrorReturn)
- **Profile cache** - stale-while-revalidate pattern
- **SubscriptionDataSource = RevenueCat (FULL)** — pełna integracja z logIn/logOut
- **`Purchases.logIn(userId)` przy każdej zmianie user.id** (signIn, signUp)
- **`Purchases.logOut()` przy signOut**
- **NIE logIn przy linkIdentity** (user.id się nie zmienia!)
- **Refresh on app resume** (throttle 30s)
- `ensureProfile()` MUSI być wywołane PRZED `hasCompletedOnboarding` w AppGate
- W RegisterScreen sprawdzaj `isAnonymous` przed wyborem metody (linkEmailToAnonymous vs signUpWithEmail)
- **ROZBUDOWUJ istniejące pliki** — nie twórz nowych jeśli plik już istnieje
- **Aktualizuj WSZYSTKIE miejsca** które używały starego `watchIsPro()` / `getIsPro()`

### WAŻNE
- Używaj tokenów z `shared/theme/` we wszystkich ekranach auth
- Walidacja formularzy inline (NIE snackbar!)
- Loading states na przyciskach podczas operacji async

### ZAKAZY
- Snackbarów "wkrótce" w Settings - wszystko musi działać od razu
- `signUpWithEmail()` dla anonymous usera - to tworzy NOWY user i TRACI dane!
- Hardcoded stringi bez komentarza `// L10N`
- Hardcoded user ID w UI (np. `'fake-user-id'`, `kDevUserId`) - ZAWSZE pobieraj z AuthCubit
- `watchProfile()` tylko w gałęzi sukcesu `ensureProfile` - MUSI startować niezależnie od wyniku
- Fire-and-forget async w BlocListener - ZAWSZE `await` async callbacków
- Hardcoded ceny w UI (używaj offerings z RC)
- Pomijanie RC sync przy auth changes
- Tier stored w DB (zawsze computed!)
- Tworzenie nowych plików gdy istniejące można rozbudować
- Instalowanie dependency które już są w pubspec
- Zmienianie api-keys.json (klucze już skonfigurowane)

### Synchronizacja (OBOWIĄZKOWE)
- Przy KAŻDEJ zmianie statusu → sync z platformą
- Na końcu kroku sprawdź czy było trudno → zapisz struggle (bez pytania usera)
- Jeśli API zwraca 401 → poproś o nowy API Key

---

## Checklisty

### Po KROK 0-2:
- [ ] Supabase Dashboard skonfigurowany (email confirm OFF, anonymous ON, linking ON)
- [ ] Login/Register/Reset screens stworzone
- [ ] SupabaseAuthDataSource implementuje interfejs
- [ ] `linkEmailToAnonymous()` używa `updateUser()` (NIE `signUp()`!)

### Po KROK 3-5:
- [ ] Welcome "Rozpocznij" → signInAnonymously
- [ ] Welcome "Mam konto" → Login screen
- [ ] AppGate wywołuje `ensureProfile()` PRZED sprawdzeniem onboarding
- [ ] Profiles table utworzona z RLS
- [ ] Migracja LocalStorage → Supabase działa

### Po KROK 6-7:
- [ ] "Połącz konto" działa dla gości
- [ ] Settings: Wyloguj działa (NIE snackbar!)
- [ ] Settings: Usuń konto działa z dialogiem
- [ ] RLS zaktualizowane na `auth.uid()`

### Po KROK 8-9 (RC integration):
- [ ] SubscriptionDataSource rozbudowany (watchEntitlements, logIn, logOut, purchase, etc.)
- [ ] RevenueCatDataSource rozbudowany (BehaviorSubject<CustomerInfo?>)
- [ ] RC logIn wywolywane przy signInAnonymously i signInWithEmail
- [ ] RC logOut wywolywane przy signOut
- [ ] RC NIE wywolywane przy linkIdentity
- [ ] Wszystkie uzycia watchIsPro/getIsPro zaktualizowane

### Po KROK 10-11 (lifecycle + tier):
- [ ] AppLifecycleObserver dodany (refresh on resume, throttle 30s)
- [ ] Tier computation dziala dla 4 scenariuszy (guest/registered/pro/anon+pro)
- [ ] shouldShowRegisterCTA dziala dla anonymous subscribers

### Po KROK 12-13 (smoke test + feedback):
- [ ] Nowy user flow dziala (Welcome->Guided Onboarding->Home)
- [ ] Session persistence dziala
- [ ] Logout flow dziala
- [ ] **User potwierdzil "ok"**
- [ ] Dane zweryfikowane w bazie

### Po KROK 14 (TYLKO po "ok"!):
- [ ] SESSION_ARCHITECTURE.md zweryfikowany vs kod
- [ ] CLAUDE.md status -> `done`
- [ ] **Status zsynchronizowany z platformą:**
```bash
curl -X PATCH {API Base URL}/user/apps/{Platform App ID} \
  -H "X-API-Key: {API Key}" \
  -H "Content-Type: application/json" \
  -d '{"steps": [{"id": "{auth_step_id}", "status": "done"}]}'
```
- [ ] Commit wykonany
- [ ] Agent sprawdzil czy krok byl trudny -> jesli tak, zapisal struggle do API

---

## PRZED OZNACZENIEM JAKO DONE

Gdy user potwierdzi że wszystko działa ("ok"), **ZANIM** oznaczysz `/auth` jako `done` w CLAUDE.md:

1. Przeczytaj `docs/SESSION_ARCHITECTURE.md`
2. Porównaj z faktycznym kodem w `lib/features/session/`
3. Sprawdź zgodność:
   - Stream pattern (switchMap + combineLatest3) -- czy SessionRepositoryImpl tak działa?
   - 4 zrodla danych (Auth, Profile, Subscription, Connectivity) -- czy wszystkie podpiete?
   - Error handling (onErrorReturn/onErrorResumeNext) -- czy kazdy stream ma fallback?
   - Distinct filtering -- czy `sessionStream` ma `.distinct()`?
   - RC sync (logIn/logOut) -- czy wywolywane przy zmianach auth?
   - Offline mode -- czy `isOffline` z ConnectivityDataSource?
4. Jesli sa rozbieznosci -- **napraw kod** zeby byl zgodny z docs/SESSION_ARCHITECTURE.md (chyba ze celowo odbieglismy -- wtedy opisz powod w notatce per krok)
5. Dopiero potem oznacz jako `done`

---

## Struktura plików po /auth

```
lib/features/
├── auth/
│   ├── ui/
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   └── reset_password_screen.dart
│   ├── data_source/
│   │   └── supabase_auth_data_source.dart
│   ├── repository/
│   │   └── auth_repository.dart
│   └── cubit/
│       └── auth_cubit.dart
├── profiles/
│   └── repository/
│       └── profiles_repository.dart
└── app/
    └── app_gate.dart
```

---

> ✅ KROK /auth ukończony!

---
description: Finalizacja - posprzątaj CLAUDE.md, przygotuj projekt do dalszego developmentu
allowed-tools: Read, Write, Edit, Bash, AskUserQuestion, Glob, Grep, Task
---

# /finalize - Finalizacja projektu

Posprzątaj CLAUDE.md z kursowego scaffoldingu i przygotuj projekt do samodzielnego developmentu.

---

## PREREQ: Sprawdź stan projektu

1. Przeczytaj `CLAUDE.md` - sekcja "Stan projektu"
2. Sprawdź status:
   - `/localize` musi być `done`
   - Jeśli `/localize` nie jest `done` → "Najpierw wpisz `/localize` aby dodać lokalizację."
3. Sprawdź status `/finalize`:
   - Jeśli `done` → "Projekt już sfinalizowany. CLAUDE.md jest czysty."
   - Jeśli `in-progress` → kontynuuj
   - Jeśli `not-started` → rozpocznij od KROKU 1

---

## Synchronizacja z platformą

Przed rozpoczęciem:
1. Sprawdź `.env` → `PLATFORM_API_KEY`. Jeśli brak lub pusty → poproś usera:
   "Potrzebuję API Key z platformy. Wejdź na platformę → Profil → skopiuj API Key i wklej tutaj."
   Po otrzymaniu → zapisz do `.env` i zwaliduj (GET /user). Jeśli 401 → poproś ponownie.
2. Sprawdź w CLAUDE.md:
   - **Platform App ID** - ID tej aplikacji na platformie
   - **Step ID dla tego kroku** - UUID z mapowania w CLAUDE.md
3. Jeśli brakuje Platform App ID lub Step ID → "Najpierw wpisz `/start` aby połączyć z platformą."

> **UWAGA:** Sprawdzanie API Key dotyczy KAŻDEJ komendy, nie tylko /start. Klucz może wygasnąć lub zostać zregenerowany w dowolnym momencie.

---

## Sync: in_progress

Po sprawdzeniu PREREQ i synchronizacji z platformą, wyślij PATCH `in_progress`:

```bash
curl -X PATCH {API Base URL}/user/apps/{Platform App ID} \
  -H "X-API-Key: {API Key}" \
  -H "Content-Type: application/json" \
  -d '{"steps": [{"id": "{finalize_step_id}", "status": "in_progress"}]}'
```

---

## KROK 1: Przepisz CLAUDE.md

### 1.1 Aktualizuj status

W `CLAUDE.md`:
- Status `/finalize`: `in-progress: cleanup`
- Kontekst: `Przepisywanie CLAUDE.md na dokumentację projektu`

### 1.2 Zbierz dane

Pobierz dane z aktualnego CLAUDE.md i projektu:
- **Nazwa aplikacji** → `docs/IDEA.md` (nagłówek lub sekcja "Nazwa")
- **Opis** → `docs/IDEA.md` (sekcje "Problem" + "Rozwiązanie")
- **Limity** → `docs/IDEA.md` (sekcja "Auth & Tiery")
- **Główna funkcja** → sprawdź `lib/features/` jaki folder jest główny (nie session/onboarding/settings)

### 1.3 Przepisz CLAUDE.md

**WAŻNE:** To jest transformacja z "pamięci kursu" na "dokumentację projektu".
Przepisz CLAUDE.md używając poniższego template. Sekcje oznaczone `>` to instrukcje — **PRZEPISZ je prawdziwą treścią** z aktualnego CLAUDE.md.

**Nowa zawartość CLAUDE.md:**

```markdown
# [Nazwa Aplikacji z IDEA.md]

[Jednozdaniowy opis aplikacji z IDEA.md]

## O projekcie

[2-3 zdania z IDEA.md: co aplikacja robi, dla kogo jest, jaki problem rozwiązuje]

## Stack technologiczny

| Technologia | Użycie |
|-------------|--------|
| Flutter 3.x | Framework UI |
| flutter_bloc | State management (Cubit pattern) |
| Supabase | Backend (Auth + PostgreSQL) |
| RevenueCat | Płatności i subskrypcje |
| get_it | Dependency Injection |
| freezed | Immutable models + unions |
| go_router | Nawigacja |

## Architektura

[Przepisz z aktualnego CLAUDE.md sekcje "Architektura" i "Zasady Krytyczne".
Zachowaj WSZYSTKO — clean architecture, kierunek zależności, tabelę warstw, feature-first strukturę.]

### Clean Architecture

[Przepisz: kierunek zależności, tabelę warstw, feature-first strukturę, reguły importów, warstwę app/.]

### Zasady krytyczne

[Przepisz sekcję "Zasady Krytyczne (Security & Stability)" — izolacja Supabase, stream-first, DI singleton/factory, error logging, etc.]

### User Tiers

[Przepisz sekcję "User Tiers" — computed tiers, limity, źródła danych.]

### Session Management

[Przepisz sekcję "Session Architecture" — SessionRepository, 4 źródła, stream pattern, offline mode.]

### Konwencje nazewnictwa

[Przepisz sekcję "Konwencje nazewnictwa".]

### Flow aplikacji

[Przepisz uproszczony flow z "Flow Contract": AppGate → Welcome/Onboarding vs Home.
Bez kursowego kontekstu ("po /home", "po /screens" etc.).]

## Struktura projektu

```
lib/
├── app/                      # Konfiguracja aplikacji
│   ├── app.dart              # MaterialApp + providers
│   └── router/               # Nawigacja (AppGate, routes)
├── core/                     # Współdzielone utilities
│   ├── di/                   # Dependency Injection
│   ├── limits/               # LimitPolicy
│   └── config/               # API keys, environment
├── features/                 # Moduły funkcjonalne
│   ├── session/              # Zarządzanie sesją
│   ├── [główna_funkcja]/     # Główna funkcjonalność aplikacji
│   ├── onboarding/           # Onboarding flow
│   └── settings/             # Ustawienia użytkownika
├── l10n/                     # Lokalizacja (PL, EN)
└── shared/                   # Współdzielone widgety
```

## Uruchomienie projektu

### Wymagania
- Flutter 3.x
- Dart 3.x
- Konto Supabase (darmowe)
- Konto RevenueCat (darmowe do testów)

### Instalacja

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

### Konfiguracja

1. **Supabase:** URL i Anon Key w `lib/core/config/supabase_config.dart`
2. **RevenueCat:** API Key w `lib/core/config/revenuecat_config.dart`

## Design System

[Przepisz z aktualnego CLAUDE.md — wireframe, vibe, paleta, typography, charakterystyka.
Tokeny w kodzie: `lib/shared/theme/` (app_colors.dart, app_typography.dart, app_spacing.dart)]

## Database

[Przepisz schema tabel i RLS policies z aktualnego CLAUDE.md.]

## Zasady kodowania

[Przepisz z aktualnego CLAUDE.md:
- Sekcję "Zasady dla Agenta AI" (ZAWSZE rób, NIGDY nie rób)
- Sekcję "Komendy CLI" (flutter test, flutter analyze, build_runner)

To są reguły utrzymania projektu — obowiązują przy każdej przyszłej zmianie kodu.]

## App Metadata

- **App Number:** [N] z 12 (12 Apps Challenge)
- **Complexity Tier:** [tier z App Complexity Guidance]

## Lokalizacja

Aplikacja wspiera 2 języki:
- Polski (domyślny)
- English

Pliki tłumaczeń: `lib/l10n/app_[locale].arb`

Aby dodać nowy język, utwórz plik `app_[kod].arb` i dodaj locale do `lib/l10n/l10n.dart`.
```

### Co USUNĄĆ ze starego CLAUDE.md (kursowy scaffolding):
- Sekcję "Stan projektu" (tabela kroków)
- Sekcję "Notatki per krok"
- Sekcję "▶ Co dalej"
- Sekcję "Flow Contract & EntryPoint Policy" (ale sam flow → przenieś do Architektura)
- Sekcję "Dostępne Narzędzia" / "Komendy" / "Skille"
- Wszystkie wzmianki o `/start`, `/home`, `/design` etc.
- Placeholdery "TODO: wypełnij po /xyz"
- Sekcję "Ekrany per etap"
- Sekcję "Backlog"
- Sekcję "Auto-commit"
- Sekcję "Dane użytkownika" i "Konfiguracja aplikacji"
- Sekcję "Styl komunikacji"
- Sekcję "Połączenie z platformą" i mapowanie kroków
- Sekcję "Kontekst z poprzednich projektów"
- Sekcję "Automatyczne zapisywanie struggles"

### Co ZACHOWAĆ (tabela mapowania stare → nowe):

| Ze starego CLAUDE.md | Do nowego CLAUDE.md | Co zawiera |
|---------------------|---------------------|------------|
| "Architektura" | ## Architektura → Clean Architecture | Kierunek zależności, tabela warstw, feature-first, warstwa app/ |
| "Zasady Krytyczne" | ## Architektura → Zasady krytyczne | Izolacja Supabase, stream-first, DI singleton/factory, error logging |
| "User Tiers" | ## Architektura → User Tiers | Computed tiers, limity |
| "Session Architecture" | ## Architektura → Session Management | SessionRepository, 4 źródła, stream pattern, offline |
| "Konwencje nazewnictwa" | ## Architektura → Konwencje | Naming, imports, pliki |
| "Design System" | ## Design System | Wireframe, vibe, paleta, typography, tokeny |
| "Database Schema" | ## Database | Tabele, RLS policies, realtime publication |
| "Zasady dla Agenta AI" | ## Zasady kodowania | ZAWSZE rób / NIGDY nie rób — reguły utrzymania |
| "Komendy CLI" | ## Zasady kodowania (na dole) | flutter test, analyze, build_runner |
| "Flow Contract" (uproszczony) | ## Architektura → Flow | AppGate → Welcome/Home, nawigacja |
| "App Complexity Guidance" | ## App Metadata | Numer apki i complexity tier |

---

## KROK 2: flutter analyze

```bash
flutter analyze
```

Upewnij się że zero problemów.

---

## KROK 3: Commit

```bash
git add -A
git commit -m "chore: finalize CLAUDE.md — clean project documentation

- Remove course scaffolding (step tracking, notes, backlog)
- Keep architecture, coding rules, design system, database schema
- Prepare project for independent development"
```

---

## KROK 4: Podsumowanie

```
Projekt sfinalizowany!

CLAUDE.md jest teraz czystą dokumentacją projektu — bez kursowego scaffoldingu,
ale ze wszystkimi regułami potrzebnymi do dalszego developmentu:

✅ Clean Architecture (warstwy, importy, DI)
✅ Zasady kodowania (ZAWSZE/NIGDY, stream-first, error handling)
✅ Design System (wireframe, paleta, tokeny)
✅ Database Schema (tabele, RLS)
✅ Session Architecture (4 źródła, tiers)
✅ Konwencje nazewnictwa
✅ Flow aplikacji (AppGate → routing)

Przed publikacją:
1. [ ] App Store / Play Store developer accounts
2. [ ] Screenshots
3. [ ] Privacy Policy & Terms of Service
4. [ ] Test na prawdziwych urządzeniach

Powodzenia z publikacją!
```

---

## Checklist

- [ ] `/localize` jest `done`
- [ ] CLAUDE.md przepisany na dokumentację projektu
- [ ] Usunięte sekcje kursu (Stan projektu, Notatki, Komendy, Backlog, etc.)
- [ ] Zachowane: Clean Architecture, Zasady Krytyczne, Konwencje
- [ ] Zachowane: Design System, Database Schema
- [ ] Zachowane: Zasady kodowania (ZAWSZE/NIGDY rób)
- [ ] Zachowane: Session Architecture, User Tiers, Flow
- [ ] `flutter analyze` = zero problemów
- [ ] Commit wykonany
- [ ] **Status zsynchronizowany z platformą:**
  ```bash
  curl -X PATCH {API Base URL}/user/apps/{Platform App ID} \
    -H "X-API-Key: {API Key}" \
    -H "Content-Type: application/json" \
    -d '{"steps": [{"id": "{finalize_step_id}", "status": "done"}]}'
  ```
- [ ] Agent sprawdził czy krok był trudny → jeśli tak, zapisał struggle do API

---

## Reguły dla Agenta AI

### KRYTYCZNE
- **PRZEPISUJ sekcje prawdziwą treścią** — nie zostawiaj placeholderów `>` w finalnym CLAUDE.md!
- **NIE gubiaj reguł** — każda sekcja z tabeli mapowania MUSI być w nowym CLAUDE.md
- **Upraszczaj** — wyczyść kursowy kontekst ("po /home dodaje...") ale zachowaj merytorykę

### ZAKAZY
- NIE zostawiaj wzmianek o krokach kursu (`/start`, `/home`, etc.)
- NIE usuwaj reguł architektonicznych ani zasad kodowania
- NIE zostawiaj pustych sekcji — każda musi mieć prawdziwą treść

### Synchronizacja (OBOWIĄZKOWE)
- Przy KAŻDEJ zmianie statusu → sync z platformą
- Na końcu kroku sprawdź czy było trudno → zapisz struggle (bez pytania usera)
- Jeśli API zwraca 401 → poproś o nowy API Key

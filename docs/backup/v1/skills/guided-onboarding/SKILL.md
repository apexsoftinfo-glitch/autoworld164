---
name: guided-onboarding
description: Use when building welcome screen, login screen, sign in page, sign up page, register screen, onboarding, landing page, auth flow, or first-time user experience. 6-step flow - Welcome (logo+2 buttons) → Name → Preview → Guided Action (PROBLEM→SOLUTION→EXPERIENCE→BRIDGE) → MINIMAL SETUP (only required fields!) → Home (with user's first item). (project)
---

# Skill: Guided Onboarding

Guided Onboarding to kontrolowane przeprowadzenie usera przez pierwszą wartość aplikacji.

## Guided Onboarding Flow (6 kroków)

```
┌─────────────────────────────────────────────────────────────┐
│  1. WELCOME SCREEN                                          │
│     Logo + nazwa aplikacji                                  │
│     [Rozpocznij] → Guided Onboarding flow (krok 2)         │
│     [Zaloguj się] → OSOBNY ekran/modal logowania           │
│                                                             │
│  CEL: Pierwsze wrażenie, wybór ścieżki                     │
│  UWAGA: To NIE jest formularz! Tylko logo + 2 przyciski    │
│                                                             │
│  ANIMACJA WEJŚCIA (WYMAGANE!):                             │
│  - Logo: scale (0.5→1.0) + fade, 600-800ms, elasticOut     │
│  - Tekst: fade-in po logo                                  │
│  - Przyciski: fade-in na końcu                             │
│  - NIGDY generyczne kółko jako logo!                       │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  2. PYTANIE O IMIĘ                                          │
│     "Jak masz na imię?"                                     │
│     [TextField - autofocus]                                 │
│     [Dalej]                                                 │
│                                                             │
│  CEL: Personalizacja, budowanie relacji                    │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  3. WITAJ + ZAPOWIEDŹ AKCJI (krótki ekran!)                │
│     "Witaj, [imię]!"                                        │
│     "Za chwilę zobaczysz jak działa [App]."                │
│     [Zaczynamy!]                                            │
│                                                             │
│  CEL: Personalne powitanie + zapowiedź DEMO                │
│  UWAGA: To NIE jest miejsce na marketing/value proposition!│
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  4. GUIDED ACTION (PROBLEM → SOLUTION → EXPERIENCE)        │
│     PROBLEM: Pokaż wizualnie co jest złe w typowej app     │
│     SOLUTION: Wyjaśnij jak ta app rozwiązuje problem       │
│     EXPERIENCE: User przeklika 2-3x core loop na DEMO      │
│     BRIDGE: "Twoja kolej! Dodaj swój pierwszy [element]"   │
│                                                             │
│  CEL: User ROZUMIE wartość + BRIDGE do własnych danych    │
│  UWAGA: BRIDGE to ostatni ekran EXPERIENCE, nie osobny!   │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  5. MINIMAL SETUP (tylko WYMAGANE pola!)                   │
│     "Dodaj swój pierwszy [element]:"                       │
│     [Tylko 1-2 pola REQUIRED]                              │
│     "Resztę możesz uzupełnić później"                      │
│     [Dodaj i rozpocznij]                                   │
│                                                             │
│  CEL: User tworzy SWÓJ pierwszy element                    │
│  UWAGA: UKRYJ wszystkie pola opcjonalne!                   │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  6. HOME SCREEN (z elementem usera!)                       │
│     "Cześć, [imię]!"                                        │
│     [Nowo utworzony element - PODŚWIETLONY/ANIMOWANY]      │
│     Opcjonalny JIT tooltip: "Oto Twój pierwszy [element]!" │
│                                                             │
│  CEL: Pełna aplikacja, Home NIE jest pusty                 │
│  UWAGA: BEZ osobnego ekranu "Jesteś gotowy!" - od razu Home│
└─────────────────────────────────────────────────────────────┘
```

## Zasady projektowania Guided Onboarding

### 1. Każdy ekran = jeden cel
Nie mieszaj celów. Welcome = wybór ścieżki. Imię = personalizacja. Guided action = robienie.

### 2. Pytaj o imię NA POCZĄTKU
To buduje relację i pozwala personalizować dalsze ekrany ("Witaj, [imię]!").

### 3. User ROBI akcję w kontrolowanym środowisku
Nie rzucaj usera na pusty Home. Poprowadź go przez dodanie pierwszego elementu w dedykowanym UI.

### 4. Krok 3 = ZAPOWIEDŹ AKCJI (nie marketing!)

**DOBRZE** - zapowiedź konkretnej akcji:
```
"Witaj, Adam!"
"Za chwilę dodasz swój pierwszy nawyk."
[Zaczynamy!]
```

**ŹLE** - marketing/value proposition:
```
"Witaj, Adam!"
"Jeden krok na raz"
• Zamiast listy zadań, zobaczysz tylko jeden nawyk
• Nie musisz podejmować wielu decyzji
• Skup się na tym co teraz
[Dalej]
```

Krok 3 to **1-2 zdania** przygotowujące usera mentalnie na akcję, NIE slajd marketingowy z bullet points.

### 5. Pattern: PROBLEM → SOLUTION → EXPERIENCE (KRYTYCZNE!)

Guided Action to NIE tutorial mechaniki ("kliknij tu"). To **demonstracja wartości** - user musi zrozumieć DLACZEGO ta aplikacja jest lepsza.

#### Struktura Guided Action:

```
┌─────────────────────────────────────────────────────────────┐
│  PROBLEM (1 ekran)                                          │
│  Pokaż wizualnie co jest złe w "starym" podejściu          │
│  "Typowa aplikacja wygląda tak:" + przykład problemu        │
│                                                             │
│  UWAGA: Jasno zaznacz że to PRZYKŁAD/DEMO!                 │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  SOLUTION (1 ekran)                                         │
│  "W [App] jest inaczej:" + 1-2 zdania wyjaśnienia          │
│  "Zobaczmy jak to działa na przykładach..."                │
│                                                             │
│  UWAGA: Podkreśl że zaraz zobaczy DEMO działania           │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  EXPERIENCE (2-3 kliknięcia, MEGA PROSTE!)                 │
│  User przeklika core loop 2-3 razy na PRZYKŁADOWYCH danych │
│  Bez myślenia, bez pisania - tylko klik, klik, klik        │
│  Celem jest ZROZUMIENIE FLOW, nie wykonanie prawdziwych    │
│  zadań!                                                     │
└─────────────────────────────────────────────────────────────┘
```

#### Jak zbudować każdy krok?

**PROBLEM (1 ekran):**
```
"Typowa aplikacja [kategoria] wygląda tak:"
[Wizualizacja problemu - np. przytłaczająca lista, skomplikowany UI]
"[Krótkie pytanie retoryczne o problem]"
[Dalej]
```

**SOLUTION (1 ekran):**
```
"W [Nazwa App] jest inaczej:"
"[1-2 zdania wyjaśnienia jak app rozwiązuje problem]"

"Zobaczmy jak to działa - przeklikaj przykłady:"
[Pokaż mi]
```

**EXPERIENCE (2-3 kliknięcia):**
```
"To jest przykład. Kliknij cokolwiek:"
[Przykładowy element 1]
[Przycisk akcji] ← user klika

// Natychmiast pojawia się następny
[Przykładowy element 2]
[Przycisk akcji] ← user klika
```

**BRIDGE (zintegrowany jako ostatni ekran EXPERIENCE!):**
```
"Widzisz? [Podsumowanie wartości w 1 zdaniu]"
"Twoja kolej - dodaj swój pierwszy [element]!"
[Dodaj swój pierwszy →]
```
BRIDGE to NIE osobny krok - to końcówka EXPERIENCE prowadząca do MINIMAL SETUP.

#### Przykłady dla różnych typów aplikacji:

| Typ App | PROBLEM (pokaż) | SOLUTION (wyjaśnij) | EXPERIENCE (przeklika) |
|---------|-----------------|---------------------|------------------------|
| Habit tracker | Lista 10 nawyków | "Zobaczysz tylko jeden" | 2-3x Done/Skip |
| Todo | Długa lista tasków | "Priorytet dnia na górze" | 2-3x oznacz jako done |
| Expense tracker | Skomplikowany formularz | "Jedno pole, 3 sekundy" | 2-3x szybkie dodanie |
| Notes | Chaotyczne notatki | "AI organizuje za Ciebie" | Zobacz jak AI grupuje |

#### Kluczowe zasady:

1. **PROBLEM musi być wizualny** - pokaż, nie opisuj
2. **SOLUTION = 1-2 zdania** - nie marketing, konkret
3. **EXPERIENCE = tylko klikanie** - zero pisania, zero myślenia
4. **Przykładowe dane** - user NIE wykonuje prawdziwych zadań
5. **2-3 iteracje** - user musi zobaczyć SEKWENCJĘ, nie pojedynczą akcję
6. **Jasna komunikacja** - "to przykład", "przeklikaj", "zobacz jak działa"

### REGUŁY WIZUALNOŚCI (KRYTYCZNE!)

| Ekran | Wizualny? | Interaktywny? | Max tekst |
|-------|-----------|---------------|-----------|
| PROBLEM | ✅ TAK | ❌ NIE | 1-2 zdania |
| SOLUTION | ✅ TAK | ❌ NIE | 1-2 zdania |
| EXPERIENCE | ✅ TAK | ✅ TAK (klikanie) | Instrukcja |
| BRIDGE | ✅ TAK | ❌ NIE | CTA |

**PROBLEM - wizualizacja, nie opis:**
- ❌ "Typowa aplikacja ma dużo tasków i ciężko się w niej odnaleźć..."
- ✅ Grid z przerwanym streakiem, czerwone X, wizualny chaos
- ✅ Przytłaczająca lista TODO z 20 elementami
- ✅ Skomplikowany formularz z 10 polami

**SOLUTION - wizualizacja sukcesu, nie wyjaśnienie:**
- ❌ "W naszej aplikacji masz wyraźny cel i możesz go osiągnąć..."
- ✅ Ukończony challenge z progress barem 100%, zielone checkmarki
- ✅ Prosty widok z jednym elementem "Dzisiaj"
- ✅ Mini formularz z 1-2 polami

**EXPERIENCE - user KLIKA, nie czyta:**
- ❌ Długi tekst wyjaśniający jak działa aplikacja
- ✅ Pasek postępu + przycisk "Oznacz dzień" - 3 kliknięcia
- ✅ Lista demo elementów do odhaczenia
- ✅ Animowany progress po każdym kliknięciu

#### CORE LOOP vs SETUP

| App | SETUP (nie pokazuj!) | CORE LOOP (to pokazuj!) |
|-----|---------------------|------------------------|
| Todo | Formularz dodawania | Odznaczanie jako done |
| Habit tracker | Tworzenie nawyku | Done / Skip sekwencja |
| Expense tracker | Dodawanie kategorii | Szybkie zapisanie wydatku |
| Journal | Konfiguracja | Napisanie wpisu |

**Formularz z wieloma polami w Guided Action = ZŁY ZNAK!**

### 6. MINIMAL SETUP (krok 5 w flow)

Po demo user rozumie wartość. Teraz potrzebuje SWOJEGO pierwszego elementu.

**Zasada:** Minimum viable input - tylko pola WYMAGANE do utworzenia elementu.

#### Struktura MINIMAL SETUP:
```
"Dodaj swój pierwszy [element]:"

[Tylko pole(a) REQUIRED - MAX 1-2]

"Resztę możesz uzupełnić później"
[Dodaj i rozpocznij]
```

#### Różnica od normalnego formularza:

| Aspekt | Normalny formularz | MINIMAL SETUP |
|--------|-------------------|---------------|
| Pola widoczne | Required + Optional | TYLKO Required |
| Ilość pól | 3-10 | MAX 1-2 |
| Kontekst | Funkcja aplikacji | Część onboardingu |
| Copy | "Dodaj [X]" | "Dodaj swój PIERWSZY [X]" |
| Info | - | "Resztę uzupełnisz później" |

#### Jak określić minimum?

Zadaj pytanie: **"Jakie jest NAJMNIEJSZE input potrzebne do utworzenia valid item?"**

| Typ aplikacji | Normalny formularz | MINIMAL SETUP |
|---------------|-------------------|---------------|
| Task manager | Title, desc, date, priority, tags | Title only |
| Habit tracker | Name, mini, why, category, reminder | Name only |
| Expense tracker | Amount, category, date, note, receipt | Amount + Category |
| Notes app | Title, folder, tags, content | Just content |
| Calendar | Name, date, time, repeat, reminder | Name + Date |

#### Opcjonalnie: Smart pre-fill z demo

Jeśli user kliknął konkretny element w EXPERIENCE (np. "Medytacja"), możesz zasugerować go w MINIMAL SETUP:
```
"Dodaj swój pierwszy nawyk:"
[Nazwa: Medytacja] ← pre-filled, edytowalny
[Dodaj]
```

### 7. Przejście do Home (BEZ osobnego ekranu!)

Po MINIMAL SETUP → **od razu Home**, bez ekranu "Jesteś gotowy!".

**Dlaczego?** User chce zobaczyć efekt swojej akcji. Dodatkowy ekran to friction.

**Jak potwierdzić sukces:**
- Highlight/animacja nowo utworzonego elementu
- Opcjonalny JIT tooltip: "Oto Twój pierwszy [element]!"
- Subtle celebration (confetti, pulse animation)

```
// ŹLE - osobny ekran
[MINIMAL SETUP] → [Jesteś gotowy!] → [HOME]

// DOBRZE - od razu Home z feedbackiem
[MINIMAL SETUP] → [HOME z podświetlonym elementem]
```

### 8. Przycisk zamknięcia (X) tylko przy replay
Gdy Guided Onboarding odpalane z HomeScreen (`isReplay: true`), pokazuj X w AppBar. Przy pierwszym uruchomieniu - bez X.

### 9. Anonymous Sign-in Timing (KRYTYCZNE!)

Anonimowe logowanie wykonaj **NA STARCIE Guided Onboarding** (przycisk "Rozpocznij"), NIE na końcu!

**KIEDY:** Na kliknięcie "Rozpocznij" na Welcome screen
**DLACZEGO:** Stabilne userId przez cały flow onboardingu (profil, preferencje, dane)
**JAK:**

```dart
// W OnboardingCubit
Future<void> startOnboarding() async {
  emit(state.copyWith(isAuthenticating: true, authError: null));

  // Step 1: Sign in anonymously
  final authResult = await _authRepository.signInAnonymously();

  await authResult.fold(
    (failure) async {
      emit(state.copyWith(
        isAuthenticating: false,
        authError: failure.message,
      ));
    },
    (user) async {
      // Step 2: Create profile with guest tier
      final profileResult = await _profilesRepository.ensureProfile(user.id);

      profileResult.fold(
        (failure) {
          emit(state.copyWith(
            isAuthenticating: false,
            authError: failure.message,
          ));
        },
        (_) {
          // Step 3: Success - proceed to Name page
          emit(state.copyWith(
            isAuthenticating: false,
            userId: user.id,
            currentPage: 1,
          ));
        },
      );
    },
  );
}
```

**W UI (Welcome page):**
```dart
ElevatedButton(
  onPressed: state.isAuthenticating
      ? null
      : () => cubit.startOnboarding(),
  child: state.isAuthenticating
      ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        )
      : const Text('Rozpocznij'),
),
if (state.authError != null)
  SelectableText(
    state.authError!,
    style: TextStyle(color: Theme.of(context).colorScheme.error),
  ),
```

**Anty-wzorce:**
```
❌ Logowanie dopiero po MINIMAL SETUP
❌ Logowanie na końcu Guided Onboarding
❌ Tworzenie profilu bez zalogowanego usera
❌ Brak obsługi błędu autentykacji
```

## Implementacja (faktyczna struktura)

### Struktura plików
```
lib/features/onboarding/
  ui/
    onboarding_screen.dart    # Główny ekran Guided Onboarding (wszystkie strony w jednym pliku)
  cubit/
    onboarding_cubit.dart     # Stan Guided Onboarding + logika
    onboarding_cubit.freezed.dart
```

### OnboardingState (freezed)
```dart
@freezed
class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    @Default(0) int currentPage,
    @Default('') String userName,
    @Default('') String taskName,
    @Default(false) bool taskAdded,
    @Default(false) bool taskCompleted,
    @Default(false) bool isCompleting,
    @Default(false) bool isCompleted,
  }) = _OnboardingState;
}
```

### OnboardingCubit
```dart
class OnboardingCubit extends Cubit<OnboardingState> {
  final LocalStorageService _localStorageService;
  static const int maxPage = 3;  // 4 strony: 0, 1, 2, 3

  OnboardingCubit({required LocalStorageService localStorageService})
      : _localStorageService = localStorageService,
        super(const OnboardingState());

  void setUserName(String name) => emit(state.copyWith(userName: name.trim()));
  void nextPage() {
    if (state.currentPage < maxPage) {
      emit(state.copyWith(currentPage: state.currentPage + 1));
    }
  }
  void previousPage() {
    if (state.currentPage > 0) {
      emit(state.copyWith(currentPage: state.currentPage - 1));
    }
  }

  void addTask(String taskName) {
    final name = taskName.trim().isEmpty ? 'Moje pierwsze zadanie' : taskName.trim();
    emit(state.copyWith(taskName: name, taskAdded: true));
  }

  void completeTask() => emit(state.copyWith(taskCompleted: true));

  Future<void> completeOnboarding() async {
    if (state.isCompleting) return;
    emit(state.copyWith(isCompleting: true));

    await _localStorageService.setBool(LocalStorageKeys.hasCompletedOnboarding, true);
    if (state.userName.isNotEmpty) {
      await _localStorageService.setString(LocalStorageKeys.userName, state.userName);
    }

    emit(state.copyWith(isCompleting: false, isCompleted: true));
  }

  bool get isLastPage => state.currentPage == maxPage;
  bool get canGoBack => state.currentPage > 0;
  bool get canProceedFromName => state.userName.trim().isNotEmpty;
}
```

### OnboardingScreen z isReplay
```dart
class OnboardingScreen extends StatelessWidget {
  /// If true, this is a replay from Home (show close button in AppBar)
  final bool isReplay;

  const OnboardingScreen({super.key, this.isReplay = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(
        localStorageService: getIt<LocalStorageService>(),
      ),
      child: _OnboardingView(isReplay: isReplay),
    );
  }
}

class _OnboardingView extends StatelessWidget {
  final bool isReplay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Przycisk X tylko gdy isReplay = true
      appBar: isReplay
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            )
          : null,
      body: // ... content
    );
  }
}
```

## Dostęp do onboardingu z Home (tylko debug mode)

**WAŻNE:** Przycisk debug musi prowadzić do `WelcomeScreen`, NIE bezpośrednio do Guided Onboarding!
User testuje pełny flow: Welcome → Guided Onboarding → Home.

```dart
// W HomeScreen - przycisk widoczny tylko w debug mode
class _LoadedContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ... główna zawartość

        if (kDebugMode) ...[
          const SizedBox(height: 16),
          const _DebugOnboardingButton(),
        ],
      ],
    );
  }
}

class _DebugOnboardingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {
        HapticFeedback.lightImpact();
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const WelcomeScreen(isReplay: true),
            fullscreenDialog: true,
          ),
        );
      },
      icon: const Icon(Icons.developer_mode, size: 18),
      label: const Text('Debug: Pokaż onboarding'),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.amber.shade900,
        side: BorderSide(color: Colors.amber.shade400),
      ),
    );
  }
}
```

### WelcomeScreen z isReplay

WelcomeScreen musi obsługiwać parametr `isReplay`:

```dart
class WelcomeScreen extends StatelessWidget {
  final bool isReplay;

  const WelcomeScreen({super.key, this.isReplay = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isReplay
        ? AppBar(
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          )
        : null,
      body: // ... welcome content
    );
  }
}
```

## Checklist

- [ ] Welcome screen z logo i nazwą apki (NIE formularz!)
- [ ] Przyciski "Rozpocznij" + "Zaloguj się" (zawsze widoczne)
- [ ] Przycisk X tylko gdy `isReplay: true`
- [ ] Pytanie o imię na początku (autofocus TextField)
- [ ] Personalne powitanie "Witaj, [imię]!"
- [ ] PROBLEM - wizualizacja problemu typowej aplikacji
- [ ] SOLUTION - wyjaśnienie jak ta app rozwiązuje problem
- [ ] EXPERIENCE - 2-3x przeklikanie demo na przykładowych danych
- [ ] BRIDGE - "Twoja kolej! Dodaj swój pierwszy [X]"
- [ ] MINIMAL SETUP - tylko REQUIRED fields (max 1-2 pola)
- [ ] Info "Resztę uzupełnisz później" w MINIMAL SETUP
- [ ] Home z PODŚWIETLONYM nowo utworzonym elementem
- [ ] BEZ osobnego ekranu "Jesteś gotowy!" przed Home
- [ ] SingleChildScrollView na każdej stronie (obsługa klawiatury)
- [ ] Przycisk debug na Home → WelcomeScreen (tylko debug mode)
- [ ] Guided Onboarding zapisuje flagę `hasCompletedOnboarding` i `userName`
- [ ] Paywall dopiero PO zakończeniu Guided Onboarding (opcjonalne)

## Anty-wzorce (NIE RÓB)

```
❌ Rzucanie usera na pusty Home ("sam sobie poradzi")
❌ Pytanie o imię na końcu lub wcale
❌ Slajdy informacyjne bez akcji usera
❌ Slajdy z value proposition / marketingiem / bullet points z zaletami app
❌ Krok 3 jako "filozofia aplikacji" zamiast zapowiedzi konkretnej akcji

// GUIDED ACTION (PROBLEM → SOLUTION → EXPERIENCE)
❌ Guided Action pokazuje SETUP zamiast CORE LOOP
❌ Guided Action bez pokazania PROBLEMU który app rozwiązuje
❌ Tylko 1 iteracja core loop (user musi zobaczyć SEKWENCJĘ 2-3x!)
❌ User musi PISAĆ w Guided Action (ma tylko KLIKAĆ!)
❌ Brak jasnej komunikacji że to DEMO/PRZYKŁAD
❌ Prawdziwe zadania w demo (user myśli że musi je wykonać naprawdę)
❌ Brak BRIDGE między demo a MINIMAL SETUP

// MINIMAL SETUP
❌ Pełny formularz w MINIMAL SETUP (tylko REQUIRED fields!)
❌ Więcej niż 1-2 pola w MINIMAL SETUP
❌ Pokazywanie pól opcjonalnych w MINIMAL SETUP
❌ Brak info "Resztę uzupełnisz później"
❌ Brak MINIMAL SETUP = pusty Home po Guided Onboarding

// PRZEJŚCIE DO HOME
❌ Osobny ekran "Jesteś gotowy!" między MINIMAL SETUP a Home
❌ Brak highlight/animacji nowo utworzonego elementu na Home
❌ Home bez żadnego elementu po zakończeniu Guided Onboarding

// OGÓLNE
❌ Paywall przed Guided Onboarding
❌ Brak możliwości ponownego odpalenia Guided Onboarding
❌ Guided Onboarding które nie prowadzi do First Value Moment
❌ Przycisk X na Welcome screen (tylko przy replay z Home)
❌ FORMULARZ LOGOWANIA NA WELCOME SCREEN (Welcome = logo + 2 przyciski, NIE formularz!)
❌ Pokazywanie pól email/hasło na pierwszym ekranie aplikacji

// WIZUALNOŚĆ (KRYTYCZNE!)
❌ PROBLEM jako tekst opisujący problem (zamiast wizualizacji widgetów)
❌ SOLUTION jako tekst wyjaśniający rozwiązanie (zamiast wizualizacji sukcesu)
❌ Więcej niż 1-2 zdania tekstu na ekranach PROBLEM/SOLUTION
❌ Generyczne kolorowe kółko jako logo na Welcome (zamiast ikony z Design System)
❌ Welcome screen bez animacji wejścia (logo MUSI mieć scale+fade!)
❌ Statyczny Welcome bez żadnej animacji
```

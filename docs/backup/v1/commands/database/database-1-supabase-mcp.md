# KROK 0b + 1: Rozbuduj CLAUDE.md + Sprawdzenie Supabase MCP

## ⚠️ CRITICAL: Tier NIE jest w bazie!

**NIE twórz kolumny `tier` w żadnej tabeli!**

Tier jest **COMPUTED** w runtime:
```dart
UserTier get tier {
  if (isPro) return UserTier.pro;           // z RevenueCat
  if (!isAnonymous) return UserTier.registered;  // z auth.users
  return UserTier.guest;
}
```

Źródła:
- `isAnonymous` → `auth.users.is_anonymous` (Supabase Auth)
- `isPro` → RevenueCat `CustomerInfo.entitlements`

Szczegóły: `docs/SESSION_ARCHITECTURE.md`

---

## ⚠️ CRITICAL: Table Prefix (PRZECZYTAJ NAJPIERW!)

**ZANIM utworzysz JAKĄKOLWIEK tabelę:**

1. **Przeczytaj `CLAUDE.md`** → sekcja "Konfiguracja aplikacji" → pole **Table Prefix**
2. **KAŻDA tabela** (oprócz `profiles`) MUSI mieć ten prefix!

**Przykład:**
- Table Prefix w CLAUDE.md: `{prefix}_`
- Schemat mówi: `{entities}` (nazwa z docs/IDEA.md, np. entries, tasks, notes)
- **Tworzysz tabelę:** `{prefix}_{entities}` ✅
- **NIE:** `{entities}` ❌

> **Parametryzacja:** Zastąp `{prefix}` prefixem z CLAUDE.md, a `{entities}` nazwą encji z docs/IDEA.md.

**Dlaczego?** Wszystkie aplikacje usera dzielą jeden projekt Supabase. Prefix rozróżnia tabele między aplikacjami.

**Wyjątek:** Tabela `profiles` NIE ma prefixu (wspólna) - ale jest tworzona w `/auth`, nie tutaj.

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

## KROK 0b: Rozbuduj CLAUDE.md (PIERWSZE co robisz!)

Dodaj do sekcji "## Zasady Krytyczne" w CLAUDE.md nowy punkt:

~~~markdown
9. **Supabase Realtime:** Po utworzeniu KAŻDEJ tabeli → `ALTER PUBLICATION supabase_realtime ADD TABLE nazwa_tabeli;`. Bez tego realtime subscriptions w Dart nie otrzymują zdarzeń.
~~~

Na końcu kroku (finalizacja):
1. **USUŃ** sekcję "## Database Schema (tymczasowe - usunąć po /database)" z CLAUDE.md
2. Zaktualizuj sekcję "▶ Co dalej" w CLAUDE.md:

~~~markdown
## ▶ Co dalej

**Następny krok:** `/auth` — Login/Register + migracja gościa
**Instrukcje:** `.claude/commands/auth.md`

> Wpisz `/auth` gdy będziesz gotowy!
~~~

---

## KROK 1: Sprawdzenie Supabase MCP

### 1.1 Zapowiedź

```
Teraz zajmiemy się bazą danych!

Będziemy używać Supabase jako backend. Żebym mógł tworzyć tabele
i zarządzać bazą, potrzebuję podłączonego Supabase MCP.

Czy masz już skonfigurowane Supabase MCP w swoim narzędziu?
```

### 1.2 Sprawdź MCP (spróbuj wywołać)

Spróbuj wywołać narzędzie MCP:
```
mcp__supabase__get_project_url
```

**Jeśli działa** → MCP jest skonfigurowane, przejdź do 1.5

**Jeśli nie działa / błąd** → MCP nie jest skonfigurowane, przejdź do 1.3

### 1.3 Konfiguracja Supabase MCP (jeśli brak)

#### 1.3.1 Ustal narzędzie użytkownika

Zapytaj:
```
W jakim narzędziu pracujesz? (Claude Code, Google Antigravity, OpenCode, Codex CLI, Gemini CLI, Cursor, Cline, Kilo Code, inne?)
```

Lub spróbuj wykryć automatycznie (sprawdź zmienne środowiskowe, pliki konfiguracyjne).

#### 1.3.2 Wyszukaj instrukcje

Użyj `WebSearch` aby znaleźć aktualne instrukcje:
```
WebSearch: "supabase mcp setup [nazwa_narzędzia] 2026"
```

Przykładowe zapytania:
- "supabase mcp claude code setup"
- "supabase mcp google antigravity configuration"
- "supabase mcp opencode integration"

#### 1.3.3 Poprowadź przez konfigurację

Na podstawie znalezionych instrukcji, poprowadź usera krok po kroku:

**Typowe kroki (dostosuj do narzędzia):**
1. Zainstaluj/włącz Supabase MCP w narzędziu
2. Podaj Access Token z Supabase Dashboard
3. Wybierz projekt lub podaj Project ID

**Gdzie znaleźć Access Token:**
```
1. Wejdź na https://supabase.com/dashboard
2. Kliknij ikonę użytkownika (prawy górny róg)
3. Account Settings → Access Tokens
4. Wygeneruj nowy token
```

#### 1.3.4 Zweryfikuj konfigurację

Po konfiguracji, ponownie wywołaj:
```
mcp__supabase__get_project_url
```

Jeśli nadal nie działa → poproś usera o sprawdzenie logów/błędów.

### 1.4 Zakładanie konta Supabase (jeśli nie ma)

Jeśli user nie ma konta Supabase:

```
Nie masz jeszcze konta Supabase? Spokojnie, założymy je razem!

1. Wejdź na https://supabase.com
2. Kliknij "Start your project" (zielony przycisk)
3. Zaloguj się przez GitHub (najszybciej) lub email
4. Po zalogowaniu kliknij "New Project"
5. Wypełnij:
   - Organization: wybierz lub utwórz
   - Project name: [nazwa z docs/IDEA.md]
   - Database Password: wygeneruj silne hasło (zapisz je!)
   - Region: wybierz najbliższy (np. Frankfurt dla PL)
6. Kliknij "Create new project"
7. Poczekaj ~2 minuty na utworzenie

Daj znać jak projekt będzie gotowy!
```

### 1.5 Sprawdź połączenie z projektem

Użyj narzędzia MCP:
```
mcp__supabase__get_project_url
mcp__supabase__get_publishable_keys
```

Jeśli zwraca URL i klucze → sukces!

### 1.6 Sync status z platformą

Wyślij PATCH do platformy z nowym statusem `in_progress`:

```bash
curl -X PATCH {API Base URL}/user/apps/{Platform App ID} \
  -H "X-API-Key: {API Key}" \
  -H "Content-Type: application/json" \
  -d '{"steps": [{"id": "{database_step_id}", "status": "in_progress"}]}'
```

> Wartości `{API Base URL}`, `{Platform App ID}` odczytaj z CLAUDE.md, `{API Key}` z `.env`.

### 1.7 Aktualizuj status

W `CLAUDE.md`:
- Status `/database`: `in-progress: config`
- Kontekst: `Supabase MCP skonfigurowane`

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/database/database-2-config.md`

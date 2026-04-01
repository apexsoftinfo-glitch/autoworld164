# KROK 0: Konfiguracja Supabase Dashboard

> **Najpierw rozbuduj CLAUDE.md!** Dodaj poniższe sekcje przed sekcją "## Zasady dla Agenta AI":

#### Rozbuduj sekcję: User Tiers

Zaktualizuj istniejącą sekcję "## User Tiers" w CLAUDE.md — dodaj źródła danych:

~~~markdown
**Źródła danych dla tier:**
- `isAnonymous` → Supabase Auth (`user.isAnonymous`)
- `isPro` → RevenueCat (`customerInfo.entitlements.active.containsKey('pro')`)
~~~

#### Dodaj sekcję: Session Architecture

~~~markdown
## Session Architecture

**Single Source of Truth:** `SessionRepository` agreguje 4 źródła danych:
1. `AuthDataSource` → Supabase Auth state
2. `ProfileDataSource` → Supabase profiles + local cache
3. `SubscriptionDataSource` → RevenueCat entitlements (full, z logIn/logOut)
4. `ConnectivityDataSource` → Network status

> W tym kroku (/auth) implementujemy WSZYSTKIE 4 źródła w pełni, w tym RC logIn/logOut sync z userId.

**Stream Pattern:**
```dart
authStateChanges
  .switchMap((user) => user == null
    ? Stream.value(UserSession.unauthenticated())
    : Rx.combineLatest3(profileStream, entitlementsStream, connectivityStream, ...)
  )
  .distinct()
```

**Error Handling:** Każde źródło samo obsługuje błędy i emituje fallback. `combineLatest` nigdy nie dostaje error.

**Offline Mode:** `isOffline` z connectivity stream. Write operations blocked gdy offline.

Szczegóły architektury: `docs/SESSION_ARCHITECTURE.md`
~~~

Na końcu kroku (finalizacja) zaktualizuj sekcję "▶ Co dalej" w CLAUDE.md:

~~~markdown
## ▶ Co dalej

**Następny krok:** `/limits` — LimitPolicy, UpgradeDialogs (Guest→Registered→Pro)
**Instrukcje:** `.claude/commands/limits.md`

> Wpisz `/limits` gdy będziesz gotowy!
~~~

Oraz sfinalizuj sekcję "## Session Architecture" w CLAUDE.md (usuń notki o "partial" / "dodane w /subscription"):

~~~markdown
> W tym kroku (/auth) implementujemy WSZYSTKIE 4 źródła w pełni, w tym RC logIn/logOut sync z userId.
~~~

---

> **Teraz kontynuuj z konfiguracją Supabase Dashboard:**

> 📖 Szczegóły: `.claude/skills/supabase-auth/SKILL.md` → sekcja "Wymagania Supabase Dashboard (MUST)"

Poproś usera:

```
Zanim zaczniemy implementować auth, skonfiguruj Supabase Dashboard:

1. Authentication → Providers → Email → **"Confirm email" = OFF**
2. Authentication → Providers → **Anonymous Sign-Ins = ON**
3. Authentication → Providers → **Manual Identity Linking (beta) = ON**

Jak gotowe, napisz "ok".
```

**CZEKAJ na potwierdzenie usera!** Nie przechodź dalej bez "ok".

---

## ⚠️ KRYTYCZNE: Anonymous → Email linking

> 📖 Pełny flow z kodem: `.claude/skills/supabase-auth/SKILL.md` → sekcja "Linking Anonymous → Permanent"

**TL;DR:**
```
❌ ŹLE:  signUpWithEmail() → tworzy NOWY user → UTRATA DANYCH!
✅ DOBRZE: updateUser(email, password) → linkuje do ISTNIEJĄCEGO usera
```

**W RegisterScreen ZAWSZE sprawdzaj:**
- `isAnonymous == true` → `linkEmailToAnonymous()` (używa `updateUser`)
- `currentUser == null` → `signUpWithEmail()`

## 0.5 Sync status z platformą

Wyślij PATCH do platformy z nowym statusem `in_progress`:

```bash
curl -X PATCH {API Base URL}/user/apps/{Platform App ID} \
  -H "X-API-Key: {API Key}" \
  -H "Content-Type: application/json" \
  -d '{"steps": [{"id": "{auth_step_id}", "status": "in_progress"}]}'
```

> Wartości `{API Base URL}`, `{Platform App ID}` odczytaj z CLAUDE.md, `{API Key}` z `.env`.

**Status:** `in-progress: datasource`

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/auth/auth-2-screens.md`

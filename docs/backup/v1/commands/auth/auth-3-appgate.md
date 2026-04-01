# KROK 3: Podpięcie Welcome Screen

Zamień placeholdery na prawdziwe akcje:

| Przycisk | Było | Ma być |
|----------|------|--------|
| "Rozpocznij" | placeholder/snackbar | `authCubit.signInAnonymously()` → Guided Onboarding |
| "Mam konto" | snackbar "Wkrótce" | `navigator.goToLogin()` |

**Status:** `in-progress: appgate`

---

# KROK 4: AppGate - pełna logika

> 📖 Wzorzec AuthGate: `.claude/skills/supabase-auth/SKILL.md` → sekcja "AuthGate Widget"

**Flow w tym template:**
```
AppGate
  ↓
Brak sesji → WelcomeScreen
  ↓
Jest sesja:
  1. profilesCubit.watchProfile(userId)  ← ZAWSZE PIERWSZE! Niezależnie od wyniku ensureProfile!
  2. await ensureProfile(userId)  ← ZAWSZE PRZED onboarding check!
  3. hasCompletedOnboarding?
     → NIE → OnboardingScreen
     → TAK → HomeScreen
```

**KRYTYCZNE:** `watchProfile()` MUSI startować PRZED `ensureProfile()` i NIEZALEŻNIE od jego wyniku. Jeśli `ensureProfile` zwróci błąd, `watchProfile` nadal musi nasłuchiwać - inaczej UI zostanie w stanie `initial` (wyświetlając `...` zamiast danych).

**WAŻNE:** `ensureProfile()` rozwiązuje problem: user z email z innego projektu (shared Supabase) nie ma profilu → bez tego = nieskończony onboarding.

**WAŻNE:** Callback w BlocConsumer/BlocListener zawierający async operacje MUSI być awaitowany (`await state.maybeWhen(...)`).

**Status:** `in-progress: profiles`

---

# KROK 5: Profiles Table

```sql
-- mcp__supabase__apply_migration name: create_profiles_table
-- UWAGA: BEZ kolumny tier! Tier jest computed w runtime
CREATE TABLE IF NOT EXISTS profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  first_name TEXT,
  last_name TEXT,
  avatar_url TEXT,
  has_completed_onboarding BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "users_own_profile" ON profiles
  FOR ALL USING (id = auth.uid()) WITH CHECK (id = auth.uid());
```

**ensureProfile() robi:**
1. Sprawdza czy profil istnieje w Supabase
2. Jeśli NIE → tworzy nowy (z migracją z LocalStorage jeśli są dane)
3. Czyści LocalStorage po migracji

**Status:** `in-progress: guest-migration`

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/auth/auth-4-migration.md`

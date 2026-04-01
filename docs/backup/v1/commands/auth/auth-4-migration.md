# KROK 6: Migracja danych gościa (link account)

> 📖 Szczegóły linkowania: `.claude/skills/supabase-auth/SKILL.md` → sekcja "Linking Anonymous → Permanent"

W Settings dodaj "Połącz konto" dla gości:
1. Pokazuje `LinkAccountDialog` (email + password)
2. Wywołuje `linkEmailToAnonymous(email, password)`
3. Dane zostają (ten sam `userId`!)
4. Tier automatycznie zmieni się na `registered` (computed z isAnonymous=false)

**Status:** `in-progress: settings`

---

# KROK 6.5: Zamień wszystkie hardcoded ID na prawdziwe auth

**⚠️ KRYTYCZNE:** Przeszukaj CAŁY projekt pod kątem hardcoded user ID:

```bash
grep -r "kDevUserId\|fake-user-id\|dev-user-001\|fake_user" lib/
```

**Każde wystąpienie** zamień na pobranie prawdziwego `userId` z `AuthCubit`:
```dart
// ❌ ŹLE
.updateName('fake-user-id', name);
.watchEntries(kDevUserId);

// ✅ DOBRZE
final userId = context.read<AuthCubit>().state.maybeMap(
  authenticated: (s) => s.user.id,
  orElse: () => '',
);
.updateName(userId, name);
```

**Sprawdź szczególnie:** Settings screen, Detail screens, Add/Edit screens - wszędzie gdzie cubit przyjmuje `userId`.

---

# KROK 7: Settings - działające opcje

**⚠️ KRYTYCZNE:** Settings MUSI mieć działające opcje, NIE snackbary "wkrótce"!

| Opcja | Akcja | Dialog? |
|-------|-------|---------|
| Wyloguj | `authCubit.signOut()` | ✅ potwierdzenie |
| Usuń konto | `authCubit.deleteAccount()` | ✅ destructive |
| Połącz konto (dla gości) | `LinkAccountDialog` | ✅ formularz |

**Aktualizuj RLS** - zamień tymczasowe na prawdziwe:
```sql
-- mcp__supabase__apply_migration name: update_rls_to_real_auth
DROP POLICY IF EXISTS "temp_dev_user_access" ON {prefix}_[tabela];
CREATE POLICY "users_own_items" ON {prefix}_[tabela]
  FOR ALL USING (user_id = auth.uid()) WITH CHECK (user_id = auth.uid());
```

**Status:** `in-progress: session`

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/auth/auth-5-session.md`

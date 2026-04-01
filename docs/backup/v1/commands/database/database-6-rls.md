# KROK 7: RLS Policies (tymczasowe)

## 7.1 Utwórz tymczasowe RLS

Na razie używamy hardcoded `kDevUserId`, więc RLS są uproszczone.

**WAŻNE:** Użyj nazwy tabeli z prefixem!

```
mcp__supabase__apply_migration

name: add_temp_rls_policies_{prefix}_{entities}
query: |
  -- Włącz RLS (nazwa tabeli z prefixem!)
  ALTER TABLE {prefix}_{entities} ENABLE ROW LEVEL SECURITY;

  -- Tymczasowa polityka dla dev-user-001
  -- UWAGA: To zostanie zmienione w /auth na prawdziwe auth.uid()
  CREATE POLICY "temp_dev_user_access" ON {prefix}_{entities}
    FOR ALL
    USING (user_id = 'dev-user-001')
    WITH CHECK (user_id = 'dev-user-001');

  -- Alternatywnie: pozwól anonimowemu dostępowi (mniej bezpieczne)
  -- CREATE POLICY "anon_access" ON {prefix}_{entities} FOR ALL USING (true);
```

## 7.2 Sprawdź bezpieczeństwo

```
mcp__supabase__get_advisors
type: security
```

## 7.3 Aktualizuj status

- Status `/database`: `in-progress: test`
- Kontekst: `RLS skonfigurowane, smoke test`

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/database/database-7-test-finalize.md`

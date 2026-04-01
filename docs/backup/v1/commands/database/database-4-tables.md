# KROK 4: Tworzenie tabel w Supabase

## 4.1 Przeczytaj schemat z CLAUDE.md

Przeczytaj sekcję "Database Schema" z `CLAUDE.md` - tam jest zaplanowana struktura tabel.
Schemat został stworzony w `/logic` i zawiera:
- Nazwy tabel (BEZ prefixu - prefix dodajesz TY!)
- Kolumny z typami PostgreSQL
- Constraints i foreign keys
- Planowane RLS policies

**WAŻNE:** Schemat w CLAUDE.md ma nazwy logiczne (np. `{entities}`).
Ty MUSISZ dodać prefix z KROK 3.1 → `{prefix}_{entities}`!

**Jeśli sekcja "Database Schema" nie istnieje** - przeczytaj modele z `lib/features/[feature]/models/` jako fallback.

## 4.2 Utwórz migrację (Z PREFIXEM!)

> **Parametryzacja:** Zastąp `{prefix}` prefixem z CLAUDE.md, `{entities}` nazwą encji z IDEA.md.

**Pamiętaj:** Nazwa tabeli = `{prefix}_` + nazwa ze schematu!

```
mcp__supabase__apply_migration

name: create_{prefix}_{entities}_table
query: |
  -- Tabela {prefix}_{entities} (prefix + nazwa ze schematu)
  CREATE TABLE IF NOT EXISTS {prefix}_{entities} (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    -- kolumny ze schematu z CLAUDE.md
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
  );

  -- Index na user_id (też z prefixem!)
  CREATE INDEX IF NOT EXISTS idx_{prefix}_{entities}_user_id
    ON {prefix}_{entities}(user_id);

  -- Trigger dla updated_at (nazwa funkcji z prefixem)
  CREATE OR REPLACE FUNCTION update_{prefix}_{entities}_updated_at()
  RETURNS TRIGGER AS $$
  BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
  END;
  $$ LANGUAGE plpgsql;

  CREATE TRIGGER {prefix}_{entities}_updated_at
    BEFORE UPDATE ON {prefix}_{entities}
    FOR EACH ROW
    EXECUTE FUNCTION update_{prefix}_{entities}_updated_at();
```

**Checklist przed CREATE TABLE:**
- [ ] Nazwa tabeli ma prefix? (`{prefix}_{entities}`, nie `{entities}`)
- [ ] Nazwa indexu ma prefix?
- [ ] Nazwa triggera/funkcji ma prefix?

## 4.3 Dodaj tabele do Supabase Realtime (KRYTYCZNE!)

**Bez tego realtime subscriptions w kodzie Dart NIE będą otrzymywać zdarzeń!**

```
mcp__supabase__apply_migration

name: enable_realtime_{prefix}_{entities}
query: |
  ALTER PUBLICATION supabase_realtime ADD TABLE {prefix}_{entities};
```

**Powtórz dla KAŻDEJ utworzonej tabeli** (domenowej i profiles gdy będzie w /auth).

## 4.4 Sprawdź tabele

```
mcp__supabase__list_tables
```

Upewnij się że tabela ma prefix (np. `{prefix}_{entities}`)!

## 4.5 Tabela `profiles` → tworzona w /auth

**UWAGA:** Tabela `profiles` jest tworzona w `/auth` (KROK 5), nie tutaj!

- Profiles są ściśle powiązane z autentykacją (auth.users FK)
- ensureProfile() jest częścią auth flow
- W /database tworzymy tylko tabele **domenowe** (z prefixem)

## 4.6 Aktualizuj status

- Status `/database`: `in-progress: datasource`
- Kontekst: `Tabele utworzone, tworzenie SupabaseDataSource`

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/database/database-5-devuser-datasource.md`

# KROK 1: Planowanie architektury

### 1.1 Przeczytaj IDEA.md

Przeczytaj `IDEA.md` — potrzebujesz:
- Sekcja "Złota Nisza" (co aplikacja robi, jaki problem rozwiązuje)
- Sekcja "Ekrany" (jakie dane wyświetlamy na poszczególnych ekranach)
- Sekcja "Home Screen" (co user widzi na głównym ekranie)

Na tej podstawie **sam zaprojektuj model danych** — jakie encje, jakie pola, jakie relacje.
Zapisz wynikowy model do IDEA.md (nowa sekcja "Model Danych" po "Złota Nisza").

### 1.2 Zaplanuj strukturę

Na podstawie zaprojektowanego modelu zaplanuj:
- Modele (freezed): `{Entity}Model`
- Repozytoria: `{Entity}Repository` + `{Entity}RepositoryImpl`
- DataSources: `{Entity}DataSource` + `Fake{Entity}DataSource`
- Cubity: `{Entities}Cubit`

### 1.3 Zaplanuj schemat Supabase

**Dla każdej tabeli określ:**
- Nazwa tabeli (snake_case, liczba mnoga)
- Kolumny z typami PostgreSQL
- Primary key, Foreign keys, Timestamps, Constraints

**RLS Policies (standardowe):**
- SELECT/INSERT/UPDATE/DELETE: `user_id = auth.uid()`

**Zapisz schemat w CLAUDE.md** (sekcja "Database Schema").

**WAŻNE:** Modele freezed (KROK 2) MUSZĄ być 1:1 zgodne z tym schematem!

### 1.4 Aktualizuj status

W `CLAUDE.md`:
- Status `/logic`: `in-progress: models`
- Kontekst: `Schemat zaplanowany, tworzenie modeli`

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/logic/logic-3-models.md`

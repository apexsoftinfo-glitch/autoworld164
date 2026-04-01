# KROK 3: Weryfikacja prefixu i istniejących tabel

## 3.1 Przeczytaj Table Prefix z CLAUDE.md (OBOWIĄZKOWE!)

**TO JEST KRYTYCZNE - NIE POMIJAJ!**

```
Read(CLAUDE.md)
```

Znajdź sekcję:
```markdown
## Konfiguracja aplikacji

- **Bundle ID:** com.jankowalski.myapp
- **App Display Name:** My App
- **App Package Name:** myapp
- **Table Prefix:** myapp_        ← TO JEST TWÓJ PREFIX
```

**Zapisz sobie ten prefix** - użyjesz go w KAŻDEJ nazwie tabeli!

Przykład: prefix `{prefix}_` → tabele: `{prefix}_{entities}`, `{prefix}_settings`, etc.

## 3.2 Sprawdź istniejące tabele

Użyj MCP aby sprawdzić co już istnieje w bazie:
```
mcp__supabase__list_tables
```

**Sprawdź:**
- Czy istnieją już tabele z tym prefixem? (np. poprzednia wersja aplikacji)
- Czy istnieje tabela `profiles`? (wspólna dla wszystkich aplikacji)

## 3.3 Obsłuż kolizje (jeśli są)

Jeśli tabele z tym prefixem już istnieją:
```
Widzę że istnieją już tabele z prefixem {prefix}:
- {lista_tabel}

Co chcesz zrobić?
1. Użyć istniejących tabel (kontynuować)
2. Usunąć stare i stworzyć nowe (reset)
3. Zmienić prefix na inny
```

## 3.4 Aktualizuj status

- Kontekst: `Prefix: {prefix}, tworzenie tabel`

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/database/database-4-tables.md`

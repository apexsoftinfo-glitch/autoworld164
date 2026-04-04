# Intro

Twoim zadaniem jako agenta AI jest zrealizowanie poniższych poleceń.

CEL: Zaktualizować placeholdery w AGENTS.md i CLAUDE.md

# Task

Zaktualizuj sekcję `## App Context` w `AGENTS.md`.

Podmień placeholder `<app_description>...</app_description>` na krótki opis aplikacji w `1-3` zdaniach.
Ten opis ma:
- krótko wyjaśniać, o czym jest aplikacja,
- być tylko skrótem, nie duplikatem pełnego dokumentu produktu,
- zawierać zdanie: `Pełny opis produktu znajduje się w pliku docs/IDEA.md.`

Znajdź też odniesienie odnośnie tabel Supabase i podmień `<supabase_table_prefix>` na ustalony `docs/IDEA.md` `__SUPABASE_TABLE_PREFIX__`.

Po zakończeniu edycji `AGENTS.md` skopiuj jego pełną zawartość do `CLAUDE.md` w katalogu głównym projektu, tak aby oba pliki były identyczne.

Zacommituj zmiany obu plików razem.

# Finish

Gdy odpowie "next", przejdź do wykonania polecenia zawartego w `docs/commands/01_start/07_start-platform-app-id.md`.

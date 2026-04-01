# KROK 0: Setup - Rozbuduj CLAUDE.md i sync z platformą

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

## 0.1 Sync status z platformą

Wyślij PATCH do platformy z nowym statusem `in_progress`:

```bash
curl -X PATCH {API Base URL}/user/apps/{Platform App ID} \
  -H "X-API-Key: {API Key}" \
  -H "Content-Type: application/json" \
  -d '{"steps": [{"id": "{home_step_id}", "status": "in_progress"}]}'
```

> Wartości `{API Base URL}`, `{Platform App ID}` odczytaj z CLAUDE.md, `{API Key}` z `.env`.

---

## 0.2 Dodaj regułę o widgetach

W sekcji "Zasady dla Agenta AI → ZAWSZE rób" dodaj:

```markdown
- **Widgety wydzielaj jako prywatne klasy (`class _MyWidget`)** zamiast metod `_buildSth()` — małe, fokusowane widgety w tym samym pliku. Metody `_build*()` są dopuszczalne TYLKO dla prostych fragmentów (1-2 widgety, bez logiki).
```

## 0.3 Dodaj sekcję Design System

Dodaj poniższą sekcję do CLAUDE.md (wstaw ją **przed** sekcją "## Backlog"):

### Sekcja: Design System (stub)

~~~markdown
## Design System

> **WAŻNE:** Wszystkie ekrany (onboarding, screens, dialogi) MUSZĄ używać tego stylu!

- **Wireframe:** [ustalone w /home - OPISOWY opis layoutu]
- **Design:** [ustalone w /design]
- **Vibe:** [ustalone w /design]
- **Paleta:** [ustalone w /design]
- **Typography:** [ustalone w /design]
- **Charakterystyka:** [ustalone w /design]

**Tokeny w kodzie:** `lib/shared/theme/` (app_colors.dart, app_typography.dart, app_spacing.dart)
~~~

Na końcu kroku (finalizacja) zaktualizuj sekcję "▶ Co dalej" w CLAUDE.md:

~~~markdown
## ▶ Co dalej

**Następny krok:** `/design` — 5 radykalnie różnych stylów
**Instrukcje:** `.claude/commands/design.md`

> Wpisz `/design` gdy będziesz gotowy!
~~~

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/home/home-1-discovery.md`

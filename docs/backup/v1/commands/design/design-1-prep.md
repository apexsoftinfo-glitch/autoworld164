# KROK 1: Przygotowanie

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

## KROK 0: Rozbuduj CLAUDE.md (PIERWSZE co robisz!)

Zaktualizuj sekcję "## Design System" w CLAUDE.md — wypełnij pola Design, Vibe, Paleta, Typography, Charakterystyka po wybraniu stylu przez usera.

Na końcu kroku (finalizacja) zaktualizuj sekcję "▶ Co dalej" w CLAUDE.md:

~~~markdown
## ▶ Co dalej

**Następny krok:** `/screens` — Reszta ekranów + Settings + shared components
**Instrukcje:** `.claude/commands/screens.md`

> Wpisz `/screens` gdy będziesz gotowy!
~~~

---

## 1.1 Sync status z platformą

Wyślij PATCH do platformy z nowym statusem `in_progress`:

```bash
curl -X PATCH {API Base URL}/user/apps/{Platform App ID} \
  -H "X-API-Key: {API Key}" \
  -H "Content-Type: application/json" \
  -d '{"steps": [{"id": "{design_step_id}", "status": "in_progress"}]}'
```

> Wartości `{API Base URL}`, `{Platform App ID}` odczytaj z CLAUDE.md, `{API Key}` z `.env`.

---

## 1.2 Przeczytaj wybrany wireframe

1. Przeczytaj `CLAUDE.md` - sekcja "Design System" → pole "Wireframe" (opis wybranego layoutu)
2. Przeczytaj kod wybranego wireframe'a z `lib/features/home/ui/variants/`

## 1.3 Aktualizuj status

W `CLAUDE.md`:
- Status `/design`: `in-progress: discovery`
- Kontekst: `Czekam na wizję stylistyczną`

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/design/design-2-discovery.md`

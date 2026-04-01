# KROK 1: Synchronizacja z platformą + Inwentaryzacja ekranów

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

Ten krok nie dodaje nowych sekcji do CLAUDE.md (korzysta z Design System z /design).

Na końcu kroku (finalizacja) zaktualizuj sekcję "▶ Co dalej" w CLAUDE.md:

~~~markdown
## ▶ Co dalej

**Następny krok:** `/logic` — Cubity + Repo + FakeDataSource + testy
**Instrukcje:** `.claude/commands/logic.md`

> Wpisz `/logic` gdy będziesz gotowy!
~~~

---

## 0.5 Sync status z platformą

Wyślij PATCH do platformy z nowym statusem `in_progress`:

```bash
curl -X PATCH {API Base URL}/user/apps/{Platform App ID} \
  -H "X-API-Key: {API Key}" \
  -H "Content-Type: application/json" \
  -d '{"steps": [{"id": "{screens_step_id}", "status": "in_progress"}]}'
```

> Wartości `{API Base URL}`, `{Platform App ID}` odczytaj z CLAUDE.md, `{API Key}` z `.env`.

---

## KROK 1: Inwentaryzacja ekranów

### 1.1 Przeczytaj IDEA.md

Przeczytaj sekcję "Ekrany" z `IDEA.md` - lista wszystkich ekranów.

### 1.2 Zidentyfikuj ekrany do zbudowania

Ekrany z priorytetem CORE (bez Welcome i Onboarding - to `/onboarding`):
- **Detail Screen** - szczegóły elementu
- **Add/Edit Screen** - formularz (może być jeden ekran)
- **Settings Screen** - ustawienia użytkownika

### 1.2b Zidentyfikuj Pro features z IDEA.md

Przeczytaj sekcję **"Paywall Content" → tabela "What's included"** (kolumna "Implementacja").

Dla każdego benefitu (poza #1 "zdjęcie limitu") zidentyfikuj:
- **Ekran Pro-only** (np. "Smart Insights" → nowy InsightsScreen z priorytetem MONETIZE)
- **Feature na istniejącym ekranie** (np. "Smart Sorting" → dropdown na Home, "Premium Themes" → toggle w Settings)

**Dodaj do listy ekranów:**
- Pro-only ekrany → zbudujesz je PO Settings (przed shared components)
- Pro features na istniejących ekranach → dodasz je przy budowaniu tych ekranów

**NA RAZIE nie gatujesz dostępu** — budujesz UI normalnie, oznaczasz `// PRO` w komentarzu.
Gating (`if (session.isPro)`) dodaje krok `/limits`.

### 1.3 Przeczytaj design tokens

Przeczytaj `lib/shared/theme/` - użyjesz tych samych tokenów co Home.

### 1.4 Aktualizuj status

W `CLAUDE.md`:
- Status `/screens`: `in-progress: detail`
- Kontekst: `Budowanie Detail Screen`

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/screens/screens-2-detail.md`

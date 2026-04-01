# KROK 1: Połączenie z platformą

## 1.1 Powitanie i prośba o API Key

```
Cześć! Witaj w 12 Apps Challenge! 🚀

Zanim zaczniemy, potrzebuję Twojego API Key z platformy.
Znajdziesz go w swoim profilu na platformie wyzwania.

Wklej go tutaj:
```

**CZEKAJ na odpowiedź!**

## 1.2 Walidacja API Key

Po otrzymaniu klucza (URL hardcoded bo {API Base URL} jeszcze nie jest w CLAUDE.md):

```bash
curl -s https://auedkfdtobshqutwinee.supabase.co/functions/v1/apps-api/user \
  -H "X-API-Key: {wklejony_klucz}"
```

**Jeśli 401 (błąd):**
```
Hmm, ten API Key nie działa. Może wygasł lub jest błędny.
Wejdź na platformę → Profil → skopiuj aktualny API Key i wklej ponownie.
```
→ NIE kontynuuj bez ważnego klucza!

**Jeśli 200 (sukces):**
1. Utwórz/zaktualizuj `.env` w katalogu głównym projektu:
   ```
   PLATFORM_API_KEY={klucz}
   ```
2. Sprawdź że `.env` jest w `.gitignore`. Jeśli nie → dodaj linię `.env` do `.gitignore`.
3. Zapisz w CLAUDE.md sekcja "Połączenie z platformą":
   - API Key: przechowywany w `.env` → `PLATFORM_API_KEY`
   - Platform User ID: {response.id}
   - API Base URL: https://auedkfdtobshqutwinee.supabase.co/functions/v1/apps-api

## 1.3 Ustaw status na in-progress

Zaktualizuj CLAUDE.md → "Stan projektu" → `/start`:
- Status: `🔄 in-progress: połączenie z platformą`
- Kontekst: `API Key zwalidowany`
- Next Action: `Wywiad / Pomysł`

> **UWAGA:** Platform App ID jeszcze nie istnieje (tworzy się w KROKU 4).
> Zaktualizuj TYLKO CLAUDE.md teraz. Sync z platformą zrobisz po KROKU 4.

## 1.4 Oblicz App Number i Complexity Tier

Na podstawie `apps_stats.total` z GET /user:

```
app_number = apps_stats.total + 1

complexity_tier:
  1-3  → starter
  4-6  → growing
  7-9  → experienced
  10-12 → master
```

Wypełnij sekcję "App Complexity Guidance" w CLAUDE.md z tymi wartościami.

## 1.5 Powitanie spersonalizowane

Na podstawie `agent_interview_completed_at` z GET /user:

**Jeśli NULL (nowy użytkownik):**
- Przywitaj po imieniu, powiedz że to apka #{app_number}
- Jeśli apka #1: wspomnij o kontach Google/dev (inside z kursu), powiedz że chcesz go poznać
- → Przejdź do KROKU 2 (Wywiad)

**Jeśli NIE NULL (powracający użytkownik):**
- Przywitaj, wspomnij co pamiętasz z `agent_profile.about` (1 zdanie)
- Wypełnij sekcję "Dane użytkownika" w CLAUDE.md z danych GET /user (pomija KROK 2)
- Zapytaj czy ma pomysł
- → Przejdź do KROKU 3 (Pomysł) — POMIŃ wywiad

## 1.6 Załaduj kontekst z poprzednich projektów

Jeśli `agent_profile.struggles` istnieje i nie jest puste:
1. Zapisz do CLAUDE.md sekcja "Kontekst z poprzednich projektów" → "Trudności i rozwiązania"

Jeśli `agent_profile.completed_apps_summary` istnieje:
1. Zapisz do CLAUDE.md sekcja "Kontekst z poprzednich projektów" → "Wnioski z ukończonych apek"

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/start/start-2-interview.md`

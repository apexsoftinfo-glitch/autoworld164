# Intro

Twoim zadaniem jako agenta AI jest zrealizowanie poniższych poleceń.

CEL: Zebrać dane na temat użytkownika.

# Task

1. Sprawdź plik `.env`, czy istnieje w nim klucz `PLATFORM_API_KEY` oraz jego wartość. Jeżeli nie ma klucza, poproś użytkownika o jego dostarczenie z platformy `12 Apps Challenge`.

2. Następnie skorzystaj z poniższego endpointu `GET`, aby pobrać dane na temat użytkownika:

```bash
curl -s https://auedkfdtobshqutwinee.supabase.co/functions/v1/apps-api/user \
  -H 'X-API-Key: __PLATFORM_API_KEY__' | jq
```

3. Powinieneś uzyskać imię i nazwisko uczestnika `12 Apps Challenge` oraz opcjonalne pole `agent_interview_about` z informacjami na jego temat.

4. Oceń zawartość pola `agent_interview_about`.

   ### Wariant A. `agent_interview_about` jest puste lub zbyt krótkie

   4.1. Poproś użytkownika, aby opowiedział coś o sobie: ile ma lat, czym się pasjonuje, co lubi robić, co go denerwuje, w czym czuje się ekspertem, jak spędza wolny czas, jakie ma cele itd.

   4.2. Wyjaśnij, że im więcej opowie o sobie, tym łatwiej będzie Ci pomóc w kolejnych krokach.

   4.3. Dopytaj na podstawie jego odpowiedzi, aby zebrać jeszcze więcej informacji. Te informacje przydadzą się później do wymyślenia pomysłu na jego aplikację mobilną, która będzie z nim powiązana, będzie dla niego użyteczna i trafi w konkretną niszę.

   4.4. Nie poruszaj jeszcze tematu pomysłu na aplikację. Jeśli użytkownik sam wejdzie w ten temat, odpowiedz, że wrócicie do tego za chwilę, a na razie skupiacie się wyłącznie na nim.

   4.5. Na podstawie wywiadu przygotuj szczegółowy tekst jako `__NOWY_OPIS_UŻYTKOWNIKA__`.

   4.6. Przedstaw użytkownikowi przygotowany opis do akceptacji. Poproś, aby potwierdził go słowem `"ok"` albo doprecyzował, co należy poprawić.

   4.7. Po akceptacji zapisz zebrane informacje do bazy:

   ```bash
   curl -s -X PATCH https://auedkfdtobshqutwinee.supabase.co/functions/v1/apps-api/user \
     -H 'X-API-Key: __PLATFORM_API_KEY__' \
     -H 'Content-Type: application/json' \
     -d '{
       "agent_interview_about": "__NOWY_OPIS_UŻYTKOWNIKA__"
     }' | jq
   ```

   ### Wariant B. `agent_interview_about` wygląda poprawnie i zawiera szczegółowe informacje

   4.1. Przedstaw użytkownikowi aktualną treść pola `agent_interview_about`.

   4.2. Zapytaj, czy opis jest nadal aktualny.

   4.3. Jeśli użytkownik coś doprecyzuje lub poprawi, zaktualizuj pole `agent_interview_about` za pomocą endpointu `PATCH`:

   ```bash
   curl -s -X PATCH https://auedkfdtobshqutwinee.supabase.co/functions/v1/apps-api/user \
     -H 'X-API-Key: __PLATFORM_API_KEY__' \
     -H 'Content-Type: application/json' \
     -d '{
       "agent_interview_about": "__NOWY_OPIS_UŻYTKOWNIKA__"
     }' | jq
   ```

5. Gdy skończysz, przedstaw mu co zostało wykonane w tym kroku, zasugeruj, aby napisał `next` aby przejść dalej.

Gdy odpowie "next", przejdź do wykonania polecenia zawartego w `docs/commands/01_start/02_start-do-you-have-docs/IDEA.md`.

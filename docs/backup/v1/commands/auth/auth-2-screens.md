# KROK 1: Auth Screens

**Skill:** `.claude/skills/flutter-ui/SKILL.md`

Stwórz ekrany w `lib/features/auth/ui/`:
- `login_screen.dart` - Email + Password + "Nie masz konta?" + "Zapomniałeś hasła?"
- `register_screen.dart` - Email + Password + Confirm + "Masz konto?"
- `reset_password_screen.dart` - Email + "Wróć do logowania"

**Wymagania:**
- Tokeny z `shared/theme/`
- Walidacja inline (NIE snackbar!)
- Light/dark mode
- Loading states na przyciskach

**Status:** `in-progress: datasource`

---

# KROK 2: SupabaseAuthDataSource

**Skill:** `.claude/skills/flutter-backend/SKILL.md`

> 📖 Architektura: `.claude/skills/supabase-auth/SKILL.md` → sekcje "AuthState" i "Struktura folderów"

**Interfejs do zaimplementowania:**
```dart
abstract class AuthDataSource {
  Stream<User?> get authStateChanges;
  User? get currentUser;
  Future<User> signInAnonymously();
  Future<User> signInWithEmail(String email, String password);
  Future<User> signUpWithEmail(String email, String password);
  Future<void> resetPassword(String email);
  Future<void> signOut();
  Future<User> linkEmailToAnonymous(String email, String password);
}
```

**Kluczowe:**
- `authStateChanges` → `_client.auth.onAuthStateChange.map((e) => e.session?.user)`
- `linkEmailToAnonymous()` → `_client.auth.updateUser(UserAttributes(email, password))`

**Status:** `in-progress: welcome`

---

> ✅ Ukończone → przeczytaj i wykonaj `.claude/commands/auth/auth-3-appgate.md`

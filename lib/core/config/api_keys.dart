/// API keys injected via --dart-define-from-file=config/api-keys.json.
///
/// Copy config/api-keys.template.json → config/api-keys.json and fill in values.
/// VS Code launch.json already passes --dart-define-from-file.
/// For CLI: flutter run --dart-define-from-file=config/api-keys.json
class ApiKeys {
  static const supabaseUrl = 'https://laapoqdayvmszqcijyob.supabase.co';
  static const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxhYXBvcWRheXZtc3pxY2lqeW9iIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NzEyMjUsImV4cCI6MjA4NzQ0NzIyNX0.p7jPG3VJXBF3qHAEITkMdPwm5bihk5OiZvWvFFd-WIY';
  static const revenueCatAppleApiKey = String.fromEnvironment(
    'REVENUECAT_APPLE_API_KEY',
  );
  static const revenueCatGoogleApiKey = String.fromEnvironment(
    'REVENUECAT_GOOGLE_API_KEY',
  );
}

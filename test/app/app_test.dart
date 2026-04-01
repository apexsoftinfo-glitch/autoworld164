import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/app/app.dart';
import 'package:myapp/app/ui/missing_supabase_keys_screen.dart';
import 'package:myapp/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('configures Flutter localizations on MaterialApp', (
    tester,
  ) async {
    await tester.pumpWidget(const App(hasSupabaseKeys: false));
    await tester.pump();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    final screenContext = tester.element(
      find.byType(MissingSupabaseKeysScreen),
    );

    expect(app.localizationsDelegates, AppLocalizations.localizationsDelegates);
    expect(app.supportedLocales, AppLocalizations.supportedLocales);
    expect(Localizations.localeOf(screenContext), const Locale('pl'));
    expect(AppLocalizations.of(screenContext), isNotNull);
  });
}

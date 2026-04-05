import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/features/home/ui/home_screen.dart';
import 'package:myapp/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('shows VIP Showcase dashboard elements', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const HomeScreen(),
      ),
    );
    await tester.pump();

    expect(find.text('MÓJ GARAŻ'), findsOneWidget);
    expect(find.text('NOWOŚCI'), findsOneWidget);
    expect(find.text('USTAWIENIA'), findsOneWidget);
    expect(find.text('DODAJ MODEL'), findsOneWidget);
  });
}

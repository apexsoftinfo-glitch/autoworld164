import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/features/home/ui/home_screen.dart';
import 'package:myapp/l10n/generated/app_localizations.dart';

import 'package:myapp/core/di/injection.dart';
import 'package:myapp/features/garage/presentation/cubit/cars_collection_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../support/mocks.dart';

void main() {
  setUp(() async {
    await getIt.reset();
    final mockCubit = MockCarsCollectionCubit();
    when(() => mockCubit.state).thenReturn(const CarsCollectionState.initial());
    when(() => mockCubit.stream).thenAnswer((_) => Stream.empty());
    when(() => mockCubit.close()).thenAnswer((_) async {});
    getIt.registerFactory<CarsCollectionCubit>(() => mockCubit);
  });
  
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

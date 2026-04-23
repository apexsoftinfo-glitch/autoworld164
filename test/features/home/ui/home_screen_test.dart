import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:autoworld164/features/home/ui/home_screen.dart';
import 'package:autoworld164/l10n/generated/app_localizations.dart';

import 'package:autoworld164/core/di/injection.dart';
import 'package:autoworld164/features/garage/presentation/cubit/cars_collection_cubit.dart';
import 'package:mocktail/mocktail.dart';

import 'package:autoworld164/features/settings/presentation/settings_cubit.dart';
import 'package:autoworld164/app/session/presentation/cubit/session_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../support/mocks.dart';

void main() {
  late MockSessionCubit mockSessionCubit;
  late MockSettingsCubit mockSettingsCubit;

  setUp(() async {
    await getIt.reset();
    
    mockSessionCubit = MockSessionCubit();
    final session = buildSessionModel(userId: 'test-user');
    when(() => mockSessionCubit.state).thenReturn(SessionState.authenticated(session: session));
    when(() => mockSessionCubit.stream).thenAnswer((_) => Stream.empty());
    when(() => mockSessionCubit.close()).thenAnswer((_) async {});
    getIt.registerFactory<SessionCubit>(() => mockSessionCubit);

    mockSettingsCubit = MockSettingsCubit();
    when(() => mockSettingsCubit.state).thenReturn(const SettingsState.initial());
    when(() => mockSettingsCubit.stream).thenAnswer((_) => Stream.empty());
    when(() => mockSettingsCubit.close()).thenAnswer((_) async {});
    getIt.registerFactory<SettingsCubit>(() => mockSettingsCubit);

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
        home: BlocProvider<SessionCubit>.value(
          value: mockSessionCubit,
          child: const HomeScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('MÓJ GARAŻ'), findsOneWidget);
    expect(find.text('NOWOŚCI'), findsOneWidget);
    expect(find.text('USTAWIENIA'), findsOneWidget);
    expect(find.text('DODAJ MODEL'), findsOneWidget);
  });
}

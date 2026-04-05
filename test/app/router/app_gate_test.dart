import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myapp/app/router/app_gate.dart';
import 'package:myapp/app/session/models/session_status_model.dart';
import 'package:myapp/app/session/presentation/cubit/session_cubit.dart';
import 'package:myapp/core/di/injection.dart';
import 'package:myapp/features/auth/presentation/cubit/welcome_cubit.dart';
import 'package:myapp/l10n/generated/app_localizations.dart';

import '../../support/mocks.dart';

void main() {
  late MockSessionRepository sessionRepository;
  late MockAuthRepository authRepository;
  late StreamController<SessionStatusModel> sessionController;

  setUp(() async {
    sessionRepository = MockSessionRepository();
    authRepository = MockAuthRepository();
    sessionController = StreamController<SessionStatusModel>();

    when(
      () => sessionRepository.sessionStream,
    ).thenAnswer((_) => sessionController.stream.cast());
    when(
      () => sessionRepository.current,
    ).thenReturn(const SessionStatusModel.loading());
    when(() => sessionRepository.refresh()).thenAnswer((_) async {});
    when(() => authRepository.continueAsGuest()).thenAnswer((_) async {});

    await getIt.reset();
    getIt.registerFactory<WelcomeCubit>(() => WelcomeCubit(authRepository));
  });

  tearDown(() async {
    await sessionController.close();
    await getIt.reset();
  });

  testWidgets('shows welcome when session is unauthenticated', (tester) async {
    final sessionCubit = SessionCubit(sessionRepository);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pl'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider<SessionCubit>.value(
          value: sessionCubit,
          child: const AppGate(),
        ),
      ),
    );
    sessionController.add(const SessionStatusModel.unauthenticated());
    await tester.pump();

    expect(find.text('Witaj'), findsOneWidget);
    expect(find.text('KONTYNUUJ JAKO GOŚĆ'), findsOneWidget);
  });

  testWidgets('shows loading before first session emission', (tester) async {
    final sessionCubit = SessionCubit(sessionRepository);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pl'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider<SessionCubit>.value(
          value: sessionCubit,
          child: const AppGate(),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Witaj'), findsNothing);
  });

  testWidgets('shows home when session is authenticated', (tester) async {
    final sessionCubit = SessionCubit(sessionRepository);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pl'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider<SessionCubit>.value(
          value: sessionCubit,
          child: const AppGate(),
        ),
      ),
    );
    sessionController.add(
      buildAuthenticatedSessionStatus(userId: 'guest-1', isAnonymous: true),
    );
    await tester.pump();

    expect(find.text('MÓJ GARAŻ'), findsOneWidget);
  });

  testWidgets('shows shared users setup screen for schema error', (
    tester,
  ) async {
    final sessionCubit = SessionCubit(sessionRepository);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pl'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider<SessionCubit>.value(
          value: sessionCubit,
          child: const AppGate(),
        ),
      ),
    );
    sessionController.addError(
      Exception(
        "Could not find the 'first_name' column of 'shared_users' in the schema cache",
      ),
    );
    await tester.pump();

    expect(find.textContaining('Brakuje tabeli'), findsOneWidget);
    expect(find.text('02_SUPABASE_SHARED_USERS_SETUP.md'), findsOneWidget);
  });
}

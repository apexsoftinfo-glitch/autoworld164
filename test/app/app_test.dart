import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:autoworld164/app/app.dart';
import 'package:autoworld164/app/locale/models/app_locale_option_model.dart';
import 'package:autoworld164/app/locale/presentation/cubit/app_locale_cubit.dart';
import 'package:autoworld164/app/ui/missing_supabase_keys_screen.dart';
import 'package:autoworld164/core/di/injection.dart';
import 'package:autoworld164/l10n/generated/app_localizations.dart';
import 'package:rxdart/rxdart.dart';

import '../support/mocks.dart';

void main() {
  late MockAppLocaleRepository appLocaleRepository;
  late BehaviorSubject<AppLocaleOptionModel> localeController;

  setUpAll(() {
    registerFallbackValue(AppLocaleOptionModel.system);
  });

  setUp(() async {
    appLocaleRepository = MockAppLocaleRepository();
    localeController = BehaviorSubject.seeded(AppLocaleOptionModel.system);

    when(() => appLocaleRepository.current).thenReturn(localeController.value);
    when(
      () => appLocaleRepository.localeStream,
    ).thenAnswer((_) => localeController.stream);
    when(() => appLocaleRepository.setLocaleOption(any())).thenAnswer((
      invocation,
    ) async {
      final option =
          invocation.positionalArguments.single as AppLocaleOptionModel;
      localeController.add(option);
    });

    await getIt.reset();
    getIt.registerLazySingleton<AppLocaleCubit>(
      () => AppLocaleCubit(appLocaleRepository),
    );
  });

  tearDown(() async {
    await localeController.close();
    await getIt.reset();
  });

  testWidgets('configures Flutter localizations on MaterialApp', (
    tester,
  ) async {
    tester.binding.platformDispatcher.localeTestValue = const Locale('pl');
    tester.binding.platformDispatcher.localesTestValue = const [Locale('pl')];
    addTearDown(tester.binding.platformDispatcher.clearLocaleTestValue);
    addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);

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

  testWidgets(
    'falls back to English for unsupported device locale in automatic mode',
    (tester) async {
      tester.binding.platformDispatcher.localeTestValue = const Locale('es');
      tester.binding.platformDispatcher.localesTestValue = const [Locale('es')];
      addTearDown(tester.binding.platformDispatcher.clearLocaleTestValue);
      addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);

      await tester.pumpWidget(const App(hasSupabaseKeys: false));
      await tester.pump();

      final screenContext = tester.element(
        find.byType(MissingSupabaseKeysScreen),
      );

      expect(Localizations.localeOf(screenContext), const Locale('en'));
    },
  );

  testWidgets('updates app locale when user preference changes', (
    tester,
  ) async {
    tester.binding.platformDispatcher.localeTestValue = const Locale('pl');
    tester.binding.platformDispatcher.localesTestValue = const [Locale('pl')];
    addTearDown(tester.binding.platformDispatcher.clearLocaleTestValue);
    addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);

    await tester.pumpWidget(const App(hasSupabaseKeys: false));
    await tester.pump();

    localeController.add(AppLocaleOptionModel.english);
    await tester.pump();
    await tester.pump();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    final screenContext = tester.element(
      find.byType(MissingSupabaseKeysScreen),
    );

    expect(app.locale, const Locale('en'));
    expect(Localizations.localeOf(screenContext), const Locale('en'));
  });
}

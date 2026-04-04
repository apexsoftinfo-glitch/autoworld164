import 'package:bloc_test/bloc_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myapp/app/locale/models/app_locale_option_model.dart';
import 'package:myapp/app/locale/presentation/cubit/app_locale_cubit.dart';

import '../../../../support/mocks.dart';

void main() {
  late MockAppLocaleRepository appLocaleRepository;
  late BehaviorSubject<AppLocaleOptionModel> localeController;

  setUpAll(() {
    registerFallbackValue(AppLocaleOptionModel.system);
  });

  setUp(() {
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
  });

  tearDown(() async {
    await localeController.close();
  });

  blocTest<AppLocaleCubit, AppLocaleState>(
    'emits new selected locale after repository stream update',
    build: () => AppLocaleCubit(appLocaleRepository),
    act: (_) => localeController.add(AppLocaleOptionModel.polish),
    expect: () => [
      const AppLocaleState.initial(selectedOption: AppLocaleOptionModel.polish),
    ],
  );

  blocTest<AppLocaleCubit, AppLocaleState>(
    'persists selected locale through repository',
    build: () => AppLocaleCubit(appLocaleRepository),
    act: (cubit) => cubit.selectLocale(AppLocaleOptionModel.english),
    expect: () => [
      const AppLocaleState.initial(
        selectedOption: AppLocaleOptionModel.system,
        isSaving: true,
      ),
      const AppLocaleState.initial(
        selectedOption: AppLocaleOptionModel.english,
      ),
    ],
    verify: (_) {
      verify(
        () => appLocaleRepository.setLocaleOption(AppLocaleOptionModel.english),
      ).called(1);
    },
  );
}

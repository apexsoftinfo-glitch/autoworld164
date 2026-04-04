import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/app/locale/data/datasources/app_locale_data_source.dart';
import 'package:myapp/app/locale/data/repositories/app_locale_repository.dart';
import 'package:myapp/app/locale/models/app_locale_option_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('defaults to system locale when nothing is saved', () async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final dataSource = SharedPreferencesAppLocaleDataSource(sharedPreferences);
    final repository = AppLocaleRepositoryImpl(dataSource);

    expect(repository.current, AppLocaleOptionModel.system);
  });

  test('restores saved locale from shared preferences', () async {
    SharedPreferences.setMockInitialValues({'selected_app_locale': 'pl'});

    final sharedPreferences = await SharedPreferences.getInstance();
    final dataSource = SharedPreferencesAppLocaleDataSource(sharedPreferences);
    final repository = AppLocaleRepositoryImpl(dataSource);

    expect(repository.current, AppLocaleOptionModel.polish);
  });

  test('persists selected locale and emits repository updates', () async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final dataSource = SharedPreferencesAppLocaleDataSource(sharedPreferences);
    final repository = AppLocaleRepositoryImpl(dataSource);

    final emittedOptions = <AppLocaleOptionModel>[];
    final subscription = repository.localeStream.listen(emittedOptions.add);

    await repository.setLocaleOption(AppLocaleOptionModel.english);
    await Future<void>.delayed(Duration.zero);

    expect(repository.current, AppLocaleOptionModel.english);
    expect(sharedPreferences.getString('selected_app_locale'), 'en');
    expect(emittedOptions, [
      AppLocaleOptionModel.system,
      AppLocaleOptionModel.english,
    ]);

    await subscription.cancel();
  });
}

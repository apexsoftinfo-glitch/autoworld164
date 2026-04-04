import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AppLocaleDataSource {
  String? readSelectedLocale();

  Future<void> saveSelectedLocale(String localeValue);
}

@LazySingleton(as: AppLocaleDataSource)
class SharedPreferencesAppLocaleDataSource implements AppLocaleDataSource {
  SharedPreferencesAppLocaleDataSource(this._sharedPreferences);

  static const _selectedLocaleKey = 'selected_app_locale';

  final SharedPreferences _sharedPreferences;

  @override
  String? readSelectedLocale() {
    return _sharedPreferences.getString(_selectedLocaleKey);
  }

  @override
  Future<void> saveSelectedLocale(String localeValue) async {
    await _sharedPreferences.setString(_selectedLocaleKey, localeValue);
  }
}

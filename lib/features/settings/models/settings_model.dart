import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_model.freezed.dart';
part 'settings_model.g.dart';

enum AppCurrency {
  pln,
  usd,
  eur;
}

enum AppLanguage {
  pl,
  en;
}

@freezed
abstract class SettingsModel with _$SettingsModel {
  const SettingsModel._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory SettingsModel({
    required String id,
    String? garageName,
    @Default(AppCurrency.usd) AppCurrency currency,
    @Default(AppLanguage.pl) AppLanguage language,
  }) = _SettingsModel;

  factory SettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);
}

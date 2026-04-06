// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SettingsModel _$SettingsModelFromJson(Map<String, dynamic> json) =>
    _SettingsModel(
      id: json['id'] as String,
      garageName: json['garage_name'] as String?,
      currency:
          $enumDecodeNullable(_$AppCurrencyEnumMap, json['currency']) ??
          AppCurrency.usd,
      language:
          $enumDecodeNullable(_$AppLanguageEnumMap, json['language']) ??
          AppLanguage.pl,
    );

Map<String, dynamic> _$SettingsModelToJson(_SettingsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'garage_name': instance.garageName,
      'currency': _$AppCurrencyEnumMap[instance.currency]!,
      'language': _$AppLanguageEnumMap[instance.language]!,
    };

const _$AppCurrencyEnumMap = {
  AppCurrency.pln: 'pln',
  AppCurrency.usd: 'usd',
  AppCurrency.eur: 'eur',
};

const _$AppLanguageEnumMap = {AppLanguage.pl: 'pl', AppLanguage.en: 'en'};

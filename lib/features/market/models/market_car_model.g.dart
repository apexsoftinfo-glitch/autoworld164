// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_car_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MarketCarModel _$MarketCarModelFromJson(Map<String, dynamic> json) =>
    _MarketCarModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      brand: json['brand'] as String,
      modelName: json['model_name'] as String,
      toyMaker: json['toy_maker'] as String?,
      series: json['series'] as String?,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      photoPaths:
          (json['photo_paths'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      status: json['status'] as String? ?? 'Nowy',
      isExchange: json['is_exchange'] as bool? ?? true,
      isSale: json['is_sale'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$MarketCarModelToJson(_MarketCarModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'brand': instance.brand,
      'model_name': instance.modelName,
      'toy_maker': instance.toyMaker,
      'series': instance.series,
      'price': instance.price,
      'photo_paths': instance.photoPaths,
      'status': instance.status,
      'is_exchange': instance.isExchange,
      'is_sale': instance.isSale,
      'created_at': instance.createdAt.toIso8601String(),
    };

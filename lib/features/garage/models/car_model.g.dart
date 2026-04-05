// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CarModel _$CarModelFromJson(Map<String, dynamic> json) => _CarModel(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  brand: json['brand'] as String,
  modelName: json['model_name'] as String,
  series: json['series'] as String?,
  purchasePrice: (json['purchase_price'] as num?)?.toDouble() ?? 0.0,
  estimatedValue: (json['estimated_value'] as num?)?.toDouble() ?? 0.0,
  photoPath: json['photo_path'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$CarModelToJson(_CarModel instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'brand': instance.brand,
  'model_name': instance.modelName,
  'series': instance.series,
  'purchase_price': instance.purchasePrice,
  'estimated_value': instance.estimatedValue,
  'photo_path': instance.photoPath,
  'created_at': instance.createdAt.toIso8601String(),
};

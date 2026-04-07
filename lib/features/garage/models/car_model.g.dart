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
  toyMaker: json['toy_maker'] as String?,
  series: json['series'] as String?,
  purchaseDate: json['purchase_date'] == null
      ? null
      : DateTime.parse(json['purchase_date'] as String),
  purchasePrice: (json['purchase_price'] as num?)?.toDouble() ?? 0.0,
  estimatedValue: (json['estimated_value'] as num?)?.toDouble() ?? 0.0,
  photoPath: json['photo_path'] as String?,
  photoPaths:
      (json['photo_paths'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  status: json['status'] as String? ?? 'Nowy',
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$CarModelToJson(_CarModel instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'brand': instance.brand,
  'model_name': instance.modelName,
  'toy_maker': instance.toyMaker,
  'series': instance.series,
  'purchase_date': instance.purchaseDate?.toIso8601String(),
  'purchase_price': instance.purchasePrice,
  'estimated_value': instance.estimatedValue,
  'photo_path': instance.photoPath,
  'photo_paths': instance.photoPaths,
  'status': instance.status,
  'created_at': instance.createdAt.toIso8601String(),
};

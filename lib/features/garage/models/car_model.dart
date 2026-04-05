import 'package:freezed_annotation/freezed_annotation.dart';

part 'car_model.freezed.dart';
part 'car_model.g.dart';

@freezed
abstract class CarModel with _$CarModel {
  const factory CarModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String brand,
    @JsonKey(name: 'model_name') required String modelName,
    String? series,
    @JsonKey(name: 'purchase_price') @Default(0.0) double purchasePrice,
    @JsonKey(name: 'estimated_value') @Default(0.0) double estimatedValue,
    @JsonKey(name: 'photo_path') String? photoPath,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _CarModel;

  factory CarModel.fromJson(Map<String, dynamic> json) =>
      _$CarModelFromJson(json);
}

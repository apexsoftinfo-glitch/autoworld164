import 'package:freezed_annotation/freezed_annotation.dart';

part 'market_car_model.freezed.dart';
part 'market_car_model.g.dart';

@freezed
abstract class MarketCarModel with _$MarketCarModel {
  const MarketCarModel._();
  const factory MarketCarModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String brand,
    @JsonKey(name: 'model_name') required String modelName,
    @JsonKey(name: 'toy_maker') String? toyMaker,
    String? series,
    String? notes,
    @Default(0.0) double price,
    @JsonKey(name: 'photo_paths') @Default([]) List<String> photoPaths,
    @Default('Nowy') String status,
    @JsonKey(name: 'is_exchange') @Default(true) bool isExchange,
    @JsonKey(name: 'is_sale') @Default(true) bool isSale,
    @JsonKey(name: 'is_auction') @Default(false) bool isAuction,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _MarketCarModel;

  factory MarketCarModel.fromJson(Map<String, dynamic> json) =>
      _$MarketCarModelFromJson(json);

  String? get displayPhotoPath => photoPaths.isNotEmpty ? photoPaths.first : null;
}

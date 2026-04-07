import 'package:freezed_annotation/freezed_annotation.dart';

part 'car_model.freezed.dart';
part 'car_model.g.dart';

@freezed
abstract class CarModel with _$CarModel {
  const CarModel._();
  const factory CarModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String brand,
    @JsonKey(name: 'model_name') required String modelName,
    @JsonKey(name: 'toy_maker') String? toyMaker,
    String? series,
    @JsonKey(name: 'purchase_date') DateTime? purchaseDate,
    @JsonKey(name: 'purchase_price') @Default(0.0) double purchasePrice,
    @JsonKey(name: 'estimated_value') @Default(0.0) double estimatedValue,
    @JsonKey(name: 'photo_path') String? photoPath,
    @JsonKey(name: 'photo_paths') @Default([]) List<String> photoPaths,
    @Default('Nowy') String status,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _CarModel;

  factory CarModel.fromJson(Map<String, dynamic> json) =>
      _$CarModelFromJson(json);

  String? get displayPhotoPath {
    if (photoPaths.isNotEmpty) return photoPaths.first;
    return photoPath;
  }

  List<String> get allPhotoPaths {
    final paths = <String>[...photoPaths];
    if (photoPath != null && !paths.contains(photoPath)) {
      paths.insert(0, photoPath!);
    }
    return paths;
  }
}



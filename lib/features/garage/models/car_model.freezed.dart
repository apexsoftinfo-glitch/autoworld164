// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'car_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CarModel {

 String get id;@JsonKey(name: 'user_id') String get userId; String get brand;@JsonKey(name: 'model_name') String get modelName;@JsonKey(name: 'toy_maker') String? get toyMaker; String? get series;@JsonKey(name: 'purchase_date') DateTime? get purchaseDate;@JsonKey(name: 'purchase_price') double get purchasePrice;@JsonKey(name: 'estimated_value') double get estimatedValue;@JsonKey(name: 'photo_path') String? get photoPath;@JsonKey(name: 'photo_paths') List<String> get photoPaths;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of CarModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CarModelCopyWith<CarModel> get copyWith => _$CarModelCopyWithImpl<CarModel>(this as CarModel, _$identity);

  /// Serializes this CarModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CarModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.modelName, modelName) || other.modelName == modelName)&&(identical(other.toyMaker, toyMaker) || other.toyMaker == toyMaker)&&(identical(other.series, series) || other.series == series)&&(identical(other.purchaseDate, purchaseDate) || other.purchaseDate == purchaseDate)&&(identical(other.purchasePrice, purchasePrice) || other.purchasePrice == purchasePrice)&&(identical(other.estimatedValue, estimatedValue) || other.estimatedValue == estimatedValue)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&const DeepCollectionEquality().equals(other.photoPaths, photoPaths)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,brand,modelName,toyMaker,series,purchaseDate,purchasePrice,estimatedValue,photoPath,const DeepCollectionEquality().hash(photoPaths),createdAt);

@override
String toString() {
  return 'CarModel(id: $id, userId: $userId, brand: $brand, modelName: $modelName, toyMaker: $toyMaker, series: $series, purchaseDate: $purchaseDate, purchasePrice: $purchasePrice, estimatedValue: $estimatedValue, photoPath: $photoPath, photoPaths: $photoPaths, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $CarModelCopyWith<$Res>  {
  factory $CarModelCopyWith(CarModel value, $Res Function(CarModel) _then) = _$CarModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, String brand,@JsonKey(name: 'model_name') String modelName,@JsonKey(name: 'toy_maker') String? toyMaker, String? series,@JsonKey(name: 'purchase_date') DateTime? purchaseDate,@JsonKey(name: 'purchase_price') double purchasePrice,@JsonKey(name: 'estimated_value') double estimatedValue,@JsonKey(name: 'photo_path') String? photoPath,@JsonKey(name: 'photo_paths') List<String> photoPaths,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$CarModelCopyWithImpl<$Res>
    implements $CarModelCopyWith<$Res> {
  _$CarModelCopyWithImpl(this._self, this._then);

  final CarModel _self;
  final $Res Function(CarModel) _then;

/// Create a copy of CarModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? brand = null,Object? modelName = null,Object? toyMaker = freezed,Object? series = freezed,Object? purchaseDate = freezed,Object? purchasePrice = null,Object? estimatedValue = null,Object? photoPath = freezed,Object? photoPaths = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,modelName: null == modelName ? _self.modelName : modelName // ignore: cast_nullable_to_non_nullable
as String,toyMaker: freezed == toyMaker ? _self.toyMaker : toyMaker // ignore: cast_nullable_to_non_nullable
as String?,series: freezed == series ? _self.series : series // ignore: cast_nullable_to_non_nullable
as String?,purchaseDate: freezed == purchaseDate ? _self.purchaseDate : purchaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,purchasePrice: null == purchasePrice ? _self.purchasePrice : purchasePrice // ignore: cast_nullable_to_non_nullable
as double,estimatedValue: null == estimatedValue ? _self.estimatedValue : estimatedValue // ignore: cast_nullable_to_non_nullable
as double,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,photoPaths: null == photoPaths ? _self.photoPaths : photoPaths // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CarModel].
extension CarModelPatterns on CarModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CarModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CarModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CarModel value)  $default,){
final _that = this;
switch (_that) {
case _CarModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CarModel value)?  $default,){
final _that = this;
switch (_that) {
case _CarModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  String brand, @JsonKey(name: 'model_name')  String modelName, @JsonKey(name: 'toy_maker')  String? toyMaker,  String? series, @JsonKey(name: 'purchase_date')  DateTime? purchaseDate, @JsonKey(name: 'purchase_price')  double purchasePrice, @JsonKey(name: 'estimated_value')  double estimatedValue, @JsonKey(name: 'photo_path')  String? photoPath, @JsonKey(name: 'photo_paths')  List<String> photoPaths, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CarModel() when $default != null:
return $default(_that.id,_that.userId,_that.brand,_that.modelName,_that.toyMaker,_that.series,_that.purchaseDate,_that.purchasePrice,_that.estimatedValue,_that.photoPath,_that.photoPaths,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  String brand, @JsonKey(name: 'model_name')  String modelName, @JsonKey(name: 'toy_maker')  String? toyMaker,  String? series, @JsonKey(name: 'purchase_date')  DateTime? purchaseDate, @JsonKey(name: 'purchase_price')  double purchasePrice, @JsonKey(name: 'estimated_value')  double estimatedValue, @JsonKey(name: 'photo_path')  String? photoPath, @JsonKey(name: 'photo_paths')  List<String> photoPaths, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _CarModel():
return $default(_that.id,_that.userId,_that.brand,_that.modelName,_that.toyMaker,_that.series,_that.purchaseDate,_that.purchasePrice,_that.estimatedValue,_that.photoPath,_that.photoPaths,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId,  String brand, @JsonKey(name: 'model_name')  String modelName, @JsonKey(name: 'toy_maker')  String? toyMaker,  String? series, @JsonKey(name: 'purchase_date')  DateTime? purchaseDate, @JsonKey(name: 'purchase_price')  double purchasePrice, @JsonKey(name: 'estimated_value')  double estimatedValue, @JsonKey(name: 'photo_path')  String? photoPath, @JsonKey(name: 'photo_paths')  List<String> photoPaths, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _CarModel() when $default != null:
return $default(_that.id,_that.userId,_that.brand,_that.modelName,_that.toyMaker,_that.series,_that.purchaseDate,_that.purchasePrice,_that.estimatedValue,_that.photoPath,_that.photoPaths,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CarModel implements CarModel {
  const _CarModel({required this.id, @JsonKey(name: 'user_id') required this.userId, required this.brand, @JsonKey(name: 'model_name') required this.modelName, @JsonKey(name: 'toy_maker') this.toyMaker, this.series, @JsonKey(name: 'purchase_date') this.purchaseDate, @JsonKey(name: 'purchase_price') this.purchasePrice = 0.0, @JsonKey(name: 'estimated_value') this.estimatedValue = 0.0, @JsonKey(name: 'photo_path') this.photoPath, @JsonKey(name: 'photo_paths') final  List<String> photoPaths = const [], @JsonKey(name: 'created_at') required this.createdAt}): _photoPaths = photoPaths;
  factory _CarModel.fromJson(Map<String, dynamic> json) => _$CarModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override final  String brand;
@override@JsonKey(name: 'model_name') final  String modelName;
@override@JsonKey(name: 'toy_maker') final  String? toyMaker;
@override final  String? series;
@override@JsonKey(name: 'purchase_date') final  DateTime? purchaseDate;
@override@JsonKey(name: 'purchase_price') final  double purchasePrice;
@override@JsonKey(name: 'estimated_value') final  double estimatedValue;
@override@JsonKey(name: 'photo_path') final  String? photoPath;
 final  List<String> _photoPaths;
@override@JsonKey(name: 'photo_paths') List<String> get photoPaths {
  if (_photoPaths is EqualUnmodifiableListView) return _photoPaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photoPaths);
}

@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of CarModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CarModelCopyWith<_CarModel> get copyWith => __$CarModelCopyWithImpl<_CarModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CarModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CarModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.modelName, modelName) || other.modelName == modelName)&&(identical(other.toyMaker, toyMaker) || other.toyMaker == toyMaker)&&(identical(other.series, series) || other.series == series)&&(identical(other.purchaseDate, purchaseDate) || other.purchaseDate == purchaseDate)&&(identical(other.purchasePrice, purchasePrice) || other.purchasePrice == purchasePrice)&&(identical(other.estimatedValue, estimatedValue) || other.estimatedValue == estimatedValue)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&const DeepCollectionEquality().equals(other._photoPaths, _photoPaths)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,brand,modelName,toyMaker,series,purchaseDate,purchasePrice,estimatedValue,photoPath,const DeepCollectionEquality().hash(_photoPaths),createdAt);

@override
String toString() {
  return 'CarModel(id: $id, userId: $userId, brand: $brand, modelName: $modelName, toyMaker: $toyMaker, series: $series, purchaseDate: $purchaseDate, purchasePrice: $purchasePrice, estimatedValue: $estimatedValue, photoPath: $photoPath, photoPaths: $photoPaths, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$CarModelCopyWith<$Res> implements $CarModelCopyWith<$Res> {
  factory _$CarModelCopyWith(_CarModel value, $Res Function(_CarModel) _then) = __$CarModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, String brand,@JsonKey(name: 'model_name') String modelName,@JsonKey(name: 'toy_maker') String? toyMaker, String? series,@JsonKey(name: 'purchase_date') DateTime? purchaseDate,@JsonKey(name: 'purchase_price') double purchasePrice,@JsonKey(name: 'estimated_value') double estimatedValue,@JsonKey(name: 'photo_path') String? photoPath,@JsonKey(name: 'photo_paths') List<String> photoPaths,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$CarModelCopyWithImpl<$Res>
    implements _$CarModelCopyWith<$Res> {
  __$CarModelCopyWithImpl(this._self, this._then);

  final _CarModel _self;
  final $Res Function(_CarModel) _then;

/// Create a copy of CarModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? brand = null,Object? modelName = null,Object? toyMaker = freezed,Object? series = freezed,Object? purchaseDate = freezed,Object? purchasePrice = null,Object? estimatedValue = null,Object? photoPath = freezed,Object? photoPaths = null,Object? createdAt = null,}) {
  return _then(_CarModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,modelName: null == modelName ? _self.modelName : modelName // ignore: cast_nullable_to_non_nullable
as String,toyMaker: freezed == toyMaker ? _self.toyMaker : toyMaker // ignore: cast_nullable_to_non_nullable
as String?,series: freezed == series ? _self.series : series // ignore: cast_nullable_to_non_nullable
as String?,purchaseDate: freezed == purchaseDate ? _self.purchaseDate : purchaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,purchasePrice: null == purchasePrice ? _self.purchasePrice : purchasePrice // ignore: cast_nullable_to_non_nullable
as double,estimatedValue: null == estimatedValue ? _self.estimatedValue : estimatedValue // ignore: cast_nullable_to_non_nullable
as double,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,photoPaths: null == photoPaths ? _self._photoPaths : photoPaths // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on

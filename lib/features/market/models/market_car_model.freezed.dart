// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'market_car_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MarketCarModel {

 String get id;@JsonKey(name: 'user_id') String get userId; String get brand;@JsonKey(name: 'model_name') String get modelName;@JsonKey(name: 'toy_maker') String? get toyMaker; String? get series; String? get notes; double get price;@JsonKey(name: 'photo_paths') List<String> get photoPaths; String get status;@JsonKey(name: 'is_exchange') bool get isExchange;@JsonKey(name: 'is_sale') bool get isSale;@JsonKey(name: 'is_auction') bool get isAuction;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of MarketCarModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarketCarModelCopyWith<MarketCarModel> get copyWith => _$MarketCarModelCopyWithImpl<MarketCarModel>(this as MarketCarModel, _$identity);

  /// Serializes this MarketCarModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketCarModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.modelName, modelName) || other.modelName == modelName)&&(identical(other.toyMaker, toyMaker) || other.toyMaker == toyMaker)&&(identical(other.series, series) || other.series == series)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.price, price) || other.price == price)&&const DeepCollectionEquality().equals(other.photoPaths, photoPaths)&&(identical(other.status, status) || other.status == status)&&(identical(other.isExchange, isExchange) || other.isExchange == isExchange)&&(identical(other.isSale, isSale) || other.isSale == isSale)&&(identical(other.isAuction, isAuction) || other.isAuction == isAuction)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,brand,modelName,toyMaker,series,notes,price,const DeepCollectionEquality().hash(photoPaths),status,isExchange,isSale,isAuction,createdAt);

@override
String toString() {
  return 'MarketCarModel(id: $id, userId: $userId, brand: $brand, modelName: $modelName, toyMaker: $toyMaker, series: $series, notes: $notes, price: $price, photoPaths: $photoPaths, status: $status, isExchange: $isExchange, isSale: $isSale, isAuction: $isAuction, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $MarketCarModelCopyWith<$Res>  {
  factory $MarketCarModelCopyWith(MarketCarModel value, $Res Function(MarketCarModel) _then) = _$MarketCarModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, String brand,@JsonKey(name: 'model_name') String modelName,@JsonKey(name: 'toy_maker') String? toyMaker, String? series, String? notes, double price,@JsonKey(name: 'photo_paths') List<String> photoPaths, String status,@JsonKey(name: 'is_exchange') bool isExchange,@JsonKey(name: 'is_sale') bool isSale,@JsonKey(name: 'is_auction') bool isAuction,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$MarketCarModelCopyWithImpl<$Res>
    implements $MarketCarModelCopyWith<$Res> {
  _$MarketCarModelCopyWithImpl(this._self, this._then);

  final MarketCarModel _self;
  final $Res Function(MarketCarModel) _then;

/// Create a copy of MarketCarModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? brand = null,Object? modelName = null,Object? toyMaker = freezed,Object? series = freezed,Object? notes = freezed,Object? price = null,Object? photoPaths = null,Object? status = null,Object? isExchange = null,Object? isSale = null,Object? isAuction = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,modelName: null == modelName ? _self.modelName : modelName // ignore: cast_nullable_to_non_nullable
as String,toyMaker: freezed == toyMaker ? _self.toyMaker : toyMaker // ignore: cast_nullable_to_non_nullable
as String?,series: freezed == series ? _self.series : series // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,photoPaths: null == photoPaths ? _self.photoPaths : photoPaths // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isExchange: null == isExchange ? _self.isExchange : isExchange // ignore: cast_nullable_to_non_nullable
as bool,isSale: null == isSale ? _self.isSale : isSale // ignore: cast_nullable_to_non_nullable
as bool,isAuction: null == isAuction ? _self.isAuction : isAuction // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [MarketCarModel].
extension MarketCarModelPatterns on MarketCarModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MarketCarModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MarketCarModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MarketCarModel value)  $default,){
final _that = this;
switch (_that) {
case _MarketCarModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MarketCarModel value)?  $default,){
final _that = this;
switch (_that) {
case _MarketCarModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  String brand, @JsonKey(name: 'model_name')  String modelName, @JsonKey(name: 'toy_maker')  String? toyMaker,  String? series,  String? notes,  double price, @JsonKey(name: 'photo_paths')  List<String> photoPaths,  String status, @JsonKey(name: 'is_exchange')  bool isExchange, @JsonKey(name: 'is_sale')  bool isSale, @JsonKey(name: 'is_auction')  bool isAuction, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MarketCarModel() when $default != null:
return $default(_that.id,_that.userId,_that.brand,_that.modelName,_that.toyMaker,_that.series,_that.notes,_that.price,_that.photoPaths,_that.status,_that.isExchange,_that.isSale,_that.isAuction,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId,  String brand, @JsonKey(name: 'model_name')  String modelName, @JsonKey(name: 'toy_maker')  String? toyMaker,  String? series,  String? notes,  double price, @JsonKey(name: 'photo_paths')  List<String> photoPaths,  String status, @JsonKey(name: 'is_exchange')  bool isExchange, @JsonKey(name: 'is_sale')  bool isSale, @JsonKey(name: 'is_auction')  bool isAuction, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _MarketCarModel():
return $default(_that.id,_that.userId,_that.brand,_that.modelName,_that.toyMaker,_that.series,_that.notes,_that.price,_that.photoPaths,_that.status,_that.isExchange,_that.isSale,_that.isAuction,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId,  String brand, @JsonKey(name: 'model_name')  String modelName, @JsonKey(name: 'toy_maker')  String? toyMaker,  String? series,  String? notes,  double price, @JsonKey(name: 'photo_paths')  List<String> photoPaths,  String status, @JsonKey(name: 'is_exchange')  bool isExchange, @JsonKey(name: 'is_sale')  bool isSale, @JsonKey(name: 'is_auction')  bool isAuction, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _MarketCarModel() when $default != null:
return $default(_that.id,_that.userId,_that.brand,_that.modelName,_that.toyMaker,_that.series,_that.notes,_that.price,_that.photoPaths,_that.status,_that.isExchange,_that.isSale,_that.isAuction,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MarketCarModel extends MarketCarModel {
  const _MarketCarModel({required this.id, @JsonKey(name: 'user_id') required this.userId, required this.brand, @JsonKey(name: 'model_name') required this.modelName, @JsonKey(name: 'toy_maker') this.toyMaker, this.series, this.notes, this.price = 0.0, @JsonKey(name: 'photo_paths') final  List<String> photoPaths = const [], this.status = 'Nowy', @JsonKey(name: 'is_exchange') this.isExchange = true, @JsonKey(name: 'is_sale') this.isSale = true, @JsonKey(name: 'is_auction') this.isAuction = false, @JsonKey(name: 'created_at') required this.createdAt}): _photoPaths = photoPaths,super._();
  factory _MarketCarModel.fromJson(Map<String, dynamic> json) => _$MarketCarModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override final  String brand;
@override@JsonKey(name: 'model_name') final  String modelName;
@override@JsonKey(name: 'toy_maker') final  String? toyMaker;
@override final  String? series;
@override final  String? notes;
@override@JsonKey() final  double price;
 final  List<String> _photoPaths;
@override@JsonKey(name: 'photo_paths') List<String> get photoPaths {
  if (_photoPaths is EqualUnmodifiableListView) return _photoPaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photoPaths);
}

@override@JsonKey() final  String status;
@override@JsonKey(name: 'is_exchange') final  bool isExchange;
@override@JsonKey(name: 'is_sale') final  bool isSale;
@override@JsonKey(name: 'is_auction') final  bool isAuction;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of MarketCarModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MarketCarModelCopyWith<_MarketCarModel> get copyWith => __$MarketCarModelCopyWithImpl<_MarketCarModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MarketCarModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MarketCarModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.modelName, modelName) || other.modelName == modelName)&&(identical(other.toyMaker, toyMaker) || other.toyMaker == toyMaker)&&(identical(other.series, series) || other.series == series)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.price, price) || other.price == price)&&const DeepCollectionEquality().equals(other._photoPaths, _photoPaths)&&(identical(other.status, status) || other.status == status)&&(identical(other.isExchange, isExchange) || other.isExchange == isExchange)&&(identical(other.isSale, isSale) || other.isSale == isSale)&&(identical(other.isAuction, isAuction) || other.isAuction == isAuction)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,brand,modelName,toyMaker,series,notes,price,const DeepCollectionEquality().hash(_photoPaths),status,isExchange,isSale,isAuction,createdAt);

@override
String toString() {
  return 'MarketCarModel(id: $id, userId: $userId, brand: $brand, modelName: $modelName, toyMaker: $toyMaker, series: $series, notes: $notes, price: $price, photoPaths: $photoPaths, status: $status, isExchange: $isExchange, isSale: $isSale, isAuction: $isAuction, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$MarketCarModelCopyWith<$Res> implements $MarketCarModelCopyWith<$Res> {
  factory _$MarketCarModelCopyWith(_MarketCarModel value, $Res Function(_MarketCarModel) _then) = __$MarketCarModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId, String brand,@JsonKey(name: 'model_name') String modelName,@JsonKey(name: 'toy_maker') String? toyMaker, String? series, String? notes, double price,@JsonKey(name: 'photo_paths') List<String> photoPaths, String status,@JsonKey(name: 'is_exchange') bool isExchange,@JsonKey(name: 'is_sale') bool isSale,@JsonKey(name: 'is_auction') bool isAuction,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$MarketCarModelCopyWithImpl<$Res>
    implements _$MarketCarModelCopyWith<$Res> {
  __$MarketCarModelCopyWithImpl(this._self, this._then);

  final _MarketCarModel _self;
  final $Res Function(_MarketCarModel) _then;

/// Create a copy of MarketCarModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? brand = null,Object? modelName = null,Object? toyMaker = freezed,Object? series = freezed,Object? notes = freezed,Object? price = null,Object? photoPaths = null,Object? status = null,Object? isExchange = null,Object? isSale = null,Object? isAuction = null,Object? createdAt = null,}) {
  return _then(_MarketCarModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,modelName: null == modelName ? _self.modelName : modelName // ignore: cast_nullable_to_non_nullable
as String,toyMaker: freezed == toyMaker ? _self.toyMaker : toyMaker // ignore: cast_nullable_to_non_nullable
as String?,series: freezed == series ? _self.series : series // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,photoPaths: null == photoPaths ? _self._photoPaths : photoPaths // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isExchange: null == isExchange ? _self.isExchange : isExchange // ignore: cast_nullable_to_non_nullable
as bool,isSale: null == isSale ? _self.isSale : isSale // ignore: cast_nullable_to_non_nullable
as bool,isAuction: null == isAuction ? _self.isAuction : isAuction // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cars_collection_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CarsCollectionState implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CarsCollectionState'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CarsCollectionState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CarsCollectionState()';
}


}

/// @nodoc
class $CarsCollectionStateCopyWith<$Res>  {
$CarsCollectionStateCopyWith(CarsCollectionState _, $Res Function(CarsCollectionState) __);
}


/// Adds pattern-matching-related methods to [CarsCollectionState].
extension CarsCollectionStatePatterns on CarsCollectionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CarsCollectionInitial value)?  initial,TResult Function( CarsCollectionLoading value)?  loading,TResult Function( CarsCollectionError value)?  error,TResult Function( CarsCollectionData value)?  data,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CarsCollectionInitial() when initial != null:
return initial(_that);case CarsCollectionLoading() when loading != null:
return loading(_that);case CarsCollectionError() when error != null:
return error(_that);case CarsCollectionData() when data != null:
return data(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CarsCollectionInitial value)  initial,required TResult Function( CarsCollectionLoading value)  loading,required TResult Function( CarsCollectionError value)  error,required TResult Function( CarsCollectionData value)  data,}){
final _that = this;
switch (_that) {
case CarsCollectionInitial():
return initial(_that);case CarsCollectionLoading():
return loading(_that);case CarsCollectionError():
return error(_that);case CarsCollectionData():
return data(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CarsCollectionInitial value)?  initial,TResult? Function( CarsCollectionLoading value)?  loading,TResult? Function( CarsCollectionError value)?  error,TResult? Function( CarsCollectionData value)?  data,}){
final _that = this;
switch (_that) {
case CarsCollectionInitial() when initial != null:
return initial(_that);case CarsCollectionLoading() when loading != null:
return loading(_that);case CarsCollectionError() when error != null:
return error(_that);case CarsCollectionData() when data != null:
return data(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( String errorKey)?  error,TResult Function( List<CarModel> cars,  double totalPurchasePrice,  double totalEstimatedValue)?  data,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CarsCollectionInitial() when initial != null:
return initial();case CarsCollectionLoading() when loading != null:
return loading();case CarsCollectionError() when error != null:
return error(_that.errorKey);case CarsCollectionData() when data != null:
return data(_that.cars,_that.totalPurchasePrice,_that.totalEstimatedValue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( String errorKey)  error,required TResult Function( List<CarModel> cars,  double totalPurchasePrice,  double totalEstimatedValue)  data,}) {final _that = this;
switch (_that) {
case CarsCollectionInitial():
return initial();case CarsCollectionLoading():
return loading();case CarsCollectionError():
return error(_that.errorKey);case CarsCollectionData():
return data(_that.cars,_that.totalPurchasePrice,_that.totalEstimatedValue);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( String errorKey)?  error,TResult? Function( List<CarModel> cars,  double totalPurchasePrice,  double totalEstimatedValue)?  data,}) {final _that = this;
switch (_that) {
case CarsCollectionInitial() when initial != null:
return initial();case CarsCollectionLoading() when loading != null:
return loading();case CarsCollectionError() when error != null:
return error(_that.errorKey);case CarsCollectionData() when data != null:
return data(_that.cars,_that.totalPurchasePrice,_that.totalEstimatedValue);case _:
  return null;

}
}

}

/// @nodoc


class CarsCollectionInitial with DiagnosticableTreeMixin implements CarsCollectionState {
  const CarsCollectionInitial();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CarsCollectionState.initial'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CarsCollectionInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CarsCollectionState.initial()';
}


}




/// @nodoc


class CarsCollectionLoading with DiagnosticableTreeMixin implements CarsCollectionState {
  const CarsCollectionLoading();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CarsCollectionState.loading'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CarsCollectionLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CarsCollectionState.loading()';
}


}




/// @nodoc


class CarsCollectionError with DiagnosticableTreeMixin implements CarsCollectionState {
  const CarsCollectionError(this.errorKey);
  

 final  String errorKey;

/// Create a copy of CarsCollectionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CarsCollectionErrorCopyWith<CarsCollectionError> get copyWith => _$CarsCollectionErrorCopyWithImpl<CarsCollectionError>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CarsCollectionState.error'))
    ..add(DiagnosticsProperty('errorKey', errorKey));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CarsCollectionError&&(identical(other.errorKey, errorKey) || other.errorKey == errorKey));
}


@override
int get hashCode => Object.hash(runtimeType,errorKey);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CarsCollectionState.error(errorKey: $errorKey)';
}


}

/// @nodoc
abstract mixin class $CarsCollectionErrorCopyWith<$Res> implements $CarsCollectionStateCopyWith<$Res> {
  factory $CarsCollectionErrorCopyWith(CarsCollectionError value, $Res Function(CarsCollectionError) _then) = _$CarsCollectionErrorCopyWithImpl;
@useResult
$Res call({
 String errorKey
});




}
/// @nodoc
class _$CarsCollectionErrorCopyWithImpl<$Res>
    implements $CarsCollectionErrorCopyWith<$Res> {
  _$CarsCollectionErrorCopyWithImpl(this._self, this._then);

  final CarsCollectionError _self;
  final $Res Function(CarsCollectionError) _then;

/// Create a copy of CarsCollectionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? errorKey = null,}) {
  return _then(CarsCollectionError(
null == errorKey ? _self.errorKey : errorKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class CarsCollectionData with DiagnosticableTreeMixin implements CarsCollectionState {
  const CarsCollectionData({required final  List<CarModel> cars, required this.totalPurchasePrice, required this.totalEstimatedValue}): _cars = cars;
  

 final  List<CarModel> _cars;
 List<CarModel> get cars {
  if (_cars is EqualUnmodifiableListView) return _cars;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cars);
}

 final  double totalPurchasePrice;
 final  double totalEstimatedValue;

/// Create a copy of CarsCollectionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CarsCollectionDataCopyWith<CarsCollectionData> get copyWith => _$CarsCollectionDataCopyWithImpl<CarsCollectionData>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CarsCollectionState.data'))
    ..add(DiagnosticsProperty('cars', cars))..add(DiagnosticsProperty('totalPurchasePrice', totalPurchasePrice))..add(DiagnosticsProperty('totalEstimatedValue', totalEstimatedValue));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CarsCollectionData&&const DeepCollectionEquality().equals(other._cars, _cars)&&(identical(other.totalPurchasePrice, totalPurchasePrice) || other.totalPurchasePrice == totalPurchasePrice)&&(identical(other.totalEstimatedValue, totalEstimatedValue) || other.totalEstimatedValue == totalEstimatedValue));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_cars),totalPurchasePrice,totalEstimatedValue);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CarsCollectionState.data(cars: $cars, totalPurchasePrice: $totalPurchasePrice, totalEstimatedValue: $totalEstimatedValue)';
}


}

/// @nodoc
abstract mixin class $CarsCollectionDataCopyWith<$Res> implements $CarsCollectionStateCopyWith<$Res> {
  factory $CarsCollectionDataCopyWith(CarsCollectionData value, $Res Function(CarsCollectionData) _then) = _$CarsCollectionDataCopyWithImpl;
@useResult
$Res call({
 List<CarModel> cars, double totalPurchasePrice, double totalEstimatedValue
});




}
/// @nodoc
class _$CarsCollectionDataCopyWithImpl<$Res>
    implements $CarsCollectionDataCopyWith<$Res> {
  _$CarsCollectionDataCopyWithImpl(this._self, this._then);

  final CarsCollectionData _self;
  final $Res Function(CarsCollectionData) _then;

/// Create a copy of CarsCollectionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? cars = null,Object? totalPurchasePrice = null,Object? totalEstimatedValue = null,}) {
  return _then(CarsCollectionData(
cars: null == cars ? _self._cars : cars // ignore: cast_nullable_to_non_nullable
as List<CarModel>,totalPurchasePrice: null == totalPurchasePrice ? _self.totalPurchasePrice : totalPurchasePrice // ignore: cast_nullable_to_non_nullable
as double,totalEstimatedValue: null == totalEstimatedValue ? _self.totalEstimatedValue : totalEstimatedValue // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on

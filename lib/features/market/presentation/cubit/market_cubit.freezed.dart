// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'market_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MarketState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MarketState()';
}


}

/// @nodoc
class $MarketStateCopyWith<$Res>  {
$MarketStateCopyWith(MarketState _, $Res Function(MarketState) __);
}


/// Adds pattern-matching-related methods to [MarketState].
extension MarketStatePatterns on MarketState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MarketInitial value)?  initial,TResult Function( MarketLoading value)?  loading,TResult Function( MarketData value)?  data,TResult Function( MarketError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MarketInitial() when initial != null:
return initial(_that);case MarketLoading() when loading != null:
return loading(_that);case MarketData() when data != null:
return data(_that);case MarketError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MarketInitial value)  initial,required TResult Function( MarketLoading value)  loading,required TResult Function( MarketData value)  data,required TResult Function( MarketError value)  error,}){
final _that = this;
switch (_that) {
case MarketInitial():
return initial(_that);case MarketLoading():
return loading(_that);case MarketData():
return data(_that);case MarketError():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MarketInitial value)?  initial,TResult? Function( MarketLoading value)?  loading,TResult? Function( MarketData value)?  data,TResult? Function( MarketError value)?  error,}){
final _that = this;
switch (_that) {
case MarketInitial() when initial != null:
return initial(_that);case MarketLoading() when loading != null:
return loading(_that);case MarketData() when data != null:
return data(_that);case MarketError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<MarketCarModel> cars,  List<MarketCarModel> filteredCars,  String query,  CollectionViewType viewType,  SortType sortType,  SortOrder sortOrder)?  data,TResult Function( String errorKey)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MarketInitial() when initial != null:
return initial();case MarketLoading() when loading != null:
return loading();case MarketData() when data != null:
return data(_that.cars,_that.filteredCars,_that.query,_that.viewType,_that.sortType,_that.sortOrder);case MarketError() when error != null:
return error(_that.errorKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<MarketCarModel> cars,  List<MarketCarModel> filteredCars,  String query,  CollectionViewType viewType,  SortType sortType,  SortOrder sortOrder)  data,required TResult Function( String errorKey)  error,}) {final _that = this;
switch (_that) {
case MarketInitial():
return initial();case MarketLoading():
return loading();case MarketData():
return data(_that.cars,_that.filteredCars,_that.query,_that.viewType,_that.sortType,_that.sortOrder);case MarketError():
return error(_that.errorKey);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<MarketCarModel> cars,  List<MarketCarModel> filteredCars,  String query,  CollectionViewType viewType,  SortType sortType,  SortOrder sortOrder)?  data,TResult? Function( String errorKey)?  error,}) {final _that = this;
switch (_that) {
case MarketInitial() when initial != null:
return initial();case MarketLoading() when loading != null:
return loading();case MarketData() when data != null:
return data(_that.cars,_that.filteredCars,_that.query,_that.viewType,_that.sortType,_that.sortOrder);case MarketError() when error != null:
return error(_that.errorKey);case _:
  return null;

}
}

}

/// @nodoc


class MarketInitial implements MarketState {
  const MarketInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MarketState.initial()';
}


}




/// @nodoc


class MarketLoading implements MarketState {
  const MarketLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MarketState.loading()';
}


}




/// @nodoc


class MarketData implements MarketState {
  const MarketData({required final  List<MarketCarModel> cars, required final  List<MarketCarModel> filteredCars, this.query = '', this.viewType = CollectionViewType.grid, this.sortType = SortType.date, this.sortOrder = SortOrder.desc}): _cars = cars,_filteredCars = filteredCars;
  

 final  List<MarketCarModel> _cars;
 List<MarketCarModel> get cars {
  if (_cars is EqualUnmodifiableListView) return _cars;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cars);
}

 final  List<MarketCarModel> _filteredCars;
 List<MarketCarModel> get filteredCars {
  if (_filteredCars is EqualUnmodifiableListView) return _filteredCars;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filteredCars);
}

@JsonKey() final  String query;
@JsonKey() final  CollectionViewType viewType;
@JsonKey() final  SortType sortType;
@JsonKey() final  SortOrder sortOrder;

/// Create a copy of MarketState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarketDataCopyWith<MarketData> get copyWith => _$MarketDataCopyWithImpl<MarketData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketData&&const DeepCollectionEquality().equals(other._cars, _cars)&&const DeepCollectionEquality().equals(other._filteredCars, _filteredCars)&&(identical(other.query, query) || other.query == query)&&(identical(other.viewType, viewType) || other.viewType == viewType)&&(identical(other.sortType, sortType) || other.sortType == sortType)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_cars),const DeepCollectionEquality().hash(_filteredCars),query,viewType,sortType,sortOrder);

@override
String toString() {
  return 'MarketState.data(cars: $cars, filteredCars: $filteredCars, query: $query, viewType: $viewType, sortType: $sortType, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class $MarketDataCopyWith<$Res> implements $MarketStateCopyWith<$Res> {
  factory $MarketDataCopyWith(MarketData value, $Res Function(MarketData) _then) = _$MarketDataCopyWithImpl;
@useResult
$Res call({
 List<MarketCarModel> cars, List<MarketCarModel> filteredCars, String query, CollectionViewType viewType, SortType sortType, SortOrder sortOrder
});




}
/// @nodoc
class _$MarketDataCopyWithImpl<$Res>
    implements $MarketDataCopyWith<$Res> {
  _$MarketDataCopyWithImpl(this._self, this._then);

  final MarketData _self;
  final $Res Function(MarketData) _then;

/// Create a copy of MarketState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? cars = null,Object? filteredCars = null,Object? query = null,Object? viewType = null,Object? sortType = null,Object? sortOrder = null,}) {
  return _then(MarketData(
cars: null == cars ? _self._cars : cars // ignore: cast_nullable_to_non_nullable
as List<MarketCarModel>,filteredCars: null == filteredCars ? _self._filteredCars : filteredCars // ignore: cast_nullable_to_non_nullable
as List<MarketCarModel>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,viewType: null == viewType ? _self.viewType : viewType // ignore: cast_nullable_to_non_nullable
as CollectionViewType,sortType: null == sortType ? _self.sortType : sortType // ignore: cast_nullable_to_non_nullable
as SortType,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as SortOrder,
  ));
}


}

/// @nodoc


class MarketError implements MarketState {
  const MarketError(this.errorKey);
  

 final  String errorKey;

/// Create a copy of MarketState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarketErrorCopyWith<MarketError> get copyWith => _$MarketErrorCopyWithImpl<MarketError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketError&&(identical(other.errorKey, errorKey) || other.errorKey == errorKey));
}


@override
int get hashCode => Object.hash(runtimeType,errorKey);

@override
String toString() {
  return 'MarketState.error(errorKey: $errorKey)';
}


}

/// @nodoc
abstract mixin class $MarketErrorCopyWith<$Res> implements $MarketStateCopyWith<$Res> {
  factory $MarketErrorCopyWith(MarketError value, $Res Function(MarketError) _then) = _$MarketErrorCopyWithImpl;
@useResult
$Res call({
 String errorKey
});




}
/// @nodoc
class _$MarketErrorCopyWithImpl<$Res>
    implements $MarketErrorCopyWith<$Res> {
  _$MarketErrorCopyWithImpl(this._self, this._then);

  final MarketError _self;
  final $Res Function(MarketError) _then;

/// Create a copy of MarketState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? errorKey = null,}) {
  return _then(MarketError(
null == errorKey ? _self.errorKey : errorKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

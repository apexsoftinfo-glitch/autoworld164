// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_photos_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SearchPhotosState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchPhotosState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SearchPhotosState()';
}


}

/// @nodoc
class $SearchPhotosStateCopyWith<$Res>  {
$SearchPhotosStateCopyWith(SearchPhotosState _, $Res Function(SearchPhotosState) __);
}


/// Adds pattern-matching-related methods to [SearchPhotosState].
extension SearchPhotosStatePatterns on SearchPhotosState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SearchPhotosInitial value)?  initial,TResult Function( SearchPhotosLoading value)?  loading,TResult Function( SearchPhotosSuccess value)?  success,TResult Function( SearchPhotosError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SearchPhotosInitial() when initial != null:
return initial(_that);case SearchPhotosLoading() when loading != null:
return loading(_that);case SearchPhotosSuccess() when success != null:
return success(_that);case SearchPhotosError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SearchPhotosInitial value)  initial,required TResult Function( SearchPhotosLoading value)  loading,required TResult Function( SearchPhotosSuccess value)  success,required TResult Function( SearchPhotosError value)  error,}){
final _that = this;
switch (_that) {
case SearchPhotosInitial():
return initial(_that);case SearchPhotosLoading():
return loading(_that);case SearchPhotosSuccess():
return success(_that);case SearchPhotosError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SearchPhotosInitial value)?  initial,TResult? Function( SearchPhotosLoading value)?  loading,TResult? Function( SearchPhotosSuccess value)?  success,TResult? Function( SearchPhotosError value)?  error,}){
final _that = this;
switch (_that) {
case SearchPhotosInitial() when initial != null:
return initial(_that);case SearchPhotosLoading() when loading != null:
return loading(_that);case SearchPhotosSuccess() when success != null:
return success(_that);case SearchPhotosError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<String> urls)?  success,TResult Function( String errorKey)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SearchPhotosInitial() when initial != null:
return initial();case SearchPhotosLoading() when loading != null:
return loading();case SearchPhotosSuccess() when success != null:
return success(_that.urls);case SearchPhotosError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<String> urls)  success,required TResult Function( String errorKey)  error,}) {final _that = this;
switch (_that) {
case SearchPhotosInitial():
return initial();case SearchPhotosLoading():
return loading();case SearchPhotosSuccess():
return success(_that.urls);case SearchPhotosError():
return error(_that.errorKey);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<String> urls)?  success,TResult? Function( String errorKey)?  error,}) {final _that = this;
switch (_that) {
case SearchPhotosInitial() when initial != null:
return initial();case SearchPhotosLoading() when loading != null:
return loading();case SearchPhotosSuccess() when success != null:
return success(_that.urls);case SearchPhotosError() when error != null:
return error(_that.errorKey);case _:
  return null;

}
}

}

/// @nodoc


class SearchPhotosInitial implements SearchPhotosState {
  const SearchPhotosInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchPhotosInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SearchPhotosState.initial()';
}


}




/// @nodoc


class SearchPhotosLoading implements SearchPhotosState {
  const SearchPhotosLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchPhotosLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SearchPhotosState.loading()';
}


}




/// @nodoc


class SearchPhotosSuccess implements SearchPhotosState {
  const SearchPhotosSuccess(final  List<String> urls): _urls = urls;
  

 final  List<String> _urls;
 List<String> get urls {
  if (_urls is EqualUnmodifiableListView) return _urls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_urls);
}


/// Create a copy of SearchPhotosState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchPhotosSuccessCopyWith<SearchPhotosSuccess> get copyWith => _$SearchPhotosSuccessCopyWithImpl<SearchPhotosSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchPhotosSuccess&&const DeepCollectionEquality().equals(other._urls, _urls));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_urls));

@override
String toString() {
  return 'SearchPhotosState.success(urls: $urls)';
}


}

/// @nodoc
abstract mixin class $SearchPhotosSuccessCopyWith<$Res> implements $SearchPhotosStateCopyWith<$Res> {
  factory $SearchPhotosSuccessCopyWith(SearchPhotosSuccess value, $Res Function(SearchPhotosSuccess) _then) = _$SearchPhotosSuccessCopyWithImpl;
@useResult
$Res call({
 List<String> urls
});




}
/// @nodoc
class _$SearchPhotosSuccessCopyWithImpl<$Res>
    implements $SearchPhotosSuccessCopyWith<$Res> {
  _$SearchPhotosSuccessCopyWithImpl(this._self, this._then);

  final SearchPhotosSuccess _self;
  final $Res Function(SearchPhotosSuccess) _then;

/// Create a copy of SearchPhotosState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? urls = null,}) {
  return _then(SearchPhotosSuccess(
null == urls ? _self._urls : urls // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc


class SearchPhotosError implements SearchPhotosState {
  const SearchPhotosError(this.errorKey);
  

 final  String errorKey;

/// Create a copy of SearchPhotosState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchPhotosErrorCopyWith<SearchPhotosError> get copyWith => _$SearchPhotosErrorCopyWithImpl<SearchPhotosError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchPhotosError&&(identical(other.errorKey, errorKey) || other.errorKey == errorKey));
}


@override
int get hashCode => Object.hash(runtimeType,errorKey);

@override
String toString() {
  return 'SearchPhotosState.error(errorKey: $errorKey)';
}


}

/// @nodoc
abstract mixin class $SearchPhotosErrorCopyWith<$Res> implements $SearchPhotosStateCopyWith<$Res> {
  factory $SearchPhotosErrorCopyWith(SearchPhotosError value, $Res Function(SearchPhotosError) _then) = _$SearchPhotosErrorCopyWithImpl;
@useResult
$Res call({
 String errorKey
});




}
/// @nodoc
class _$SearchPhotosErrorCopyWithImpl<$Res>
    implements $SearchPhotosErrorCopyWith<$Res> {
  _$SearchPhotosErrorCopyWithImpl(this._self, this._then);

  final SearchPhotosError _self;
  final $Res Function(SearchPhotosError) _then;

/// Create a copy of SearchPhotosState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? errorKey = null,}) {
  return _then(SearchPhotosError(
null == errorKey ? _self.errorKey : errorKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

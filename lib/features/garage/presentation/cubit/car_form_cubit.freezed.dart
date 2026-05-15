// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'car_form_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CarFormState implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CarFormState'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CarFormState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CarFormState()';
}


}

/// @nodoc
class $CarFormStateCopyWith<$Res>  {
$CarFormStateCopyWith(CarFormState _, $Res Function(CarFormState) __);
}


/// Adds pattern-matching-related methods to [CarFormState].
extension CarFormStatePatterns on CarFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CarFormInitial value)?  initial,TResult Function( CarFormLoading value)?  loading,TResult Function( CarFormSuccess value)?  success,TResult Function( CarFormError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CarFormInitial() when initial != null:
return initial(_that);case CarFormLoading() when loading != null:
return loading(_that);case CarFormSuccess() when success != null:
return success(_that);case CarFormError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CarFormInitial value)  initial,required TResult Function( CarFormLoading value)  loading,required TResult Function( CarFormSuccess value)  success,required TResult Function( CarFormError value)  error,}){
final _that = this;
switch (_that) {
case CarFormInitial():
return initial(_that);case CarFormLoading():
return loading(_that);case CarFormSuccess():
return success(_that);case CarFormError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CarFormInitial value)?  initial,TResult? Function( CarFormLoading value)?  loading,TResult? Function( CarFormSuccess value)?  success,TResult? Function( CarFormError value)?  error,}){
final _that = this;
switch (_that) {
case CarFormInitial() when initial != null:
return initial(_that);case CarFormLoading() when loading != null:
return loading(_that);case CarFormSuccess() when success != null:
return success(_that);case CarFormError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( List<String> producers)?  initial,TResult Function( List<String> producers)?  loading,TResult Function()?  success,TResult Function( String errorKey,  List<String> producers)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CarFormInitial() when initial != null:
return initial(_that.producers);case CarFormLoading() when loading != null:
return loading(_that.producers);case CarFormSuccess() when success != null:
return success();case CarFormError() when error != null:
return error(_that.errorKey,_that.producers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( List<String> producers)  initial,required TResult Function( List<String> producers)  loading,required TResult Function()  success,required TResult Function( String errorKey,  List<String> producers)  error,}) {final _that = this;
switch (_that) {
case CarFormInitial():
return initial(_that.producers);case CarFormLoading():
return loading(_that.producers);case CarFormSuccess():
return success();case CarFormError():
return error(_that.errorKey,_that.producers);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( List<String> producers)?  initial,TResult? Function( List<String> producers)?  loading,TResult? Function()?  success,TResult? Function( String errorKey,  List<String> producers)?  error,}) {final _that = this;
switch (_that) {
case CarFormInitial() when initial != null:
return initial(_that.producers);case CarFormLoading() when loading != null:
return loading(_that.producers);case CarFormSuccess() when success != null:
return success();case CarFormError() when error != null:
return error(_that.errorKey,_that.producers);case _:
  return null;

}
}

}

/// @nodoc


class CarFormInitial with DiagnosticableTreeMixin implements CarFormState {
  const CarFormInitial({final  List<String> producers = const []}): _producers = producers;
  

 final  List<String> _producers;
@JsonKey() List<String> get producers {
  if (_producers is EqualUnmodifiableListView) return _producers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_producers);
}


/// Create a copy of CarFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CarFormInitialCopyWith<CarFormInitial> get copyWith => _$CarFormInitialCopyWithImpl<CarFormInitial>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CarFormState.initial'))
    ..add(DiagnosticsProperty('producers', producers));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CarFormInitial&&const DeepCollectionEquality().equals(other._producers, _producers));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_producers));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CarFormState.initial(producers: $producers)';
}


}

/// @nodoc
abstract mixin class $CarFormInitialCopyWith<$Res> implements $CarFormStateCopyWith<$Res> {
  factory $CarFormInitialCopyWith(CarFormInitial value, $Res Function(CarFormInitial) _then) = _$CarFormInitialCopyWithImpl;
@useResult
$Res call({
 List<String> producers
});




}
/// @nodoc
class _$CarFormInitialCopyWithImpl<$Res>
    implements $CarFormInitialCopyWith<$Res> {
  _$CarFormInitialCopyWithImpl(this._self, this._then);

  final CarFormInitial _self;
  final $Res Function(CarFormInitial) _then;

/// Create a copy of CarFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? producers = null,}) {
  return _then(CarFormInitial(
producers: null == producers ? _self._producers : producers // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc


class CarFormLoading with DiagnosticableTreeMixin implements CarFormState {
  const CarFormLoading({final  List<String> producers = const []}): _producers = producers;
  

 final  List<String> _producers;
@JsonKey() List<String> get producers {
  if (_producers is EqualUnmodifiableListView) return _producers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_producers);
}


/// Create a copy of CarFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CarFormLoadingCopyWith<CarFormLoading> get copyWith => _$CarFormLoadingCopyWithImpl<CarFormLoading>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CarFormState.loading'))
    ..add(DiagnosticsProperty('producers', producers));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CarFormLoading&&const DeepCollectionEquality().equals(other._producers, _producers));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_producers));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CarFormState.loading(producers: $producers)';
}


}

/// @nodoc
abstract mixin class $CarFormLoadingCopyWith<$Res> implements $CarFormStateCopyWith<$Res> {
  factory $CarFormLoadingCopyWith(CarFormLoading value, $Res Function(CarFormLoading) _then) = _$CarFormLoadingCopyWithImpl;
@useResult
$Res call({
 List<String> producers
});




}
/// @nodoc
class _$CarFormLoadingCopyWithImpl<$Res>
    implements $CarFormLoadingCopyWith<$Res> {
  _$CarFormLoadingCopyWithImpl(this._self, this._then);

  final CarFormLoading _self;
  final $Res Function(CarFormLoading) _then;

/// Create a copy of CarFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? producers = null,}) {
  return _then(CarFormLoading(
producers: null == producers ? _self._producers : producers // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc


class CarFormSuccess with DiagnosticableTreeMixin implements CarFormState {
  const CarFormSuccess();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CarFormState.success'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CarFormSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CarFormState.success()';
}


}




/// @nodoc


class CarFormError with DiagnosticableTreeMixin implements CarFormState {
  const CarFormError(this.errorKey, {final  List<String> producers = const []}): _producers = producers;
  

 final  String errorKey;
 final  List<String> _producers;
@JsonKey() List<String> get producers {
  if (_producers is EqualUnmodifiableListView) return _producers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_producers);
}


/// Create a copy of CarFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CarFormErrorCopyWith<CarFormError> get copyWith => _$CarFormErrorCopyWithImpl<CarFormError>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CarFormState.error'))
    ..add(DiagnosticsProperty('errorKey', errorKey))..add(DiagnosticsProperty('producers', producers));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CarFormError&&(identical(other.errorKey, errorKey) || other.errorKey == errorKey)&&const DeepCollectionEquality().equals(other._producers, _producers));
}


@override
int get hashCode => Object.hash(runtimeType,errorKey,const DeepCollectionEquality().hash(_producers));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CarFormState.error(errorKey: $errorKey, producers: $producers)';
}


}

/// @nodoc
abstract mixin class $CarFormErrorCopyWith<$Res> implements $CarFormStateCopyWith<$Res> {
  factory $CarFormErrorCopyWith(CarFormError value, $Res Function(CarFormError) _then) = _$CarFormErrorCopyWithImpl;
@useResult
$Res call({
 String errorKey, List<String> producers
});




}
/// @nodoc
class _$CarFormErrorCopyWithImpl<$Res>
    implements $CarFormErrorCopyWith<$Res> {
  _$CarFormErrorCopyWithImpl(this._self, this._then);

  final CarFormError _self;
  final $Res Function(CarFormError) _then;

/// Create a copy of CarFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? errorKey = null,Object? producers = null,}) {
  return _then(CarFormError(
null == errorKey ? _self.errorKey : errorKey // ignore: cast_nullable_to_non_nullable
as String,producers: null == producers ? _self._producers : producers // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on

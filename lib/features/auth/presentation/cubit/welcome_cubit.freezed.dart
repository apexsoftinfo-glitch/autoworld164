// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'welcome_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WelcomeState implements DiagnosticableTreeMixin {

 bool get isLoading; String? get errorKey;
/// Create a copy of WelcomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WelcomeStateCopyWith<WelcomeState> get copyWith => _$WelcomeStateCopyWithImpl<WelcomeState>(this as WelcomeState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'WelcomeState'))
    ..add(DiagnosticsProperty('isLoading', isLoading))..add(DiagnosticsProperty('errorKey', errorKey));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WelcomeState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorKey, errorKey) || other.errorKey == errorKey));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,errorKey);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'WelcomeState(isLoading: $isLoading, errorKey: $errorKey)';
}


}

/// @nodoc
abstract mixin class $WelcomeStateCopyWith<$Res>  {
  factory $WelcomeStateCopyWith(WelcomeState value, $Res Function(WelcomeState) _then) = _$WelcomeStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, String? errorKey
});




}
/// @nodoc
class _$WelcomeStateCopyWithImpl<$Res>
    implements $WelcomeStateCopyWith<$Res> {
  _$WelcomeStateCopyWithImpl(this._self, this._then);

  final WelcomeState _self;
  final $Res Function(WelcomeState) _then;

/// Create a copy of WelcomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? errorKey = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorKey: freezed == errorKey ? _self.errorKey : errorKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WelcomeState].
extension WelcomeStatePatterns on WelcomeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( WelcomeStateData value)?  initial,required TResult orElse(),}){
final _that = this;
switch (_that) {
case WelcomeStateData() when initial != null:
return initial(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( WelcomeStateData value)  initial,}){
final _that = this;
switch (_that) {
case WelcomeStateData():
return initial(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( WelcomeStateData value)?  initial,}){
final _that = this;
switch (_that) {
case WelcomeStateData() when initial != null:
return initial(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool isLoading,  String? errorKey)?  initial,required TResult orElse(),}) {final _that = this;
switch (_that) {
case WelcomeStateData() when initial != null:
return initial(_that.isLoading,_that.errorKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool isLoading,  String? errorKey)  initial,}) {final _that = this;
switch (_that) {
case WelcomeStateData():
return initial(_that.isLoading,_that.errorKey);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool isLoading,  String? errorKey)?  initial,}) {final _that = this;
switch (_that) {
case WelcomeStateData() when initial != null:
return initial(_that.isLoading,_that.errorKey);case _:
  return null;

}
}

}

/// @nodoc


class WelcomeStateData with DiagnosticableTreeMixin implements WelcomeState {
  const WelcomeStateData({this.isLoading = false, this.errorKey});
  

@override@JsonKey() final  bool isLoading;
@override final  String? errorKey;

/// Create a copy of WelcomeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WelcomeStateDataCopyWith<WelcomeStateData> get copyWith => _$WelcomeStateDataCopyWithImpl<WelcomeStateData>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'WelcomeState.initial'))
    ..add(DiagnosticsProperty('isLoading', isLoading))..add(DiagnosticsProperty('errorKey', errorKey));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WelcomeStateData&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorKey, errorKey) || other.errorKey == errorKey));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,errorKey);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'WelcomeState.initial(isLoading: $isLoading, errorKey: $errorKey)';
}


}

/// @nodoc
abstract mixin class $WelcomeStateDataCopyWith<$Res> implements $WelcomeStateCopyWith<$Res> {
  factory $WelcomeStateDataCopyWith(WelcomeStateData value, $Res Function(WelcomeStateData) _then) = _$WelcomeStateDataCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String? errorKey
});




}
/// @nodoc
class _$WelcomeStateDataCopyWithImpl<$Res>
    implements $WelcomeStateDataCopyWith<$Res> {
  _$WelcomeStateDataCopyWithImpl(this._self, this._then);

  final WelcomeStateData _self;
  final $Res Function(WelcomeStateData) _then;

/// Create a copy of WelcomeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? errorKey = freezed,}) {
  return _then(WelcomeStateData(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorKey: freezed == errorKey ? _self.errorKey : errorKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

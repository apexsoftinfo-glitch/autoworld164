// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoginState implements DiagnosticableTreeMixin {

 bool get isLoading; String? get errorKey;
/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginStateCopyWith<LoginState> get copyWith => _$LoginStateCopyWithImpl<LoginState>(this as LoginState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'LoginState'))
    ..add(DiagnosticsProperty('isLoading', isLoading))..add(DiagnosticsProperty('errorKey', errorKey));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorKey, errorKey) || other.errorKey == errorKey));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,errorKey);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'LoginState(isLoading: $isLoading, errorKey: $errorKey)';
}


}

/// @nodoc
abstract mixin class $LoginStateCopyWith<$Res>  {
  factory $LoginStateCopyWith(LoginState value, $Res Function(LoginState) _then) = _$LoginStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, String? errorKey
});




}
/// @nodoc
class _$LoginStateCopyWithImpl<$Res>
    implements $LoginStateCopyWith<$Res> {
  _$LoginStateCopyWithImpl(this._self, this._then);

  final LoginState _self;
  final $Res Function(LoginState) _then;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? errorKey = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorKey: freezed == errorKey ? _self.errorKey : errorKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LoginState].
extension LoginStatePatterns on LoginState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoginStateData value)?  initial,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoginStateData() when initial != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoginStateData value)  initial,}){
final _that = this;
switch (_that) {
case LoginStateData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoginStateData value)?  initial,}){
final _that = this;
switch (_that) {
case LoginStateData() when initial != null:
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
case LoginStateData() when initial != null:
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
case LoginStateData():
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
case LoginStateData() when initial != null:
return initial(_that.isLoading,_that.errorKey);case _:
  return null;

}
}

}

/// @nodoc


class LoginStateData with DiagnosticableTreeMixin implements LoginState {
  const LoginStateData({this.isLoading = false, this.errorKey});
  

@override@JsonKey() final  bool isLoading;
@override final  String? errorKey;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginStateDataCopyWith<LoginStateData> get copyWith => _$LoginStateDataCopyWithImpl<LoginStateData>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'LoginState.initial'))
    ..add(DiagnosticsProperty('isLoading', isLoading))..add(DiagnosticsProperty('errorKey', errorKey));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginStateData&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorKey, errorKey) || other.errorKey == errorKey));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,errorKey);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'LoginState.initial(isLoading: $isLoading, errorKey: $errorKey)';
}


}

/// @nodoc
abstract mixin class $LoginStateDataCopyWith<$Res> implements $LoginStateCopyWith<$Res> {
  factory $LoginStateDataCopyWith(LoginStateData value, $Res Function(LoginStateData) _then) = _$LoginStateDataCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String? errorKey
});




}
/// @nodoc
class _$LoginStateDataCopyWithImpl<$Res>
    implements $LoginStateDataCopyWith<$Res> {
  _$LoginStateDataCopyWithImpl(this._self, this._then);

  final LoginStateData _self;
  final $Res Function(LoginStateData) _then;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? errorKey = freezed,}) {
  return _then(LoginStateData(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorKey: freezed == errorKey ? _self.errorKey : errorKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

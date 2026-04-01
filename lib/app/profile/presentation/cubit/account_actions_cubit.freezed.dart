// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_actions_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountActionsState implements DiagnosticableTreeMixin {

 AccountAction? get activeAction; String? get errorKey; String? get successKey;
/// Create a copy of AccountActionsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountActionsStateCopyWith<AccountActionsState> get copyWith => _$AccountActionsStateCopyWithImpl<AccountActionsState>(this as AccountActionsState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AccountActionsState'))
    ..add(DiagnosticsProperty('activeAction', activeAction))..add(DiagnosticsProperty('errorKey', errorKey))..add(DiagnosticsProperty('successKey', successKey));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountActionsState&&(identical(other.activeAction, activeAction) || other.activeAction == activeAction)&&(identical(other.errorKey, errorKey) || other.errorKey == errorKey)&&(identical(other.successKey, successKey) || other.successKey == successKey));
}


@override
int get hashCode => Object.hash(runtimeType,activeAction,errorKey,successKey);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AccountActionsState(activeAction: $activeAction, errorKey: $errorKey, successKey: $successKey)';
}


}

/// @nodoc
abstract mixin class $AccountActionsStateCopyWith<$Res>  {
  factory $AccountActionsStateCopyWith(AccountActionsState value, $Res Function(AccountActionsState) _then) = _$AccountActionsStateCopyWithImpl;
@useResult
$Res call({
 AccountAction? activeAction, String? errorKey, String? successKey
});




}
/// @nodoc
class _$AccountActionsStateCopyWithImpl<$Res>
    implements $AccountActionsStateCopyWith<$Res> {
  _$AccountActionsStateCopyWithImpl(this._self, this._then);

  final AccountActionsState _self;
  final $Res Function(AccountActionsState) _then;

/// Create a copy of AccountActionsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activeAction = freezed,Object? errorKey = freezed,Object? successKey = freezed,}) {
  return _then(_self.copyWith(
activeAction: freezed == activeAction ? _self.activeAction : activeAction // ignore: cast_nullable_to_non_nullable
as AccountAction?,errorKey: freezed == errorKey ? _self.errorKey : errorKey // ignore: cast_nullable_to_non_nullable
as String?,successKey: freezed == successKey ? _self.successKey : successKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AccountActionsState].
extension AccountActionsStatePatterns on AccountActionsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AccountActionsStateData value)?  initial,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AccountActionsStateData() when initial != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AccountActionsStateData value)  initial,}){
final _that = this;
switch (_that) {
case AccountActionsStateData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AccountActionsStateData value)?  initial,}){
final _that = this;
switch (_that) {
case AccountActionsStateData() when initial != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( AccountAction? activeAction,  String? errorKey,  String? successKey)?  initial,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AccountActionsStateData() when initial != null:
return initial(_that.activeAction,_that.errorKey,_that.successKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( AccountAction? activeAction,  String? errorKey,  String? successKey)  initial,}) {final _that = this;
switch (_that) {
case AccountActionsStateData():
return initial(_that.activeAction,_that.errorKey,_that.successKey);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( AccountAction? activeAction,  String? errorKey,  String? successKey)?  initial,}) {final _that = this;
switch (_that) {
case AccountActionsStateData() when initial != null:
return initial(_that.activeAction,_that.errorKey,_that.successKey);case _:
  return null;

}
}

}

/// @nodoc


class AccountActionsStateData with DiagnosticableTreeMixin implements AccountActionsState {
  const AccountActionsStateData({this.activeAction, this.errorKey, this.successKey});
  

@override final  AccountAction? activeAction;
@override final  String? errorKey;
@override final  String? successKey;

/// Create a copy of AccountActionsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountActionsStateDataCopyWith<AccountActionsStateData> get copyWith => _$AccountActionsStateDataCopyWithImpl<AccountActionsStateData>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AccountActionsState.initial'))
    ..add(DiagnosticsProperty('activeAction', activeAction))..add(DiagnosticsProperty('errorKey', errorKey))..add(DiagnosticsProperty('successKey', successKey));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountActionsStateData&&(identical(other.activeAction, activeAction) || other.activeAction == activeAction)&&(identical(other.errorKey, errorKey) || other.errorKey == errorKey)&&(identical(other.successKey, successKey) || other.successKey == successKey));
}


@override
int get hashCode => Object.hash(runtimeType,activeAction,errorKey,successKey);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AccountActionsState.initial(activeAction: $activeAction, errorKey: $errorKey, successKey: $successKey)';
}


}

/// @nodoc
abstract mixin class $AccountActionsStateDataCopyWith<$Res> implements $AccountActionsStateCopyWith<$Res> {
  factory $AccountActionsStateDataCopyWith(AccountActionsStateData value, $Res Function(AccountActionsStateData) _then) = _$AccountActionsStateDataCopyWithImpl;
@override @useResult
$Res call({
 AccountAction? activeAction, String? errorKey, String? successKey
});




}
/// @nodoc
class _$AccountActionsStateDataCopyWithImpl<$Res>
    implements $AccountActionsStateDataCopyWith<$Res> {
  _$AccountActionsStateDataCopyWithImpl(this._self, this._then);

  final AccountActionsStateData _self;
  final $Res Function(AccountActionsStateData) _then;

/// Create a copy of AccountActionsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activeAction = freezed,Object? errorKey = freezed,Object? successKey = freezed,}) {
  return _then(AccountActionsStateData(
activeAction: freezed == activeAction ? _self.activeAction : activeAction // ignore: cast_nullable_to_non_nullable
as AccountAction?,errorKey: freezed == errorKey ? _self.errorKey : errorKey // ignore: cast_nullable_to_non_nullable
as String?,successKey: freezed == successKey ? _self.successKey : successKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

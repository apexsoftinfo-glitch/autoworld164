// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_locale_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppLocaleState implements DiagnosticableTreeMixin {

 AppLocaleOptionModel get selectedOption; bool get isSaving; String? get errorKey;
/// Create a copy of AppLocaleState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppLocaleStateCopyWith<AppLocaleState> get copyWith => _$AppLocaleStateCopyWithImpl<AppLocaleState>(this as AppLocaleState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AppLocaleState'))
    ..add(DiagnosticsProperty('selectedOption', selectedOption))..add(DiagnosticsProperty('isSaving', isSaving))..add(DiagnosticsProperty('errorKey', errorKey));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppLocaleState&&(identical(other.selectedOption, selectedOption) || other.selectedOption == selectedOption)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.errorKey, errorKey) || other.errorKey == errorKey));
}


@override
int get hashCode => Object.hash(runtimeType,selectedOption,isSaving,errorKey);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AppLocaleState(selectedOption: $selectedOption, isSaving: $isSaving, errorKey: $errorKey)';
}


}

/// @nodoc
abstract mixin class $AppLocaleStateCopyWith<$Res>  {
  factory $AppLocaleStateCopyWith(AppLocaleState value, $Res Function(AppLocaleState) _then) = _$AppLocaleStateCopyWithImpl;
@useResult
$Res call({
 AppLocaleOptionModel selectedOption, bool isSaving, String? errorKey
});




}
/// @nodoc
class _$AppLocaleStateCopyWithImpl<$Res>
    implements $AppLocaleStateCopyWith<$Res> {
  _$AppLocaleStateCopyWithImpl(this._self, this._then);

  final AppLocaleState _self;
  final $Res Function(AppLocaleState) _then;

/// Create a copy of AppLocaleState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedOption = null,Object? isSaving = null,Object? errorKey = freezed,}) {
  return _then(_self.copyWith(
selectedOption: null == selectedOption ? _self.selectedOption : selectedOption // ignore: cast_nullable_to_non_nullable
as AppLocaleOptionModel,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,errorKey: freezed == errorKey ? _self.errorKey : errorKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AppLocaleState].
extension AppLocaleStatePatterns on AppLocaleState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AppLocaleStateData value)?  initial,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AppLocaleStateData() when initial != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AppLocaleStateData value)  initial,}){
final _that = this;
switch (_that) {
case AppLocaleStateData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AppLocaleStateData value)?  initial,}){
final _that = this;
switch (_that) {
case AppLocaleStateData() when initial != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( AppLocaleOptionModel selectedOption,  bool isSaving,  String? errorKey)?  initial,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AppLocaleStateData() when initial != null:
return initial(_that.selectedOption,_that.isSaving,_that.errorKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( AppLocaleOptionModel selectedOption,  bool isSaving,  String? errorKey)  initial,}) {final _that = this;
switch (_that) {
case AppLocaleStateData():
return initial(_that.selectedOption,_that.isSaving,_that.errorKey);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( AppLocaleOptionModel selectedOption,  bool isSaving,  String? errorKey)?  initial,}) {final _that = this;
switch (_that) {
case AppLocaleStateData() when initial != null:
return initial(_that.selectedOption,_that.isSaving,_that.errorKey);case _:
  return null;

}
}

}

/// @nodoc


class AppLocaleStateData extends AppLocaleState with DiagnosticableTreeMixin {
  const AppLocaleStateData({required this.selectedOption, this.isSaving = false, this.errorKey}): super._();
  

@override final  AppLocaleOptionModel selectedOption;
@override@JsonKey() final  bool isSaving;
@override final  String? errorKey;

/// Create a copy of AppLocaleState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppLocaleStateDataCopyWith<AppLocaleStateData> get copyWith => _$AppLocaleStateDataCopyWithImpl<AppLocaleStateData>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AppLocaleState.initial'))
    ..add(DiagnosticsProperty('selectedOption', selectedOption))..add(DiagnosticsProperty('isSaving', isSaving))..add(DiagnosticsProperty('errorKey', errorKey));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppLocaleStateData&&(identical(other.selectedOption, selectedOption) || other.selectedOption == selectedOption)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.errorKey, errorKey) || other.errorKey == errorKey));
}


@override
int get hashCode => Object.hash(runtimeType,selectedOption,isSaving,errorKey);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AppLocaleState.initial(selectedOption: $selectedOption, isSaving: $isSaving, errorKey: $errorKey)';
}


}

/// @nodoc
abstract mixin class $AppLocaleStateDataCopyWith<$Res> implements $AppLocaleStateCopyWith<$Res> {
  factory $AppLocaleStateDataCopyWith(AppLocaleStateData value, $Res Function(AppLocaleStateData) _then) = _$AppLocaleStateDataCopyWithImpl;
@override @useResult
$Res call({
 AppLocaleOptionModel selectedOption, bool isSaving, String? errorKey
});




}
/// @nodoc
class _$AppLocaleStateDataCopyWithImpl<$Res>
    implements $AppLocaleStateDataCopyWith<$Res> {
  _$AppLocaleStateDataCopyWithImpl(this._self, this._then);

  final AppLocaleStateData _self;
  final $Res Function(AppLocaleStateData) _then;

/// Create a copy of AppLocaleState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedOption = null,Object? isSaving = null,Object? errorKey = freezed,}) {
  return _then(AppLocaleStateData(
selectedOption: null == selectedOption ? _self.selectedOption : selectedOption // ignore: cast_nullable_to_non_nullable
as AppLocaleOptionModel,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,errorKey: freezed == errorKey ? _self.errorKey : errorKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

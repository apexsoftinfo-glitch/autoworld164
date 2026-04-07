// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'news_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NewsModel {

 String get id;@JsonKey(name: 'created_at') DateTime get createdAt; String get title; String get content;@JsonKey(name: 'image_url') String? get imageUrl;@JsonKey(name: 'image_urls') List<String> get imageUrls; String? get author; String? get category;
/// Create a copy of NewsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NewsModelCopyWith<NewsModel> get copyWith => _$NewsModelCopyWithImpl<NewsModel>(this as NewsModel, _$identity);

  /// Serializes this NewsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewsModel&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other.imageUrls, imageUrls)&&(identical(other.author, author) || other.author == author)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,title,content,imageUrl,const DeepCollectionEquality().hash(imageUrls),author,category);

@override
String toString() {
  return 'NewsModel(id: $id, createdAt: $createdAt, title: $title, content: $content, imageUrl: $imageUrl, imageUrls: $imageUrls, author: $author, category: $category)';
}


}

/// @nodoc
abstract mixin class $NewsModelCopyWith<$Res>  {
  factory $NewsModelCopyWith(NewsModel value, $Res Function(NewsModel) _then) = _$NewsModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'created_at') DateTime createdAt, String title, String content,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(name: 'image_urls') List<String> imageUrls, String? author, String? category
});




}
/// @nodoc
class _$NewsModelCopyWithImpl<$Res>
    implements $NewsModelCopyWith<$Res> {
  _$NewsModelCopyWithImpl(this._self, this._then);

  final NewsModel _self;
  final $Res Function(NewsModel) _then;

/// Create a copy of NewsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = null,Object? title = null,Object? content = null,Object? imageUrl = freezed,Object? imageUrls = null,Object? author = freezed,Object? category = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,imageUrls: null == imageUrls ? _self.imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NewsModel].
extension NewsModelPatterns on NewsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NewsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NewsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NewsModel value)  $default,){
final _that = this;
switch (_that) {
case _NewsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NewsModel value)?  $default,){
final _that = this;
switch (_that) {
case _NewsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'created_at')  DateTime createdAt,  String title,  String content, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'image_urls')  List<String> imageUrls,  String? author,  String? category)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NewsModel() when $default != null:
return $default(_that.id,_that.createdAt,_that.title,_that.content,_that.imageUrl,_that.imageUrls,_that.author,_that.category);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'created_at')  DateTime createdAt,  String title,  String content, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'image_urls')  List<String> imageUrls,  String? author,  String? category)  $default,) {final _that = this;
switch (_that) {
case _NewsModel():
return $default(_that.id,_that.createdAt,_that.title,_that.content,_that.imageUrl,_that.imageUrls,_that.author,_that.category);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'created_at')  DateTime createdAt,  String title,  String content, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'image_urls')  List<String> imageUrls,  String? author,  String? category)?  $default,) {final _that = this;
switch (_that) {
case _NewsModel() when $default != null:
return $default(_that.id,_that.createdAt,_that.title,_that.content,_that.imageUrl,_that.imageUrls,_that.author,_that.category);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NewsModel implements NewsModel {
  const _NewsModel({required this.id, @JsonKey(name: 'created_at') required this.createdAt, required this.title, required this.content, @JsonKey(name: 'image_url') this.imageUrl, @JsonKey(name: 'image_urls') final  List<String> imageUrls = const [], this.author, this.category}): _imageUrls = imageUrls;
  factory _NewsModel.fromJson(Map<String, dynamic> json) => _$NewsModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override final  String title;
@override final  String content;
@override@JsonKey(name: 'image_url') final  String? imageUrl;
 final  List<String> _imageUrls;
@override@JsonKey(name: 'image_urls') List<String> get imageUrls {
  if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imageUrls);
}

@override final  String? author;
@override final  String? category;

/// Create a copy of NewsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NewsModelCopyWith<_NewsModel> get copyWith => __$NewsModelCopyWithImpl<_NewsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NewsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NewsModel&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other._imageUrls, _imageUrls)&&(identical(other.author, author) || other.author == author)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,title,content,imageUrl,const DeepCollectionEquality().hash(_imageUrls),author,category);

@override
String toString() {
  return 'NewsModel(id: $id, createdAt: $createdAt, title: $title, content: $content, imageUrl: $imageUrl, imageUrls: $imageUrls, author: $author, category: $category)';
}


}

/// @nodoc
abstract mixin class _$NewsModelCopyWith<$Res> implements $NewsModelCopyWith<$Res> {
  factory _$NewsModelCopyWith(_NewsModel value, $Res Function(_NewsModel) _then) = __$NewsModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'created_at') DateTime createdAt, String title, String content,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(name: 'image_urls') List<String> imageUrls, String? author, String? category
});




}
/// @nodoc
class __$NewsModelCopyWithImpl<$Res>
    implements _$NewsModelCopyWith<$Res> {
  __$NewsModelCopyWithImpl(this._self, this._then);

  final _NewsModel _self;
  final $Res Function(_NewsModel) _then;

/// Create a copy of NewsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createdAt = null,Object? title = null,Object? content = null,Object? imageUrl = freezed,Object? imageUrls = null,Object? author = freezed,Object? category = freezed,}) {
  return _then(_NewsModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,imageUrls: null == imageUrls ? _self._imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

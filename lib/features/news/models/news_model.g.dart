// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NewsModel _$NewsModelFromJson(Map<String, dynamic> json) => _NewsModel(
  id: json['id'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  title: json['title'] as String,
  content: json['content'] as String,
  imageUrl: json['image_url'] as String?,
  imageUrls:
      (json['image_urls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  author: json['author'] as String?,
  category: json['category'] as String?,
);

Map<String, dynamic> _$NewsModelToJson(_NewsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt.toIso8601String(),
      'title': instance.title,
      'content': instance.content,
      'image_url': instance.imageUrl,
      'image_urls': instance.imageUrls,
      'author': instance.author,
      'category': instance.category,
    };

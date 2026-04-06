import 'package:freezed_annotation/freezed_annotation.dart';

part 'news_model.freezed.dart';
part 'news_model.g.dart';

@freezed
abstract class NewsModel with _$NewsModel {
  const factory NewsModel({
    required String id,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    required String title,
    required String content,
    @JsonKey(name: 'image_url') String? imageUrl,
    String? author,
    String? category,
  }) = _NewsModel;

  factory NewsModel.fromJson(Map<String, dynamic> json) =>
      _$NewsModelFromJson(json);
}

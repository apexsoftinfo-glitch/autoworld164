import 'package:freezed_annotation/freezed_annotation.dart';

part 'news_model.freezed.dart';
part 'news_model.g.dart';

@freezed
abstract class NewsModel with _$NewsModel {
  const NewsModel._();

  const factory NewsModel({
    required String id,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    required String title,
    required String content,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'image_urls') @Default([]) List<String> imageUrls,
    String? author,
    String? category,
    String? link,
  }) = _NewsModel;

  factory NewsModel.fromJson(Map<String, dynamic> json) =>
      _$NewsModelFromJson(json);

  String? get effectiveImageUrl {
    if (imageUrl != null && imageUrl!.trim().isNotEmpty) return imageUrl;
    if (imageUrls.isNotEmpty) {
      final first = imageUrls.first;
      if (first.trim().isNotEmpty) return first;
    }
    return null;
  }
}

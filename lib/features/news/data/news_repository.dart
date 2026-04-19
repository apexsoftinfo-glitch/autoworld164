import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import 'package:intl/intl.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../models/news_model.dart';

abstract class NewsDataSource {
  Future<List<Map<String, dynamic>>> getNews();
  Stream<List<Map<String, dynamic>>> watchNews();
}

@LazySingleton(as: NewsDataSource)
class NewsDataSourceImpl implements NewsDataSource {
  final http.Client _client = http.Client();

  @override
  Future<List<Map<String, dynamic>>> getNews() async {
    try {
      final response = await _client.get(Uri.parse('https://lamleygroup.com/feed/'));
      if (response.statusCode != 200) return [];

      final document = XmlDocument.parse(response.body);
      final items = document.findAllElements('item').take(10);

      return items.map((item) {
        final title = item.findElements('title').firstOrNull?.innerText ?? '';
        final link = item.findElements('link').firstOrNull?.innerText ?? '';
        final pubDateStr =
            item.findElements('pubDate').firstOrNull?.innerText ?? '';
        final description =
            item.findElements('description').firstOrNull?.innerText ?? '';
        final content =
            item.findElements('content:encoded').firstOrNull?.innerText ?? '';
        final guid = item.findElements('guid').firstOrNull?.innerText ?? link;

        final imageUrls = _extractImageUrls(content);

        return {
          'id': guid,
          'created_at': _parsePubDate(pubDateStr).toIso8601String(),
          'title': title,
          'content': description,
          'image_url': imageUrls.isNotEmpty ? imageUrls.first : null,
          'image_urls': imageUrls,
          'author': item.findElements('dc:creator').firstOrNull?.innerText,
          'category': item.findElements('category').firstOrNull?.innerText,
        };
      }).toList();
    } catch (e) {
      debugPrint('❌ [NewsDataSource] Error fetching Lamley Group news: $e');
      return [];
    }
  }

  @override
  Stream<List<Map<String, dynamic>>> watchNews() {
    return Stream.fromFuture(getNews()).concatWith([
      Stream.periodic(const Duration(minutes: 30))
          .asyncMap((_) => getNews()),
    ]);
  }

  List<String> _extractImageUrls(String html) {
    if (html.isEmpty) return [];
    final regExp = RegExp(r'<img [^>]*src="([^"]+)"');
    return regExp.allMatches(html).map((m) => m.group(1)!).toList();
  }

  DateTime _parsePubDate(String pubDate) {
    try {
      // RFC 822 format: Mon, 06 Apr 2026 16:00:00 +0000
      // DateFormat in intl doesn't handle timezone offsets like +0000 easily with one pattern, 
      // but we can try a few.
      final cleanDate = pubDate.split(' (').first; // Remove trailing (UTC) if any
      return DateFormat('EEE, dd MMM yyyy HH:mm:ss Z').parse(cleanDate);
    } catch (e) {
      try {
        // Fallback for some common formats
        return DateTime.parse(pubDate);
      } catch (_) {
        debugPrint('⚠️ [NewsDataSource] Could not parse pubDate: $pubDate');
        return DateTime.now();
      }
    }
  }
}

abstract class NewsRepository {
  Future<List<NewsModel>> getNews();
  Stream<List<NewsModel>> watchNews();
}

@LazySingleton(as: NewsRepository)
class NewsRepositoryImpl implements NewsRepository {
  final NewsDataSource _dataSource;

  NewsRepositoryImpl(this._dataSource);

  @override
  Future<List<NewsModel>> getNews() async {
    final data = await _dataSource.getNews();
    return data.map((json) => NewsModel.fromJson(json)).toList();
  }

  @override
  Stream<List<NewsModel>> watchNews() {
    return _dataSource.watchNews().map(
          (list) => list.map((json) => NewsModel.fromJson(json)).toList(),
        );
  }
}

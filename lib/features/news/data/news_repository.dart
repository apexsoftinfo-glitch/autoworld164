import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/news_model.dart';
import 'package:injectable/injectable.dart';

abstract class NewsDataSource {
  Future<List<Map<String, dynamic>>> getNews();
  Stream<List<Map<String, dynamic>>> watchNews();
}

@LazySingleton(as: NewsDataSource)
class NewsDataSourceImpl implements NewsDataSource {
  final SupabaseClient _supabase;

  NewsDataSourceImpl(this._supabase);

  @override
  Future<List<Map<String, dynamic>>> getNews() async {
    final response = await _supabase
        .from('autoworld_news')
        .select()
        .order('created_at', ascending: false);
    return response;
  }

  @override
  Stream<List<Map<String, dynamic>>> watchNews() {
    return _supabase
        .from('autoworld_news')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false);
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

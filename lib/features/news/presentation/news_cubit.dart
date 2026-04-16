import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../data/news_repository.dart';
import '../models/news_model.dart';

part 'news_cubit.freezed.dart';

@injectable
class NewsCubit extends Cubit<NewsState> {
  final NewsRepository _repository;
  StreamSubscription? _newsSubscription;
  Timer? _refreshTimer;

  NewsCubit(this._repository) : super(const NewsState.initial()) {
    Future.microtask(() => loadNews());
    _startRefreshTimer();
  }

  void _startRefreshTimer() {
    _refreshTimer?.cancel();
    // Refresh every 4 hours
    _refreshTimer = Timer.periodic(const Duration(hours: 4), (_) {
      loadNews();
    });
  }

  Future<void> loadNews() async {
    emit(const NewsState.loading());
    _newsSubscription?.cancel();
    _newsSubscription = _repository.watchNews().listen(
      (news) {
        // Show news from the last year to be safe
        final cutoffDate = DateTime.now().subtract(const Duration(days: 365));
        final filteredNews = news
            .where((item) => item.createdAt.isAfter(cutoffDate))
            .toList();
        
        // Ensure we log if some news items are missing images for debugging
        for (final item in filteredNews) {
          if (item.imageUrl == null && item.imageUrls.isEmpty) {
            debugPrint('⚠️ News item ${item.id} ("${item.title}") has NO images at all');
          } else if (item.imageUrl == null) {
            debugPrint('ℹ️ News item ${item.id} ("${item.title}") has no primary image_url but has image_urls list');
          }
        }

        emit(NewsState.data(news: filteredNews));
      },
      onError: (error) {
        debugPrint('❌ Error loading news in Cubit: $error');
        emit(NewsState.error(errorKey: 'error_loading_news'));
      },
    );
  }

  @override
  Future<void> close() {
    _newsSubscription?.cancel();
    _refreshTimer?.cancel();
    return super.close();
  }
}

@freezed
sealed class NewsState with _$NewsState {
  const factory NewsState.initial() = Initial;
  const factory NewsState.loading() = Loading;
  const factory NewsState.data({
    required List<NewsModel> news,
  }) = Data;
  const factory NewsState.error({required String errorKey}) = Error;
}

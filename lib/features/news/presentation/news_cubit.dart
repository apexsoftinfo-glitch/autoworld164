import 'dart:async';
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

  NewsCubit(this._repository) : super(const NewsState.initial()) {
    loadNews();
  }

  Future<void> loadNews() async {
    emit(const NewsState.loading());
    _newsSubscription?.cancel();
    _newsSubscription = _repository.watchNews().listen(
      (news) {
        emit(NewsState.data(news: news));
      },
      onError: (error) {
        emit(NewsState.error(errorKey: 'error_loading_news'));
      },
    );
  }

  @override
  Future<void> close() {
    _newsSubscription?.cancel();
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

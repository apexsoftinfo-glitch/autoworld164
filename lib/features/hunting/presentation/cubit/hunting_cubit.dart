import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../data/repositories/hunting_repository.dart';

part 'hunting_cubit.freezed.dart';

@freezed
sealed class HuntingState with _$HuntingState {
  const factory HuntingState.initial() = Initial;
  const factory HuntingState.loading() = Loading;
  const factory HuntingState.data({
    required List<HuntingResult> results,
    @Default('') String query,
  }) = Data;
  const factory HuntingState.error({required String errorKey}) = Error;
}

@injectable
class HuntingCubit extends Cubit<HuntingState> {
  HuntingCubit(this._repository) : super(const HuntingState.initial());

  final HuntingRepository _repository;

  void search(String query) {
    if (query.trim().isEmpty) {
      emit(const HuntingState.initial());
      return;
    }

    emit(const HuntingState.loading());
    try {
      final results = _repository.getSearchSources(query);
      emit(HuntingState.data(results: results, query: query));
    } catch (e) {
      emit(const HuntingState.error(errorKey: 'search_error'));
    }
  }

  void clear() {
    emit(const HuntingState.initial());
  }
}

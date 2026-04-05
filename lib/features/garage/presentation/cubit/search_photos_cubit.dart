import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../data/repositories/cars_repository.dart';

part 'search_photos_state.dart';
part 'search_photos_cubit.freezed.dart';

@injectable
class SearchPhotosCubit extends Cubit<SearchPhotosState> {
  final CarsRepository _repository;

  SearchPhotosCubit(this._repository) : super(const SearchPhotosState.initial());

  Future<void> search(String query) async {
    emit(const SearchPhotosState.loading());
    try {
      final urls = await _repository.searchWebPhotos(query);
      emit(SearchPhotosState.success(urls));
    } catch (e) {
      emit(const SearchPhotosState.error('errorUnknown'));
    }
  }
}

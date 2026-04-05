part of 'search_photos_cubit.dart';

@freezed
sealed class SearchPhotosState with _$SearchPhotosState {
  const factory SearchPhotosState.initial() = SearchPhotosInitial;
  const factory SearchPhotosState.loading() = SearchPhotosLoading;
  const factory SearchPhotosState.success(List<String> urls) = SearchPhotosSuccess;
  const factory SearchPhotosState.error(String errorKey) = SearchPhotosError;
}

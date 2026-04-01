import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/error_messages.dart';
import '../../data/repositories/shared_user_repository.dart';

part 'profile_cubit.freezed.dart';

@freezed
sealed class ProfileState with _$ProfileState {
  const factory ProfileState.initial({
    @Default(false) bool isSaving,
    String? errorKey,
    String? successKey,
  }) = ProfileStateData;
}

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._sharedUserRepository)
    : super(const ProfileState.initial());

  final SharedUserRepository _sharedUserRepository;

  Future<void> saveFirstName({
    required String userId,
    required String firstName,
  }) async {
    if (state.isSaving) return;

    emit(state.copyWith(isSaving: true, errorKey: null, successKey: null));

    try {
      await _sharedUserRepository.updateFirstName(
        userId: userId,
        firstName: firstName,
      );
      emit(state.copyWith(isSaving: false, successKey: 'profile_saved'));
    } catch (error) {
      debugPrint('❌ [ProfileCubit] saveFirstName error: $error');
      emit(state.copyWith(isSaving: false, errorKey: mapErrorToKey(error)));
    }
  }

  void clearFeedback() {
    if (state.errorKey == null && state.successKey == null) return;
    emit(state.copyWith(errorKey: null, successKey: null));
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/error_messages.dart';
import '../../../settings/data/repositories/settings_repository.dart';
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
  ProfileCubit(this._sharedUserRepository, this._settingsRepository)
    : super(const ProfileState.initial());

  final SharedUserRepository _sharedUserRepository;
  final SettingsRepository _settingsRepository;

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

  Future<void> saveUsername({
    required String userId,
    required String username,
  }) async {
    if (state.isSaving) return;

    emit(state.copyWith(isSaving: true, errorKey: null, successKey: null));

    try {
      await _sharedUserRepository.updateUsername(
        userId: userId,
        username: username,
      );
      emit(state.copyWith(isSaving: false, successKey: 'profile_saved'));
    } catch (error) {
      debugPrint('❌ [ProfileCubit] saveUsername error: $error');
      emit(state.copyWith(isSaving: false, errorKey: mapErrorToKey(error)));
    }
  }

  Future<void> saveGarageName({
    required String userId,
    required String garageName,
  }) async {
    if (state.isSaving) return;

    emit(state.copyWith(isSaving: true, errorKey: null, successKey: null));

    try {
      await _settingsRepository.updateGarageName(userId, garageName);
      emit(state.copyWith(isSaving: false, successKey: 'profile_saved'));
    } catch (error) {
      debugPrint('❌ [ProfileCubit] saveGarageName error: $error');
      emit(state.copyWith(isSaving: false, errorKey: mapErrorToKey(error)));
    }
  }

  Future<void> saveProfilePhoto({
    required String userId,
    required List<int> bytes,
    required String extension,
  }) async {
    if (state.isSaving) return;

    emit(state.copyWith(isSaving: true, errorKey: null, successKey: null));

    try {
      await _sharedUserRepository.uploadProfilePhoto(
        userId: userId,
        bytes: bytes,
        extension: extension,
      );
      emit(state.copyWith(isSaving: false, successKey: 'profile_saved'));
    } catch (error) {
      debugPrint('❌ [ProfileCubit] saveProfilePhoto error: $error');
      emit(state.copyWith(isSaving: false, errorKey: mapErrorToKey(error)));
    }
  }

  void clearFeedback() {
    if (state.errorKey == null && state.successKey == null) return;
    emit(state.copyWith(errorKey: null, successKey: null));
  }
}

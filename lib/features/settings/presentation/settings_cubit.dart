import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../../shared/error_messages.dart';
import '../../auth/data/repositories/auth_repository.dart';
import '../../profiles/data/repositories/shared_user_repository.dart';
import '../../profiles/models/shared_user_model.dart';
import '../data/repositories/settings_repository.dart';
import '../models/settings_model.dart';

part 'settings_cubit.freezed.dart';

@freezed
sealed class SettingsState with _$SettingsState {
  const factory SettingsState.initial() = Initial;
  const factory SettingsState.loading() = Loading;
  const factory SettingsState.data({
    required SettingsModel settings,
    SharedUserModel? profile,
    @Default(false) bool isGuest,
    @Default(false) bool isUploadingPhoto,
    Uint8List? localPhotoBytes,
    String? pendingEmail,
  }) = Data;
  const factory SettingsState.error({String? errorKey}) = Error;
  const factory SettingsState.success({String? messageKey}) = Success;
}

@lazySingleton
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(
    this._settingsRepository,
    this._sharedUserRepository,
    this._authRepository,
  ) : super(const Initial());

  final SettingsRepository _settingsRepository;
  final SharedUserRepository _sharedUserRepository;
  final AuthRepository _authRepository;

  StreamSubscription? _settingsSub;
  StreamSubscription? _profileSub;
  StreamSubscription? _authSub;
  final _debounceTimers = <String, Timer>{};

  void _debounce(String key, Future<void> Function() action) {
    _debounceTimers[key]?.cancel();
    _debounceTimers[key] = Timer(const Duration(milliseconds: 500), action);
  }

  void init(String userId) {
    if (state is Data) {
      final currentData = state as Data;
      if (currentData.settings.id == userId) return;
    }
    emit(const Loading());
    
    _settingsSub?.cancel();
    _settingsSub = _settingsRepository.watchSettings(userId).listen(
      (settings) {
        if (settings != null) {
          final currentState = state;
          final currentProfile = currentState is Data ? currentState.profile : null;
          final isGuest = _authRepository.currentPrincipal?.isAnonymous ?? false;
          
          emit(Data(
            settings: settings, 
            profile: currentProfile,
            isGuest: isGuest,
          ));
          
          // If we don't have profile yet, start watching it
          if (_profileSub == null) {
            _watchProfile(userId);
          }

          // Watch auth changes to update isGuest
          if (_authSub == null) {
            _watchAuth();
          }
        }
      },
      onError: (e) => emit(const Error(errorKey: 'error_loading_settings')),
    );
  }

  void _watchAuth() {
    _authSub?.cancel();
    _authSub = _authRepository.watchPrincipal().listen((principal) {
      if (state is Data) {
        final data = state as Data;
        final isAnonymous = principal?.isAnonymous ?? true;
        final email = principal?.email;
        final isConfirmed = principal?.emailConfirmedAt != null;

        emit(data.copyWith(
          isGuest: isAnonymous,
          pendingEmail: (isAnonymous && email != null && !isConfirmed) ? email : null,
        ));
      }
    });
  }

  void _watchProfile(String userId) {
    _profileSub?.cancel();
    _profileSub = _sharedUserRepository.watchSharedUser(userId).listen(
      (profile) {
        if (state is Data) {
          emit((state as Data).copyWith(profile: profile));
        }
      },
      onError: (e) => debugPrint('Error watching profile: $e'),
    );
  }

  Future<void> updateGarageName(String userId, String name) async {
    final currentState = state;
    if (currentState is Data) {
      emit(currentState.copyWith(
        settings: currentState.settings.copyWith(garageName: name),
      ));
    }
    _debounce('garage_name', () async {
      try {
        await _settingsRepository.updateGarageName(userId, name);
      } catch (e) {
        emit(const Error(errorKey: 'error_updating_garage_name'));
        if (currentState is Data) emit(currentState);
      }
    });
  }

  Future<void> updateFirstName(String userId, String name) async {
    final currentState = state;
    if (currentState is Data) {
      final updatedProfile = currentState.profile?.copyWith(firstName: name);
      emit(currentState.copyWith(profile: updatedProfile));
    }
    try {
      await _sharedUserRepository.updateFirstName(userId: userId, firstName: name);
    } catch (e) {
      emit(const Error(errorKey: 'error_updating_profile'));
      if (currentState is Data) emit(currentState);
    }
  }

  Future<void> updateUsername(String userId, String username) async {
    final currentState = state;
    if (currentState is Data) {
      final updatedProfile = currentState.profile?.copyWith(username: username);
      emit(currentState.copyWith(profile: updatedProfile));
    }
    try {
      await _sharedUserRepository.updateUsername(userId: userId, username: username);
    } catch (e) {
      emit(const Error(errorKey: 'error_updating_profile'));
      if (currentState is Data) emit(currentState);
    }
  }

  Future<void> updateProfilePhoto({
    required String userId,
    required List<int> bytes,
    required String extension,
  }) async {
    final currentState = state;
    try {
      final newUrl = await _sharedUserRepository.uploadProfilePhoto(
        userId: userId,
        bytes: bytes,
        extension: extension,
      );
      
      if (currentState is Data) {
        final updatedProfile = currentState.profile?.copyWith(photoUrl: newUrl);
        emit(currentState.copyWith(profile: updatedProfile));
      }
    } catch (e) {
      emit(const Error(errorKey: 'error_updating_profile_photo'));
      if (currentState is Data) emit(currentState);
    }
  }

  Future<void> updateCurrency(String userId, AppCurrency currency) async {
    final currentState = state;
    if (currentState is Data) {
      emit(currentState.copyWith(
        settings: currentState.settings.copyWith(currency: currency),
      ));
    }
    _debounce('currency', () async {
      try {
        await _settingsRepository.updateCurrency(userId, currency);
      } catch (e) {
        emit(const Error(errorKey: 'error_updating_currency'));
        if (currentState is Data) emit(currentState);
      }
    });
  }

  Future<void> updateLanguage(String userId, AppLanguage language) async {
    final currentState = state;
    if (currentState is Data) {
      emit(currentState.copyWith(
        settings: currentState.settings.copyWith(language: language),
      ));
    }
    _debounce('language', () async {
      try {
        await _settingsRepository.updateLanguage(userId, language);
      } catch (e) {
        emit(const Error(errorKey: 'error_updating_language'));
        if (currentState is Data) emit(currentState);
      }
    });
  }

  Future<void> updateGarageBackground(String userId, String backgroundPath) async {
    final currentState = state;
    if (currentState is Data) {
      emit(currentState.copyWith(
        settings: currentState.settings.copyWith(garageBackground: backgroundPath),
      ));
    }
    _debounce('garage_background', () async {
      try {
        await _settingsRepository.updateGarageBackground(userId, backgroundPath);
      } catch (e) {
        emit(const Error(errorKey: 'error_updating_background'));
        if (currentState is Data) emit(currentState);
      }
    });
  }

  Future<String?> exportBackup() async {
    try {
      return await _settingsRepository.exportBackup();
    } catch (e) {
      emit(const Error(errorKey: 'error_exporting_backup'));
       return null;
    }
  }

  Future<void> importBackup(String filePath, String userId) async {
    final previousState = state;
    emit(const Loading());
    try {
      await _settingsRepository.importBackup(filePath);
      init(userId);
      emit(const Success(messageKey: 'backup_restored_successfully'));
    } catch (e) {
      emit(const Error(errorKey: 'error_importing_backup'));
      if (previousState is Data) {
        emit(previousState);
      }
    }
  }

  Future<void> upgradeAccount({
    required String email,
    required String password,
  }) async {
    final currentState = state;
    if (currentState is! Data) return;

    emit(const Loading());
    try {
      await _authRepository.upgradeAnonymousWithEmail(
        email: email,
        password: password,
      );
      // Wait a bit for the auth change to propagate
      await Future.delayed(const Duration(milliseconds: 500));
      emit(const Success(messageKey: 'account_upgraded_successfully'));
      emit(currentState.copyWith(isGuest: false));
    } catch (e) {
      debugPrint('Error upgrading account: $e');
      emit(Error(errorKey: mapErrorToKey(e)));
      emit(currentState);
    }
  }

  @override
  Future<void> close() {
    _settingsSub?.cancel();
    _profileSub?.cancel();
    _authSub?.cancel();
    for (final timer in _debounceTimers.values) {
      timer.cancel();
    }
    return super.close();
  }
}

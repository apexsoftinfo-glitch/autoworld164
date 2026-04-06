import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../models/shared_user_model.dart';
import '../datasources/shared_user_data_source.dart';

abstract class SharedUserRepository {
  Stream<SharedUserModel?> watchSharedUser(String userId);

  Future<SharedUserModel?> getSharedUser(String userId);

  Future<SharedUserModel> ensureSharedUser(String userId);

  Future<void> updateFirstName({
    required String userId,
    required String firstName,
  });

  Future<void> updateUsername({
    required String userId,
    required String username,
  });

  Future<void> updatePhotoUrl({
    required String userId,
    required String photoUrl,
  });

  Future<void> uploadProfilePhoto({
    required String userId,
    required List<int> bytes,
    required String extension,
  });
}

@LazySingleton(as: SharedUserRepository)
class SharedUserRepositoryImpl implements SharedUserRepository {
  SharedUserRepositoryImpl(this._sharedUserDataSource);

  final SharedUserDataSource _sharedUserDataSource;

  @override
  Stream<SharedUserModel?> watchSharedUser(String userId) {
    return _sharedUserDataSource.watchSharedUser(userId).map(_mapSharedUser);
  }

  @override
  Future<SharedUserModel?> getSharedUser(String userId) async {
    final rawSharedUser = await _sharedUserDataSource.getSharedUser(userId);
    return _mapSharedUser(rawSharedUser);
  }

  @override
  Future<SharedUserModel> ensureSharedUser(String userId) async {
    try {
      final rawSharedUser = await _sharedUserDataSource.ensureSharedUser(
        userId,
      );
      return _mapSharedUser(rawSharedUser)!;
    } catch (error) {
      debugPrint('❌ [SharedUserRepository] ensureSharedUser error: $error');
      rethrow;
    }
  }

  @override
  Future<void> updateFirstName({
    required String userId,
    required String firstName,
  }) async {
    try {
      final currentSharedUser = await ensureSharedUser(userId);
      final updatedSharedUser = currentSharedUser.copyWith(
        firstName: firstName.trim().isEmpty ? null : firstName.trim(),
      );

      await _sharedUserDataSource.upsertSharedUser(updatedSharedUser.toJson());
    } catch (error) {
      debugPrint('❌ [SharedUserRepository] updateFirstName error: $error');
      rethrow;
    }
  }

  @override
  Future<void> updateUsername({
    required String userId,
    required String username,
  }) async {
    try {
      final currentSharedUser = await ensureSharedUser(userId);
      final updatedSharedUser = currentSharedUser.copyWith(
        username: username.trim().isEmpty ? null : username.trim(),
      );

      await _sharedUserDataSource.upsertSharedUser(updatedSharedUser.toJson());
    } catch (error) {
      debugPrint('❌ [SharedUserRepository] updateUsername error: $error');
      rethrow;
    }
  }

  @override
  Future<void> updatePhotoUrl({
    required String userId,
    required String photoUrl,
  }) async {
    try {
      final currentSharedUser = await ensureSharedUser(userId);
      final updatedSharedUser = currentSharedUser.copyWith(
        photoUrl: photoUrl.trim().isEmpty ? null : photoUrl.trim(),
      );

      await _sharedUserDataSource.upsertSharedUser(updatedSharedUser.toJson());
    } catch (error) {
      debugPrint('❌ [SharedUserRepository] updatePhotoUrl error: $error');
      rethrow;
    }
  }

  @override
  Future<void> uploadProfilePhoto({
    required String userId,
    required List<int> bytes,
    required String extension,
  }) async {
    try {
      final url = await _sharedUserDataSource.uploadProfilePhoto(userId, bytes, extension);
      await updatePhotoUrl(userId: userId, photoUrl: url);
    } catch (error) {
      debugPrint('❌ [SharedUserRepository] uploadProfilePhoto error: $error');
      rethrow;
    }
  }

  SharedUserModel? _mapSharedUser(Map<String, dynamic>? raw) {
    if (raw == null) return null;

    return SharedUserModel.fromJson(raw);
  }
}

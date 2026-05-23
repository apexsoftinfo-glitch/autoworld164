import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

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

  Future<String> uploadProfilePhoto({
    required String userId,
    required List<int> bytes,
    required String extension,
  });

  Future<String> uploadLocalFile({
    required List<int> bytes,
    required String extension,
    String prefix = 'file',
  });
}

@LazySingleton(as: SharedUserRepository)
class SharedUserRepositoryImpl implements SharedUserRepository {
  SharedUserRepositoryImpl(this._sharedUserDataSource);

  final SharedUserDataSource _sharedUserDataSource;
  final _photoOverrides = BehaviorSubject<Map<String, String>>.seeded({});
  final _userSubjects = <String, BehaviorSubject<SharedUserModel?>>{};

  BehaviorSubject<SharedUserModel?> _subjectFor(String userId) {
    return _userSubjects.putIfAbsent(userId, () {
      final subject = BehaviorSubject<SharedUserModel?>.seeded(null);
      
      // Load initial value from data source asynchronously via direct REST
      _sharedUserDataSource.getSharedUser(userId).then((raw) async {
        if (raw == null) {
          try {
            final ensured = await _sharedUserDataSource.ensureSharedUser(userId);
            subject.add(_mapSharedUser(ensured));
          } catch (e) {
            debugPrint('❌ [SharedUserRepository] Failed to ensure shell user: $e');
          }
        } else {
          subject.add(_mapSharedUser(raw));
        }
      }).catchError((Object error) {
        debugPrint('❌ [SharedUserRepository] Failed to load user: $error');
      });
      
      return subject;
    });
  }

  @override
  Stream<SharedUserModel?> watchSharedUser(String userId) {
    return Rx.combineLatest2<SharedUserModel?, Map<String, String>, SharedUserModel?>(
      _subjectFor(userId).stream,
      _photoOverrides.stream,
      (model, overrides) {
        if (model == null) return null;
        final overrideUrl = overrides[userId];
        if (overrideUrl != null) {
          return model.copyWith(photoUrl: overrideUrl);
        }
        return model;
      },
    ).distinct();
  }

  @override
  Future<SharedUserModel?> getSharedUser(String userId) async {
    final rawSharedUser = await _sharedUserDataSource.getSharedUser(userId);
    final model = _mapSharedUser(rawSharedUser);
    if (model == null) return null;

    // Update local cache
    _subjectFor(userId).add(model);

    final overrideUrl = _photoOverrides.value[userId];
    if (overrideUrl != null) {
      return model.copyWith(photoUrl: overrideUrl);
    }
    return model;
  }

  @override
  Future<SharedUserModel> ensureSharedUser(String userId) async {
    try {
      final rawSharedUser = await _sharedUserDataSource.ensureSharedUser(
        userId,
      );
      final model = _mapSharedUser(rawSharedUser)!;

      // Update local cache
      _subjectFor(userId).add(model);

      final overrideUrl = _photoOverrides.value[userId];
      if (overrideUrl != null) {
        return model.copyWith(photoUrl: overrideUrl);
      }
      return model;
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

      // Update local cache
      _subjectFor(userId).add(updatedSharedUser);
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

      // Update local cache
      _subjectFor(userId).add(updatedSharedUser);
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

      // Update local cache
      _subjectFor(userId).add(updatedSharedUser);
      
      // Update local override for instant UI feedback across app
      final currentOverrides = Map<String, String>.from(_photoOverrides.value);
      currentOverrides[userId] = photoUrl;
      _photoOverrides.add(currentOverrides);
    } catch (error) {
      debugPrint('❌ [SharedUserRepository] updatePhotoUrl error: $error');
      rethrow;
    }
  }

  @override
  Future<String> uploadProfilePhoto({
    required String userId,
    required List<int> bytes,
    required String extension,
  }) async {
    try {
      final url = await _sharedUserDataSource.saveLocalImage(bytes, extension, prefix: 'profile_$userId');
      await updatePhotoUrl(userId: userId, photoUrl: url);
      return url;
    } catch (error) {
      debugPrint('❌ [SharedUserRepository] uploadProfilePhoto error: $error');
      rethrow;
    }
  }

  @override
  Future<String> uploadLocalFile({
    required List<int> bytes,
    required String extension,
    String prefix = 'file',
  }) async {
    try {
      return await _sharedUserDataSource.saveLocalImage(bytes, extension, prefix: prefix);
    } catch (error) {
      debugPrint('❌ [SharedUserRepository] uploadLocalFile error: $error');
      rethrow;
    }
  }

  SharedUserModel? _mapSharedUser(Map<String, dynamic>? raw) {
    if (raw == null) return null;

    return SharedUserModel.fromJson(raw);
  }
}

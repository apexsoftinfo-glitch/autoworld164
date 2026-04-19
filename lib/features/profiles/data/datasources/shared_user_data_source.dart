import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:rxdart/rxdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SharedUserDataSource {
  Stream<Map<String, dynamic>?> watchSharedUser(String userId);

  Future<Map<String, dynamic>?> getSharedUser(String userId);

  Future<void> upsertSharedUser(Map<String, dynamic> sharedUser);

  Future<Map<String, dynamic>> ensureSharedUser(String userId);
  Future<String> uploadProfilePhoto(String userId, List<int> bytes, String extension);
}

@LazySingleton(as: SharedUserDataSource)
class SupabaseSharedUserDataSource implements SharedUserDataSource {
  SupabaseSharedUserDataSource(this._supabaseClient);

  final SupabaseClient _supabaseClient;

  @override
  Stream<Map<String, dynamic>?> watchSharedUser(String userId) {
    debugPrint(
      'ℹ️ [SharedUserDataSource] watchSharedUser subscribed userId=$userId',
    );
    return RetryWhenStream<Map<String, dynamic>?>(
      () => _supabaseClient
          .from('shared_users')
          .stream(primaryKey: ['id'])
          .eq('id', userId)
          .asyncExpand((rows) async* {
            debugPrint(
              'ℹ️ [SharedUserDataSource] watchSharedUser rows userId=$userId count=${rows.length}',
            );
            if (rows.isEmpty) {
              debugPrint(
                '⚠️ [SharedUserDataSource] shared user missing; ensuring shell row userId=$userId',
              );
              final ensuredSharedUser = await ensureSharedUser(userId);
              debugPrint(
                '✅ [SharedUserDataSource] ensured shared user userId=$userId firstName=${ensuredSharedUser['first_name'] ?? "-"}',
              );
              yield ensuredSharedUser;
              return;
            }

            final sharedUser = Map<String, dynamic>.from(rows.first);
            debugPrint(
              'ℹ️ [SharedUserDataSource] shared user received userId=$userId firstName=${sharedUser['first_name'] ?? "-"}',
            );
            yield sharedUser;
          }),
      (Object error, StackTrace stackTrace) {
        final errorStr = error.toString();
        if (errorStr.contains('RealtimeSubscribeException') ||
            errorStr.contains('timedOut')) {
          debugPrint(
            'ℹ️ [SharedUserDataSource] Realtime timeout detected, retrying watchSharedUser in 2s...',
          );
          return Stream<void>.value(null).delay(const Duration(seconds: 2));
        }
        return Stream<void>.error(error, stackTrace);
      },
    );
  }

  @override
  Future<Map<String, dynamic>?> getSharedUser(String userId) async {
    debugPrint(
      'ℹ️ [SharedUserDataSource] getSharedUser started userId=$userId',
    );
    final response = await _supabaseClient
        .from('shared_users')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (response == null) {
      debugPrint(
        '⚠️ [SharedUserDataSource] getSharedUser userId=$userId not found',
      );
      return null;
    }
    debugPrint('✅ [SharedUserDataSource] getSharedUser userId=$userId found');
    return Map<String, dynamic>.from(response);
  }

  @override
  Future<void> upsertSharedUser(Map<String, dynamic> sharedUser) async {
    debugPrint(
      'ℹ️ [SharedUserDataSource] upsertSharedUser started userId=${sharedUser['id']}',
    );
    await _supabaseClient.from('shared_users').upsert(sharedUser);
    debugPrint(
      '✅ [SharedUserDataSource] upsertSharedUser succeeded userId=${sharedUser['id']}',
    );
  }

  @override
  Future<Map<String, dynamic>> ensureSharedUser(String userId) async {
    debugPrint(
      'ℹ️ [SharedUserDataSource] ensureSharedUser started userId=$userId',
    );
    final existingSharedUser = await getSharedUser(userId);
    if (existingSharedUser != null) {
      debugPrint(
        'ℹ️ [SharedUserDataSource] ensureSharedUser existing row reused userId=$userId',
      );
      return existingSharedUser;
    }

    final shellSharedUser = <String, dynamic>{
      'id': userId,
      'first_name': null,
      'username': null,
      'photo_url': null,
    };

    await upsertSharedUser(shellSharedUser);
    debugPrint(
      '✅ [SharedUserDataSource] ensureSharedUser created shell row userId=$userId',
    );
    return shellSharedUser;
  }

  @override
  Future<String> uploadProfilePhoto(String userId, List<int> bytes, String extension) async {
    final docs = await getApplicationDocumentsDirectory();
    final photosDir = Directory(p.join(docs.path, 'autoworld_photos'));
    if (!await photosDir.exists()) {
      await photosDir.create(recursive: true);
    }
    
    final filename = 'profile_${userId}_${DateTime.now().millisecondsSinceEpoch}.$extension';
    final file = File(p.join(photosDir.path, filename));
    await file.writeAsBytes(bytes);
    
    return filename;
  }
}

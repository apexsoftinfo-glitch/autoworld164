import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SettingsDataSource {
  Stream<Map<String, dynamic>?> watchSettings(String userId);
  Future<Map<String, dynamic>?> getSettings(String userId);
  Future<void> upsertSettings(Map<String, dynamic> settings);
  Future<Map<String, dynamic>> ensureSettings(String userId);
}

@LazySingleton(as: SettingsDataSource)
class SupabaseSettingsDataSource implements SettingsDataSource {
  SupabaseSettingsDataSource(this._supabaseClient);

  final SupabaseClient _supabaseClient;

  @override
  Stream<Map<String, dynamic>?> watchSettings(String userId) {
    return _supabaseClient
        .from('autoworld_settings')
        .stream(primaryKey: ['id'])
        .eq('id', userId)
        .asyncExpand((rows) async* {
          if (rows.isEmpty) {
            final ensuredSettings = await ensureSettings(userId);
            yield ensuredSettings;
            return;
          }
          yield Map<String, dynamic>.from(rows.first);
        });
  }

  @override
  Future<Map<String, dynamic>?> getSettings(String userId) async {
    final response = await _supabaseClient
        .from('autoworld_settings')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (response == null) return null;
    return Map<String, dynamic>.from(response);
  }

  @override
  Future<void> upsertSettings(Map<String, dynamic> settings) async {
    await _supabaseClient.from('autoworld_settings').upsert(settings);
  }

  @override
  Future<Map<String, dynamic>> ensureSettings(String userId) async {
    final existingSettings = await getSettings(userId);
    if (existingSettings != null) return existingSettings;

    final shellSettings = <String, dynamic>{
      'id': userId,
      'currency': 'usd',
      'language': 'pl',
    };

    await upsertSettings(shellSettings);
    return shellSettings;
  }
}

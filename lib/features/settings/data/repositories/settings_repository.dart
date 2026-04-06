import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/settings_model.dart';
import '../datasources/settings_data_source.dart';

abstract class SettingsRepository {
  Stream<SettingsModel?> watchSettings(String userId);
  Future<SettingsModel?> getSettings(String userId);
  Future<void> updateGarageName(String userId, String? name);
  Future<void> updateCurrency(String userId, AppCurrency currency);
  Future<void> updateLanguage(String userId, AppLanguage language);
  Future<String> exportBackup();
  Future<void> importBackup(String filePath);
}

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._settingsDataSource);

  final SettingsDataSource _settingsDataSource;

  @override
  Stream<SettingsModel?> watchSettings(String userId) {
    return _settingsDataSource.watchSettings(userId).map((json) {
      if (json == null) return null;
      return SettingsModel.fromJson(json);
    });
  }

  @override
  Future<SettingsModel?> getSettings(String userId) async {
    final json = await _settingsDataSource.getSettings(userId);
    if (json == null) return null;
    return SettingsModel.fromJson(json);
  }

  @override
  Future<void> updateGarageName(String userId, String? name) async {
    final current = await _settingsDataSource.ensureSettings(userId);
    final updated = {...current, 'garage_name': name};
    await _settingsDataSource.upsertSettings(updated);
  }

  @override
  Future<void> updateCurrency(String userId, AppCurrency currency) async {
    final current = await _settingsDataSource.ensureSettings(userId);
    final updated = {...current, 'currency': currency.name};
    await _settingsDataSource.upsertSettings(updated);
  }

  @override
  Future<void> updateLanguage(String userId, AppLanguage language) async {
    final current = await _settingsDataSource.ensureSettings(userId);
    final updated = {...current, 'language': language.name};
    await _settingsDataSource.upsertSettings(updated);
  }

  @override
  Future<String> exportBackup() async {
    final supabase = GetIt.I<SupabaseClient>();
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('unauthenticated');

    final cars = await supabase.from('autoworld_cars').select();
    final settings = await supabase.from('autoworld_settings').select().eq('id', userId).maybeSingle();
    final profile = await supabase.from('shared_users').select().eq('id', userId).maybeSingle();

    final backupData = {
      'version': 1,
      'exported_at': DateTime.now().toIso8601String(),
      'cars': cars,
      'settings': settings,
      'profile': profile,
    };

    final docs = await getApplicationDocumentsDirectory();
    final tempDir = await getTemporaryDirectory();
    final backupFileName = 'autoworld_backup_${DateTime.now().millisecondsSinceEpoch}.zip';
    final backupPath = p.join(tempDir.path, backupFileName);

    final archive = Archive();

    // Add data.json
    final dataJson = jsonEncode(backupData);
    archive.addFile(ArchiveFile('data.json', dataJson.length, utf8.encode(dataJson)));

    // Add photos
    final photosDir = Directory(p.join(docs.path, 'autoworld_photos'));
    if (await photosDir.exists()) {
      final files = photosDir.listSync();
      for (final file in files) {
        if (file is File) {
          final bytes = await file.readAsBytes();
          archive.addFile(ArchiveFile(
            'photos/${p.basename(file.path)}',
            bytes.length,
            bytes,
          ));
        }
      }
    }

    final zipEncoder = ZipEncoder();
    final encodedArchive = zipEncoder.encode(archive);
    
    await File(backupPath).writeAsBytes(encodedArchive);
    return backupPath;
  }

  @override
  Future<void> importBackup(String filePath) async {
    final bytes = await File(filePath).readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    final dataFile = archive.findFile('data.json');
    if (dataFile == null) throw Exception('invalid_backup_file');

    final dataJson = utf8.decode(dataFile.content as List<int>);
    final data = jsonDecode(dataJson) as Map<String, dynamic>;

    final supabase = GetIt.I<SupabaseClient>();
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('unauthenticated');

    // Restore photos
    final docs = await getApplicationDocumentsDirectory();
    final photosDir = Directory(p.join(docs.path, 'autoworld_photos'));
    if (!await photosDir.exists()) {
      await photosDir.create(recursive: true);
    }

    for (final file in archive) {
      if (file.name.startsWith('photos/') && file.isFile) {
        final fileName = p.basename(file.name);
        final localFile = File(p.join(photosDir.path, fileName));
        await localFile.writeAsBytes(file.content as List<int>);
      }
    }

    // Restore data to Supabase
    final cars = data['cars'] as List;
    final settings = data['settings'] as Map<String, dynamic>?;
    final profile = data['profile'] as Map<String, dynamic>?;

    // Delete existing cars for this user if they choose to overwrite? 
    // Usually restore means complete overwrite.
    await supabase.from('autoworld_cars').delete().eq('user_id', userId);
    
    if (cars.isNotEmpty) {
      // Clear IDs to avoid conflicts if they are from different env, but wait, usually we keep them.
      // But user_id must be updated to CURRENT user id.
      final modifiedCars = cars.map((c) {
         final car = Map<String, dynamic>.from(c as Map);
         car['user_id'] = userId;
         // Ensure we don't try to insert 'id' if it's generated, 
         // but wait, if it's UUID we can insert it.
         return car;
      }).toList();
      await supabase.from('autoworld_cars').insert(modifiedCars);
    }

    if (settings != null) {
      final s = Map<String, dynamic>.from(settings);
      s['user_id'] = userId;
      await supabase.from('autoworld_settings').upsert(s);
    }

    if (profile != null) {
      final pData = Map<String, dynamic>.from(profile);
      pData['id'] = userId;
      await supabase.from('shared_users').upsert(pData);
    }
  }
}

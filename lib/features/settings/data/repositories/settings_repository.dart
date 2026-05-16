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
  Future<void> updateGarageBackground(String userId, String backgroundPath);
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
  Future<void> updateGarageBackground(String userId, String backgroundPath) async {
    final current = await _settingsDataSource.ensureSettings(userId);
    final updated = {...current, 'garage_background': backgroundPath};
    await _settingsDataSource.upsertSettings(updated);
  }

  @override
  Future<String> exportBackup() async {
    final supabase = GetIt.I<SupabaseClient>();
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('unauthenticated');

    final cars = await supabase.from('autoworld_cars').select();
    final market = await supabase.from('autoworld_market').select();
    final series = await supabase.from('autoworld_series').select();
    final producers = await supabase.from('autoworld_producers').select();
    final settings = await supabase.from('autoworld_settings').select().eq('id', userId).maybeSingle();
    final profile = await supabase.from('shared_users').select().eq('id', userId).maybeSingle();

    final backupData = {
      'version': 2,
      'exported_at': DateTime.now().toIso8601String(),
      'cars': cars,
      'market': market,
      'series': series,
      'producers': producers,
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

    // Add photos from both folders
    final photoFolders = ['autoworld_photos', 'autoworld_market_photos'];
    for (final folder in photoFolders) {
      final dir = Directory(p.join(docs.path, folder));
      if (await dir.exists()) {
        final files = dir.listSync();
        for (final file in files) {
          if (file is File) {
            final bytes = await file.readAsBytes();
            archive.addFile(ArchiveFile(
              '$folder/${p.basename(file.path)}',
              bytes.length,
              bytes,
            ));
          }
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
    for (final file in archive) {
      if (file.isFile && (file.name.startsWith('autoworld_photos/') || file.name.startsWith('autoworld_market_photos/'))) {
        final localPath = p.join(docs.path, file.name);
        final localFile = File(localPath);
        if (!await localFile.parent.exists()) {
          await localFile.parent.create(recursive: true);
        }
        await localFile.writeAsBytes(file.content as List<int>);
      }
    }

    // Restore data to Supabase
    final cars = data['cars'] as List?;
    final market = data['market'] as List?;
    final series = data['series'] as List?;
    final producers = data['producers'] as List?;
    final settings = data['settings'] as Map<String, dynamic>?;
    final profile = data['profile'] as Map<String, dynamic>?;

    // Helper to prepare data for insertion/upsertion
    List<Map<String, dynamic>> prepareList(List? list, {bool stripId = true}) {
      if (list == null) return [];
      return list.map((item) {
        final map = Map<String, dynamic>.from(item as Map);
        map['user_id'] = userId;
        if (stripId) map.remove('id'); // Remove ID to avoid PK conflicts if moving across accounts
        return map;
      }).toList();
    }

    // 1. Cars
    await supabase.from('autoworld_cars').delete().eq('user_id', userId);
    final preparedCars = prepareList(cars);
    if (preparedCars.isNotEmpty) {
      await supabase.from('autoworld_cars').insert(preparedCars);
    }

    // 2. Market
    await supabase.from('autoworld_market').delete().eq('user_id', userId);
    final preparedMarket = prepareList(market);
    if (preparedMarket.isNotEmpty) {
      await supabase.from('autoworld_market').insert(preparedMarket);
    }

    // 3. Series
    await supabase.from('autoworld_series').delete().eq('user_id', userId);
    final preparedSeries = prepareList(series);
    if (preparedSeries.isNotEmpty) {
      await supabase.from('autoworld_series').insert(preparedSeries);
    }

    // 4. Producers
    await supabase.from('autoworld_producers').delete().eq('user_id', userId);
    final preparedProducers = prepareList(producers);
    if (preparedProducers.isNotEmpty) {
      await supabase.from('autoworld_producers').insert(preparedProducers);
    }

    // 5. Settings
    if (settings != null) {
      final s = Map<String, dynamic>.from(settings);
      s['id'] = userId;
      s.remove('user_id');
      await supabase.from('autoworld_settings').upsert(s);
    }

    // 6. Profile
    if (profile != null) {
      final pData = Map<String, dynamic>.from(profile);
      pData['id'] = userId;
      await supabase.from('shared_users').upsert(pData);
    }
  }
}

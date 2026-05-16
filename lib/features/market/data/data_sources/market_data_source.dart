import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

abstract class MarketDataSource {
  Stream<List<Map<String, dynamic>>> watchMarketCars();
  Future<List<Map<String, dynamic>>> getMarketCars();
  Future<void> addMarketCar(Map<String, dynamic> data, List<File> photos, List<String> internetUrls, {List<String> initialPhotoPaths = const []});
  Future<void> editMarketCar(
    String id,
    Map<String, dynamic> data,
    List<File> newPhotos,
    List<String> internetUrls,
    List<String> oldPhotoPaths,
  );
  Future<void> deleteMarketCar(String id, List<String> photoPaths);
}

@LazySingleton(as: MarketDataSource)
class MarketDataSourceImpl implements MarketDataSource {
  MarketDataSourceImpl(this._supabase);

  final SupabaseClient _supabase;

  @override
  Stream<List<Map<String, dynamic>>> watchMarketCars() {
    return _supabase
        .from('autoworld_market')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false);
  }

  @override
  Future<List<Map<String, dynamic>>> getMarketCars() async {
    return await _supabase
        .from('autoworld_market')
        .select()
        .order('created_at', ascending: false);
  }

  Future<String> _getPhotosDir() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, 'autoworld_photos'));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir.path;
  }

  Future<List<String>> _savePhotosLocally(List<File> photos) async {
    final dir = await _getPhotosDir();
    final paths = <String>[];
    for (final photo in photos) {
      final fileName = 'mkt_${DateTime.now().millisecondsSinceEpoch}_local_${paths.length}${p.extension(photo.path)}';
      final path = p.join(dir, fileName);
      await photo.copy(path);
      paths.add(fileName);
    }
    return paths;
  }

  Future<List<String>> _saveFromUrlsLocally(List<String> urls) async {
    final dir = await _getPhotosDir();
    final paths = <String>[];
    for (final url in urls) {
      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final fileName = 'mkt_${DateTime.now().millisecondsSinceEpoch}_remote_${paths.length}.jpg';
          final path = p.join(dir, fileName);
          await File(path).writeAsBytes(response.bodyBytes);
          paths.add(fileName);
        }
      } catch (e) {
        debugPrint('Error downloading from URL $url: $e');
      }
    }
    return paths;
  }

  Future<List<String>> _copyExistingPhotos(List<String> fileNames) async {
    if (fileNames.isEmpty) return [];
    
    final dir = await _getPhotosDir();
    final paths = <String>[];
    for (final fileName in fileNames) {
      try {
        final sourceFile = File(p.join(dir, fileName));
        if (await sourceFile.exists()) {
          final newFileName = 'mkt_${DateTime.now().millisecondsSinceEpoch}_moved_${paths.length}${p.extension(fileName)}';
          final targetPath = p.join(dir, newFileName);
          await sourceFile.copy(targetPath);
          paths.add(newFileName);
        }
      } catch (e) {
        debugPrint('Error copying/referencing photo $fileName: $e');
      }
    }
    return paths;
  }

  @override
  Future<void> addMarketCar(Map<String, dynamic> data, List<File> photos, List<String> internetUrls, {List<String> initialPhotoPaths = const []}) async {
    final localPaths = await _savePhotosLocally(photos);
    final remotePaths = await _saveFromUrlsLocally(internetUrls);
    final movedPaths = await _copyExistingPhotos(initialPhotoPaths);

    await _supabase.from('autoworld_market').insert({
      ...data,
      'photo_paths': [...movedPaths, ...localPaths, ...remotePaths],
    });
  }

  @override
  Future<void> editMarketCar(
    String id,
    Map<String, dynamic> data,
    List<File> newPhotos,
    List<String> internetUrls,
    List<String> oldPhotoPaths,
  ) async {
    final localPaths = await _savePhotosLocally(newPhotos);
    final remotePaths = await _saveFromUrlsLocally(internetUrls);
    
    final currentPathsInDb = data['photo_paths'] as List? ?? [];
    
    await _supabase.from('autoworld_market').update({
      ...data,
      'photo_paths': [...currentPathsInDb, ...localPaths, ...remotePaths],
    }).eq('id', id);
  }

  @override
  Future<void> deleteMarketCar(String id, List<String> photoPaths) async {
    await _supabase.from('autoworld_market').delete().eq('id', id);

    // We don't delete local photos when deleting a market car if they might be used elsewhere (e.g. still in garage)
    // But if they have 'mkt_' prefix, maybe we should?
    // User said "tak samo jak w garażu". In garage they are deleted.
    if (photoPaths.isNotEmpty) {
      final dir = await _getPhotosDir();
      for (final fileName in photoPaths) {
        // Only delete if it's a market-specific photo (starts with mkt_) 
        // to avoid deleting photos that might still be in the garage (moved models)
        if (fileName.startsWith('mkt_')) {
          final file = File(p.join(dir, fileName));
          if (await file.exists()) {
            await file.delete();
          }
        }
      }
    }
  }
}

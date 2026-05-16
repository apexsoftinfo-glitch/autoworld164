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

  Future<List<String>> _uploadPhotos(List<File> photos) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final paths = <String>[];
    for (final photo in photos) {
      try {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_${paths.length}${p.extension(photo.path)}';
        final storagePath = '$userId/$fileName';
        
        await _supabase.storage.from('autoworld_photos').upload(
          storagePath,
          photo,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );
        
        paths.add(storagePath);
      } catch (e) {
        debugPrint('Error uploading photo: $e');
      }
    }
    return paths;
  }

  Future<List<String>> _uploadFromUrls(List<String> urls) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final paths = <String>[];
    for (final url in urls) {
      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final fileName = '${DateTime.now().millisecondsSinceEpoch}_remote_${paths.length}.jpg';
          final storagePath = '$userId/$fileName';
          
          await _supabase.storage.from('autoworld_photos').uploadBinary(
            storagePath,
            response.bodyBytes,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );
          
          paths.add(storagePath);
        }
      } catch (e) {
        debugPrint('Error uploading from URL $url: $e');
      }
    }
    return paths;
  }

  Future<List<String>> _copyAndUploadExistingPhotos(List<String> fileNames) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null || fileNames.isEmpty) return [];
    
    final docs = await getApplicationDocumentsDirectory();
    final sourceDir = p.join(docs.path, 'autoworld_photos');
    
    final paths = <String>[];
    for (final fileName in fileNames) {
      try {
        final sourceFile = File(p.join(sourceDir, fileName));
        if (await sourceFile.exists()) {
          final storagePath = '$userId/${DateTime.now().millisecondsSinceEpoch}_$fileName';
          
          await _supabase.storage.from('autoworld_photos').upload(
            storagePath,
            sourceFile,
          );
          paths.add(storagePath);
        }
      } catch (e) {
        debugPrint('Error uploading existing photo $fileName: $e');
      }
    }
    return paths;
  }

  @override
  Future<void> addMarketCar(Map<String, dynamic> data, List<File> photos, List<String> internetUrls, {List<String> initialPhotoPaths = const []}) async {
    final storagePaths = await _uploadPhotos(photos);
    final remoteStoragePaths = await _uploadFromUrls(internetUrls);
    final movedStoragePaths = await _copyAndUploadExistingPhotos(initialPhotoPaths);

    await _supabase.from('autoworld_market').insert({
      ...data,
      'photo_paths': [...movedStoragePaths, ...storagePaths, ...remoteStoragePaths],
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
    final storagePaths = await _uploadPhotos(newPhotos);
    final remoteStoragePaths = await _uploadFromUrls(internetUrls);
    
    final currentPathsInDb = data['photo_paths'] as List? ?? [];
    
    await _supabase.from('autoworld_market').update({
      ...data,
      'photo_paths': [...currentPathsInDb, ...storagePaths, ...remoteStoragePaths],
    }).eq('id', id);
  }

  @override
  Future<void> deleteMarketCar(String id, List<String> photoPaths) async {
    await _supabase.from('autoworld_market').delete().eq('id', id);

    if (photoPaths.isNotEmpty) {
      try {
        await _supabase.storage.from('autoworld_photos').remove(photoPaths);
      } catch (e) {
        debugPrint('Error removing photos from storage: $e');
      }
    }
  }
}

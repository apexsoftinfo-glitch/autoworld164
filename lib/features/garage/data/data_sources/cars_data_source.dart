import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

abstract class CarsDataSource {
  Stream<List<Map<String, dynamic>>> watchCars();
  Future<void> addCar(Map<String, dynamic> data, List<File> photos, List<String> internetUrls);
  Future<void> editCar(
    String id,
    Map<String, dynamic> data,
    List<File> newPhotos,
    List<String> internetUrls,
    List<String> oldPhotoPaths,
  );
  Future<void> deleteCar(String id, List<String> photoPaths);
  
  // Series autocomplete
  Future<List<String>> fetchSeries();
  Future<void> addSeries(String name);
}

@LazySingleton(as: CarsDataSource)
class CarsDataSourceImpl implements CarsDataSource {
  CarsDataSourceImpl(this._supabase);

  final SupabaseClient _supabase;

  @override
  Stream<List<Map<String, dynamic>>> watchCars() {
    try {
      return _supabase
          .from('autoworld_cars')
          .stream(primaryKey: ['id'])
          .order('created_at', ascending: false);
    } catch (e, stack) {
      debugPrint('CarsDataSourceImpl watchCars error: $e\n$stack');
      rethrow;
    }
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
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_local_${paths.length}${p.extension(photo.path)}';
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
          final fileName = '${DateTime.now().millisecondsSinceEpoch}_remote_${paths.length}.jpg';
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

  @override
  Future<void> addCar(Map<String, dynamic> data, List<File> photos, List<String> internetUrls) async {
    try {
      final localPaths = await _savePhotosLocally(photos);
      final remotePaths = await _saveFromUrlsLocally(internetUrls);

      await _supabase.from('autoworld_cars').insert({
        ...data,
        'photo_paths': [...localPaths, ...remotePaths],
      });
    } catch (e, stack) {
      debugPrint('CarsDataSourceImpl addCar error: $e\n$stack');
      rethrow;
    }
  }

  @override
  Future<void> editCar(
    String id,
    Map<String, dynamic> data,
    List<File> newPhotos,
    List<String> internetUrls,
    List<String> oldPhotoPaths,
  ) async {
    try {
      final localPaths = await _savePhotosLocally(newPhotos);
      final remotePaths = await _saveFromUrlsLocally(internetUrls);
      
      final currentPathsInDb = data['photo_paths'] as List? ?? [];
      
      await _supabase.from('autoworld_cars').update({
        ...data,
        'photo_paths': [...currentPathsInDb, ...localPaths, ...remotePaths],
      }).eq('id', id);
    } catch (e, stack) {
      debugPrint('CarsDataSourceImpl editCar error: $e\n$stack');
      rethrow;
    }
  }

  @override
  Future<void> deleteCar(String id, List<String> photoPaths) async {
    try {
      await _supabase.from('autoworld_cars').delete().eq('id', id);

      if (photoPaths.isNotEmpty) {
        final dir = await _getPhotosDir();
        for (final fileName in photoPaths) {
          final file = File(p.join(dir, fileName));
          if (await file.exists()) {
            await file.delete();
          }
        }
      }
    } catch (e, stack) {
      debugPrint('CarsDataSourceImpl deleteCar error: $e\n$stack');
      rethrow;
    }
  }

  @override
  Future<List<String>> fetchSeries() async {
    final response = await _supabase.from('autoworld_series').select('name').order('name');
    return (response as List).map((e) => e['name'] as String).toList();
  }

  @override
  Future<void> addSeries(String name) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;
    await _supabase.from('autoworld_series').upsert({
      'name': name,
      'user_id': userId,
    }, onConflict: 'name, user_id');
  }
}

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class CarsDataSource {
  Stream<List<Map<String, dynamic>>> watchCars();
  Future<void> addCar(Map<String, dynamic> data, List<File> photos);
  Future<void> editCar(
    String id,
    Map<String, dynamic> data,
    List<File> newPhotos,
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

  Future<List<String>> _uploadPhotos(List<File> photos) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('unauthenticated');
    
    final paths = <String>[];
    for (final photo in photos) {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${paths.length}.jpg';
      final path = '$userId/$fileName';
      await _supabase.storage.from('autoworld_photos').upload(path, photo);
      paths.add(path);
    }
    return paths;
  }

  @override
  Future<void> addCar(Map<String, dynamic> data, List<File> photos) async {
    try {
      final photoPaths = await _uploadPhotos(photos);

      await _supabase.from('autoworld_cars').insert({
        ...data,
        'photo_paths': photoPaths,
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
    List<String> oldPhotoPaths,
  ) async {
    try {
      // For now, we append new photos to the existing array in the UI or logic.
      // But let's assume we are replacing or providing the full new set of files 
      // is not ideal. Let's assume we are adding new ones.
      final uploadedPaths = await _uploadPhotos(newPhotos);
      
      // In a real app, you'd manage which ones to keep/delete. 
      // For this task, let's keep it simple: data['photo_paths'] should contain 
      // the combined list of remaining old paths + new paths.
      
      await _supabase.from('autoworld_cars').update({
        ...data,
        if (uploadedPaths.isNotEmpty) 'photo_paths': [...(data['photo_paths'] as List? ?? []), ...uploadedPaths],
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
        await _supabase.storage.from('autoworld_photos').remove(photoPaths);
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

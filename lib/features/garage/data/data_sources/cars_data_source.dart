import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class CarsDataSource {
  Stream<List<Map<String, dynamic>>> watchCars();
  Future<void> addCar(Map<String, dynamic> data, File? photo);
  Future<void> editCar(
    String id,
    Map<String, dynamic> data,
    File? newPhoto,
    String? oldPhotoPath,
  );
  Future<void> deleteCar(String id, String? oldPhotoPath);
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

  @override
  Future<void> addCar(Map<String, dynamic> data, File? photo) async {
    try {
      String? photoPath;

      if (photo != null) {
        final userId = _supabase.auth.currentUser?.id;
        if (userId == null) throw Exception('unauthenticated');
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        photoPath = '$userId/$fileName';
        await _supabase.storage
            .from('autoworld_photos')
            .upload(photoPath, photo);
      }

      await _supabase.from('autoworld_cars').insert({
        ...data,
        // ignore: use_null_aware_elements
        if (photoPath != null) 'photo_path': photoPath,
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
    File? newPhoto,
    String? oldPhotoPath,
  ) async {
    try {
      String? updatedPhotoPath;

      if (newPhoto != null) {
        final userId = _supabase.auth.currentUser?.id;
        if (userId == null) throw Exception('unauthenticated');
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        updatedPhotoPath = '$userId/$fileName';
        await _supabase.storage
            .from('autoworld_photos')
            .upload(updatedPhotoPath, newPhoto);

        if (oldPhotoPath != null) {
          await _supabase.storage
              .from('autoworld_photos')
              .remove([oldPhotoPath]);
        }
      }

      await _supabase.from('autoworld_cars').update({
        ...data,
        // ignore: use_null_aware_elements
        if (updatedPhotoPath != null) 'photo_path': updatedPhotoPath,
      }).eq('id', id);
    } catch (e, stack) {
      debugPrint('CarsDataSourceImpl editCar error: $e\n$stack');
      rethrow;
    }
  }

  @override
  Future<void> deleteCar(String id, String? oldPhotoPath) async {
    try {
      await _supabase.from('autoworld_cars').delete().eq('id', id);

      if (oldPhotoPath != null) {
        await _supabase.storage.from('autoworld_photos').remove([oldPhotoPath]);
      }
    } catch (e, stack) {
      debugPrint('CarsDataSourceImpl deleteCar error: $e\n$stack');
      rethrow;
    }
  }
}

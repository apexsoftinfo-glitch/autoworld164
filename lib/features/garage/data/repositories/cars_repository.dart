import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:myapp/features/garage/data/data_sources/cars_data_source.dart';
import 'package:myapp/features/garage/models/car_model.dart';

abstract class CarsRepository {
  Stream<List<CarModel>> get carsStream;
  Future<void> addCar({
    required String brand,
    required String modelName,
    String? series,
    double purchasePrice = 0.0,
    double estimatedValue = 0.0,
    File? photo,
  });
  Future<void> editCar({
    required CarModel oldModel,
    required String brand,
    required String modelName,
    String? series,
    required double purchasePrice,
    required double estimatedValue,
    File? newPhoto,
  });
  Future<void> deleteCar(CarModel car);
}

@LazySingleton(as: CarsRepository)
class CarsRepositoryImpl implements CarsRepository {
  CarsRepositoryImpl(this._dataSource);

  final CarsDataSource _dataSource;

  Stream<List<CarModel>>? _cachedStream;

  @override
  Stream<List<CarModel>> get carsStream {
    _cachedStream ??= _dataSource.watchCars().map((items) {
      return items.map((json) => CarModel.fromJson(json)).toList();
    }).asBroadcastStream();
    
    return _cachedStream!;
  }

  @override
  Future<void> addCar({
    required String brand,
    required String modelName,
    String? series,
    double purchasePrice = 0.0,
    double estimatedValue = 0.0,
    File? photo,
  }) async {
    try {
      final data = {
        'brand': brand,
        'model_name': modelName,
        // ignore: use_null_aware_elements
        if (series != null) 'series': series,
        'purchase_price': purchasePrice,
        'estimated_value': estimatedValue,
      };

      await _dataSource.addCar(data, photo);
    } catch (e, stack) {
      debugPrint('CarsRepositoryImpl addCar error: $e\n$stack');
      rethrow;
    }
  }

  @override
  Future<void> editCar({
    required CarModel oldModel,
    required String brand,
    required String modelName,
    String? series,
    required double purchasePrice,
    required double estimatedValue,
    File? newPhoto,
  }) async {
    try {
      final data = {
        'brand': brand,
        'model_name': modelName,
        'series': series, // We pass null to remove optionally
        'purchase_price': purchasePrice,
        'estimated_value': estimatedValue,
      };

      await _dataSource.editCar(
        oldModel.id,
        data,
        newPhoto,
        oldModel.photoPath,
      );
    } catch (e, stack) {
      debugPrint('CarsRepositoryImpl editCar error: $e\n$stack');
      rethrow;
    }
  }

  @override
  Future<void> deleteCar(CarModel car) async {
    try {
      await _dataSource.deleteCar(car.id, car.photoPath);
    } catch (e, stack) {
      debugPrint('CarsRepositoryImpl deleteCar error: $e\n$stack');
      rethrow;
    }
  }
}

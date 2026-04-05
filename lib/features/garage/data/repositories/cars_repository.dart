import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:myapp/features/garage/data/data_sources/cars_data_source.dart';
import 'package:myapp/features/garage/models/car_model.dart';
import 'package:rxdart/rxdart.dart';

abstract class CarsRepository {
  Stream<List<CarModel>> get carsStream;
  Future<void> addCar({
    required String brand,
    required String modelName,
    String? toyMaker,
    String? series,
    DateTime? purchaseDate,
    required double purchasePrice,
    required double estimatedValue,
    List<File> photos = const [],
    List<String> internetUrls = const [],
  });
  Future<void> editCar({
    required CarModel oldModel,
    required String brand,
    required String modelName,
    String? toyMaker,
    String? series,
    DateTime? purchaseDate,
    required double purchasePrice,
    required double estimatedValue,
    List<File> newPhotos = const [],
    List<String> internetUrls = const [],
    List<String>? remainingPhotoPaths,
  });
  Future<void> deleteCar(CarModel car);
  Future<List<String>> getSeries();
  Future<List<String>> searchWebPhotos(String query);
  Future<double> estimateValue(String query);
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
    }).shareReplay(maxSize: 1);
    
    return _cachedStream!;
  }

  @override
  Future<void> addCar({
    required String brand,
    required String modelName,
    String? toyMaker,
    String? series,
    DateTime? purchaseDate,
    required double purchasePrice,
    required double estimatedValue,
    List<File> photos = const [],
    List<String> internetUrls = const [],
  }) async {
    try {
      final data = {
        'brand': brand,
        'model_name': modelName,
        'toy_maker': toyMaker,
        'series': series,
        'purchase_date': purchaseDate?.toIso8601String(),
        'purchase_price': purchasePrice,
        'estimated_value': estimatedValue,
      };
 
      await _dataSource.addCar(data, photos, internetUrls);
      if (series != null) {
        await _dataSource.addSeries(series);
      }
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
    String? toyMaker,
    String? series,
    DateTime? purchaseDate,
    required double purchasePrice,
    required double estimatedValue,
    List<File> newPhotos = const [],
    List<String> internetUrls = const [],
    List<String>? remainingPhotoPaths,
  }) async {
    try {
      final data = {
        'brand': brand,
        'model_name': modelName,
        'toy_maker': toyMaker,
        'series': series,
        'purchase_date': purchaseDate?.toIso8601String(),
        'purchase_price': purchasePrice,
        'estimated_value': estimatedValue,
        'photo_paths': remainingPhotoPaths ?? oldModel.photoPaths,
      };

      await _dataSource.editCar(
        oldModel.id,
        data,
        newPhotos,
        internetUrls,
        oldModel.photoPaths,
      );
      if (series != null) {
        await _dataSource.addSeries(series);
      }
    } catch (e, stack) {
      debugPrint('CarsRepositoryImpl editCar error: $e\n$stack');
      rethrow;
    }
  }

  @override
  Future<void> deleteCar(CarModel car) async {
    try {
      await _dataSource.deleteCar(car.id, car.photoPaths);
    } catch (e, stack) {
      debugPrint('CarsRepositoryImpl deleteCar error: $e\n$stack');
      rethrow;
    }
  }

  @override
  Future<List<String>> getSeries() => _dataSource.fetchSeries();

  @override
  Future<List<String>> searchWebPhotos(String query) async {
    // Simulated search results for demo
    if (query.toLowerCase().contains('porsche')) {
      return [
        'https://m.media-amazon.com/images/I/71X8f8E8q8L._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/61S-r0w873L._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/71u9zHh0o4L._AC_SL1500_.jpg',
      ];
    }
    return [
      'https://m.media-amazon.com/images/I/71u9zHh0o4L._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61S-r0w873L._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71X8f8E8q8L._AC_SL1500_.jpg',
    ];
  }

  @override
  Future<double> estimateValue(String query) async {
    // Simulated AI valuation
    return 35.0;
  }
}

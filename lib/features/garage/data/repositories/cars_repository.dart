import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:autoworld164/features/garage/data/data_sources/cars_data_source.dart';
import 'package:autoworld164/features/garage/models/car_model.dart';
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
    required String status,
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
    required String status,
    List<File> newPhotos = const [],
    List<String> internetUrls = const [],
    List<String>? remainingPhotoPaths,
  });
  Future<void> deleteCar(CarModel car);
  Future<List<String>> getSeries();
  Future<void> deleteSeries(String name);
  Future<List<String>> getProducers();
  Future<List<String>> searchWebPhotos(String query, {int offset = 0});
  Future<void> refresh();
}

@LazySingleton(as: CarsRepository)
class CarsRepositoryImpl implements CarsRepository {
  CarsRepositoryImpl(this._dataSource);

  final CarsDataSource _dataSource;
  final _carsSubject = BehaviorSubject<List<CarModel>>();

  @override
  Stream<List<CarModel>> get carsStream {
    if (!_carsSubject.hasValue) {
      _refresh();
    }
    return _carsSubject.stream;
  }

  Future<void> _refresh() async {
    try {
      final items = await _dataSource.fetchCars();
      _carsSubject.add(items.map((json) => CarModel.fromJson(json)).toList());
    } catch (e) {
      debugPrint('CarsRepositoryImpl _refresh error: $e');
    }
  }

  @override
  Future<void> refresh() => _refresh();

  @override
  Future<void> addCar({
    required String brand,
    required String modelName,
    String? toyMaker,
    String? series,
    DateTime? purchaseDate,
    required double purchasePrice,
    required String status,
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
        'status': status,
      };
 
      await _dataSource.addCar(data, photos, internetUrls);
      if (series != null) {
        await _dataSource.addSeries(series);
      }
      if (toyMaker != null) {
        await _dataSource.addProducer(toyMaker);
      }
      await _refresh();
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
    required String status,
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
        'status': status,
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
      if (toyMaker != null) {
        await _dataSource.addProducer(toyMaker);
      }
      await _refresh();
    } catch (e, stack) {
      debugPrint('CarsRepositoryImpl editCar error: $e\n$stack');
      rethrow;
    }
  }

  @override
  Future<void> deleteCar(CarModel car) async {
    try {
      await _dataSource.deleteCar(car.id, car.photoPaths);
      await _refresh();
    } catch (e, stack) {
      debugPrint('CarsRepositoryImpl deleteCar error: $e\n$stack');
      rethrow;
    }
  }

  @override
  Future<List<String>> getSeries() => _dataSource.fetchSeries();

  @override
  Future<void> deleteSeries(String name) async {
    try {
      await _dataSource.deleteSeries(name);
    } catch (e, stack) {
      debugPrint('CarsRepositoryImpl deleteSeries error: $e\n$stack');
      rethrow;
    }
  }

  @override
  Future<List<String>> getProducers() => _dataSource.fetchProducers();

  @override
  Future<List<String>> searchWebPhotos(String query, {int offset = 0}) async {
    debugPrint('CarsRepositoryImpl: searchWebPhotos query: $query (offset: $offset)');
    return _dataSource.searchWebPhotos(query, offset: offset);
  }
}

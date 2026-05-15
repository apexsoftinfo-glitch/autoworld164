import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:autoworld164/features/market/data/data_sources/market_data_source.dart';
import 'package:autoworld164/features/market/models/market_car_model.dart';

abstract class MarketRepository {
  Stream<List<MarketCarModel>> get marketCarsStream;
  Future<void> addMarketCar({
    required String brand,
    required String modelName,
    String? toyMaker,
    String? series,
    required double price,
    required String status,
    required bool isExchange,
    required bool isSale,
    List<File> photos = const [],
    List<String> internetUrls = const [],
  });
  Future<void> editMarketCar({
    required MarketCarModel oldModel,
    required String brand,
    required String modelName,
    String? toyMaker,
    String? series,
    required double price,
    required String status,
    required bool isExchange,
    required bool isSale,
    List<File> newPhotos = const [],
    List<String> internetUrls = const [],
    List<String>? remainingPhotoPaths,
  });
  Future<void> deleteMarketCar(MarketCarModel car);
}

@LazySingleton(as: MarketRepository)
class MarketRepositoryImpl implements MarketRepository {
  MarketRepositoryImpl(this._dataSource);

  final MarketDataSource _dataSource;

  @override
  Stream<List<MarketCarModel>> get marketCarsStream {
    return _dataSource.watchMarketCars().map((list) => 
      list.map((json) => MarketCarModel.fromJson(json)).toList()
    );
  }

  @override
  Future<void> addMarketCar({
    required String brand,
    required String modelName,
    String? toyMaker,
    String? series,
    required double price,
    required String status,
    required bool isExchange,
    required bool isSale,
    List<File> photos = const [],
    List<String> internetUrls = const [],
  }) async {
    try {
      final data = {
        'brand': brand,
        'model_name': modelName,
        'toy_maker': toyMaker,
        'series': series,
        'price': price,
        'status': status,
        'is_exchange': isExchange,
        'is_sale': isSale,
      };

      await _dataSource.addMarketCar(data, photos, internetUrls);
    } catch (e, stack) {
      debugPrint('MarketRepositoryImpl addMarketCar error: $e\n$stack');
      rethrow;
    }
  }

  @override
  Future<void> editMarketCar({
    required MarketCarModel oldModel,
    required String brand,
    required String modelName,
    String? toyMaker,
    String? series,
    required double price,
    required String status,
    required bool isExchange,
    required bool isSale,
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
        'price': price,
        'status': status,
        'is_exchange': isExchange,
        'is_sale': isSale,
        'photo_paths': remainingPhotoPaths ?? oldModel.photoPaths,
      };

      await _dataSource.editMarketCar(
        oldModel.id,
        data,
        newPhotos,
        internetUrls,
        oldModel.photoPaths,
      );
    } catch (e, stack) {
      debugPrint('MarketRepositoryImpl editMarketCar error: $e\n$stack');
      rethrow;
    }
  }

  @override
  Future<void> deleteMarketCar(MarketCarModel car) async {
    try {
      await _dataSource.deleteMarketCar(car.id, car.photoPaths);
    } catch (e, stack) {
      debugPrint('MarketRepositoryImpl deleteMarketCar error: $e\n$stack');
      rethrow;
    }
  }
}

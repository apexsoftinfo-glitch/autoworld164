import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:autoworld164/features/market/data/repositories/market_repository.dart';
import 'package:autoworld164/features/garage/data/repositories/cars_repository.dart';
import 'package:autoworld164/features/market/models/market_car_model.dart';
import '../../../../shared/error_messages.dart';
import 'package:autoworld164/features/garage/models/car_model.dart';
import 'package:flutter/foundation.dart';

part 'market_form_cubit.freezed.dart';

@freezed
sealed class MarketFormState with _$MarketFormState {
  const factory MarketFormState.initial({
    @Default([]) List<String> producers,
    @Default([]) List<String> series,
  }) = MarketFormInitial;
  const factory MarketFormState.loading({
    @Default([]) List<String> producers,
    @Default([]) List<String> series,
  }) = MarketFormLoading;
  const factory MarketFormState.success() = MarketFormSuccess;
  const factory MarketFormState.error(String errorKey, {
    @Default([]) List<String> producers,
    @Default([]) List<String> series,
  }) = MarketFormError;
}

@injectable
class MarketFormCubit extends Cubit<MarketFormState> {
  MarketFormCubit(this._marketRepository, this._carsRepository) : super(const MarketFormState.initial());

  final MarketRepository _marketRepository;
  final CarsRepository _carsRepository;

  Future<void> loadInitialData() async {
    emit(const MarketFormState.loading());
    try {
      final results = await Future.wait([
        _carsRepository.getProducers(),
        _carsRepository.getSeries(),
      ]);
      emit(MarketFormState.initial(
        producers: results[0],
        series: results[1],
      ));
    } catch (e) {
      debugPrint('MarketFormCubit loadInitialData error: $e');
      emit(const MarketFormState.initial());
    }
  }

  Future<void> saveCar({
    MarketCarModel? existingCar,
    required String brand,
    required String modelName,
    String? toyMaker,
    String? series,
    required double price,
    required String status,
    required bool isExchange,
    required bool isSale,
    List<File> newPhotos = const [],
    List<String> photoUrls = const [],
    List<String>? remainingPhotoPaths,
    CarModel? fromGarageCar,
  }) async {
    final currentProducers = state.maybeWhen(
      initial: (p, s) => p,
      loading: (p, s) => p,
      error: (e, p, s) => p,
      orElse: () => <String>[],
    );
    final currentSeries = state.maybeWhen(
      initial: (p, s) => s,
      loading: (p, s) => s,
      error: (e, p, s) => s,
      orElse: () => <String>[],
    );

    emit(MarketFormState.loading(producers: currentProducers, series: currentSeries));
    try {
      if (existingCar != null) {
        await _marketRepository.editMarketCar(
          oldModel: existingCar,
          brand: brand,
          modelName: modelName,
          toyMaker: toyMaker,
          series: series,
          price: price,
          status: status,
          isExchange: isExchange,
          isSale: isSale,
          newPhotos: newPhotos,
          internetUrls: photoUrls,
          remainingPhotoPaths: remainingPhotoPaths,
        );
      } else {
        await _marketRepository.addMarketCar(
          brand: brand,
          modelName: modelName,
          toyMaker: toyMaker,
          series: series,
          price: price,
          status: status,
          isExchange: isExchange,
          isSale: isSale,
          photos: newPhotos,
          internetUrls: photoUrls,
          initialPhotoPaths: remainingPhotoPaths ?? [],
        );

        if (fromGarageCar != null) {
          await _carsRepository.deleteCar(fromGarageCar);
        }
      }
      emit(const MarketFormState.success());
    } catch (e, stack) {
      debugPrint('MarketFormCubit saveCar error: $e\n$stack');
      emit(MarketFormState.error(mapErrorToKey(e), producers: currentProducers, series: currentSeries));
    }
  }

  Future<void> deleteCar(String carId) async {
    emit(const MarketFormState.loading());
    try {
      final cars = await _marketRepository.marketCarsStream.first;
      final car = cars.firstWhere((c) => c.id == carId);
      await _marketRepository.deleteMarketCar(car);
      emit(const MarketFormState.success());
    } catch (e, stack) {
      debugPrint('MarketFormCubit deleteCar error: $e\n$stack');
      emit(MarketFormState.error(mapErrorToKey(e)));
    }
  }
}

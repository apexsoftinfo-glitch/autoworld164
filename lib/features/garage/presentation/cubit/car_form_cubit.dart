import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:autoworld164/features/garage/data/repositories/cars_repository.dart';
import 'package:autoworld164/features/garage/models/car_model.dart';
import '../../../../shared/error_messages.dart';
import 'package:flutter/foundation.dart';

part 'car_form_cubit.freezed.dart';

@freezed
sealed class CarFormState with _$CarFormState {
  const factory CarFormState.initial({
    @Default([]) List<String> producers,
    @Default([]) List<String> series,
  }) = CarFormInitial;
  const factory CarFormState.loading({
    @Default([]) List<String> producers,
    @Default([]) List<String> series,
  }) = CarFormLoading;
  const factory CarFormState.success() = CarFormSuccess;
  const factory CarFormState.error(String errorKey, {
    @Default([]) List<String> producers,
    @Default([]) List<String> series,
  }) = CarFormError;
}

@injectable
class CarFormCubit extends Cubit<CarFormState> {
  CarFormCubit(this._carsRepository) : super(const CarFormState.initial());

  final CarsRepository _carsRepository;

  Future<void> loadInitialData() async {
    emit(const CarFormState.loading());
    try {
      final results = await Future.wait([
        _carsRepository.getProducers(),
        _carsRepository.getSeries(),
      ]);
      emit(CarFormState.initial(
        producers: results[0],
        series: results[1],
      ));
    } catch (e) {
      debugPrint('CarFormCubit loadInitialData error: $e');
      emit(const CarFormState.initial());
    }
  }

  Future<void> saveCar({
    CarModel? existingCar,
    required String brand,
    required String modelName,
    String? toyMaker,
    String? series,
    DateTime? purchaseDate,
    required double purchasePrice,
    required String status,
    List<File> newPhotos = const [],
    List<String> photoUrls = const [],
    List<String>? remainingPhotoPaths,
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

    emit(CarFormState.loading(producers: currentProducers, series: currentSeries));
    try {
      if (existingCar != null) {
        await _carsRepository.editCar(
          oldModel: existingCar,
          brand: brand,
          modelName: modelName,
          toyMaker: toyMaker,
          series: series,
          purchaseDate: purchaseDate,
          purchasePrice: purchasePrice,
          status: status,
          newPhotos: newPhotos,
          internetUrls: photoUrls,
          remainingPhotoPaths: remainingPhotoPaths,
        );
      } else {
        await _carsRepository.addCar(
          brand: brand,
          modelName: modelName,
          toyMaker: toyMaker,
          series: series,
          purchaseDate: purchaseDate,
          purchasePrice: purchasePrice,
          status: status,
          photos: newPhotos,
          internetUrls: photoUrls,
        );
      }
      emit(const CarFormState.success());
    } catch (e, stack) {
      debugPrint('CarFormCubit saveCar error: $e\n$stack');
      emit(CarFormState.error(mapErrorToKey(e), producers: currentProducers, series: currentSeries));
    }
  }

  Future<void> deleteCar(String carId) async {
    emit(const CarFormState.loading());
    try {
      final cars = await _carsRepository.carsStream.first;
      final car = cars.firstWhere((c) => c.id == carId);
      await _carsRepository.deleteCar(car);
      emit(const CarFormState.success());
    } catch (e, stack) {
      debugPrint('CarFormCubit deleteCar error: $e\n$stack');
      emit(CarFormState.error(mapErrorToKey(e)));
    }
  }
}

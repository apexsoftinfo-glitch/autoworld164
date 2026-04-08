import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:myapp/features/garage/data/repositories/cars_repository.dart';
import 'package:myapp/features/garage/models/car_model.dart';
import '../../../../shared/error_messages.dart';
import 'package:flutter/foundation.dart';

part 'car_form_cubit.freezed.dart';

@freezed
sealed class CarFormState with _$CarFormState {
  const factory CarFormState.initial() = CarFormInitial;
  const factory CarFormState.loading() = CarFormLoading;
  const factory CarFormState.success() = CarFormSuccess;
  const factory CarFormState.error(String errorKey) = CarFormError;
}

@injectable
class CarFormCubit extends Cubit<CarFormState> {
  CarFormCubit(this._carsRepository) : super(const CarFormState.initial());

  final CarsRepository _carsRepository;

  Future<void> loadInitialData() async {
    emit(const CarFormState.initial());
  }

  Future<double?> estimateValue(String query) async {
    try {
      return await _carsRepository.estimateValue(query);
    } catch (e) {
      debugPrint('CarFormCubit estimateValue error: $e');
      return null;
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
    required double estimatedValue,
    required String status,
    List<File> newPhotos = const [],
    List<String> photoUrls = const [],
    List<String>? remainingPhotoPaths,
  }) async {
    emit(const CarFormState.loading());
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
          estimatedValue: estimatedValue,
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
          estimatedValue: estimatedValue,
          status: status,
          photos: newPhotos,
          internetUrls: photoUrls,
        );
      }
      emit(const CarFormState.success());
    } catch (e, stack) {
      debugPrint('CarFormCubit saveCar error: $e\n$stack');
      emit(CarFormState.error(mapErrorToKey(e)));
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

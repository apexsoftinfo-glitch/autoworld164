import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:myapp/features/garage/data/repositories/cars_repository.dart';
import 'package:myapp/features/garage/models/car_model.dart';
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

  Future<void> saveCar({
    CarModel? existingCar,
    required String brand,
    required String modelName,
    String? series,
    required double purchasePrice,
    required double estimatedValue,
    File? newPhoto,
  }) async {
    emit(const CarFormState.loading());
    try {
      if (existingCar != null) {
        await _carsRepository.editCar(
          oldModel: existingCar,
          brand: brand,
          modelName: modelName,
          series: series,
          purchasePrice: purchasePrice,
          estimatedValue: estimatedValue,
          newPhoto: newPhoto,
        );
      } else {
        await _carsRepository.addCar(
          brand: brand,
          modelName: modelName,
          series: series,
          purchasePrice: purchasePrice,
          estimatedValue: estimatedValue,
          photo: newPhoto,
        );
      }
      emit(const CarFormState.success());
    } catch (e, stack) {
      debugPrint('CarFormCubit saveCar error: $e\n$stack');
      emit(const CarFormState.error('errorUnknown'));
    }
  }
}

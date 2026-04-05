import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:myapp/features/garage/data/repositories/cars_repository.dart';
import 'package:myapp/features/garage/models/car_model.dart';
import 'package:flutter/foundation.dart';

part 'cars_collection_cubit.freezed.dart';

@freezed
sealed class CarsCollectionState with _$CarsCollectionState {
  const factory CarsCollectionState.initial() = CarsCollectionInitial;
  const factory CarsCollectionState.loading() = CarsCollectionLoading;
  const factory CarsCollectionState.error(String errorKey) = CarsCollectionError;
  const factory CarsCollectionState.data({
    required List<CarModel> cars,
    required double totalPurchasePrice,
    required double totalEstimatedValue,
  }) = CarsCollectionData;
}

@injectable
class CarsCollectionCubit extends Cubit<CarsCollectionState> {
  CarsCollectionCubit(this._carsRepository)
      : super(const CarsCollectionState.initial()) {
    _init();
  }

  final CarsRepository _carsRepository;
  StreamSubscription<List<CarModel>>? _subscription;

  void _init() {
    Future.microtask(() => emit(const CarsCollectionState.loading()));
    _subscription = _carsRepository.carsStream.listen(
      (cars) {
        double purchaseTotal = 0;
        double estimatedTotal = 0;
        for (final car in cars) {
          purchaseTotal += car.purchasePrice;
          estimatedTotal += car.estimatedValue;
        }

        emit(CarsCollectionState.data(
          cars: cars,
          totalPurchasePrice: purchaseTotal,
          totalEstimatedValue: estimatedTotal,
        ));
      },
      onError: (error) {
        debugPrint('CarsCollectionCubit stream error: $error');
        emit(const CarsCollectionState.error('errorUnknown'));
      },
    );
  }

  void retry() {
    _subscription?.cancel();
    _init();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

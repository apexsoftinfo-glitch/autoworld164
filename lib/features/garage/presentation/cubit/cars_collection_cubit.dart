import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:autoworld164/features/garage/data/repositories/cars_repository.dart';
import 'package:autoworld164/features/garage/models/car_model.dart';
import 'package:flutter/foundation.dart';

part 'cars_collection_cubit.freezed.dart';

enum CollectionViewType { grid, list }

@freezed
sealed class CarsCollectionState with _$CarsCollectionState {
  const factory CarsCollectionState.initial() = CarsCollectionInitial;
  const factory CarsCollectionState.loading() = CarsCollectionLoading;
  const factory CarsCollectionState.error(String errorKey) = CarsCollectionError;
  const factory CarsCollectionState.data({
    required List<CarModel> cars,
    required List<CarModel> filteredCars,
    required double totalPurchasePrice,
    required double totalEstimatedValue,
    @Default({}) Map<String, int> brandStats,
    @Default('') String query,
    @Default(CollectionViewType.grid) CollectionViewType viewType,
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
        final stats = <String, int>{};

        for (final car in cars) {
          purchaseTotal += car.purchasePrice;
          estimatedTotal += car.estimatedValue;
          
          final key = (car.toyMaker ?? car.brand).trim();
          if (key.isNotEmpty) {
            stats[key] = (stats[key] ?? 0) + 1;
          }
        }

        final currentQuery = state.maybeWhen(
          data: (c, fc, pt, et, st, q, vt) => q,
          orElse: () => '',
        );
        final currentViewType = state.maybeWhen(
          data: (c, fc, pt, et, st, q, vt) => vt,
          orElse: () => CollectionViewType.grid,
        );

        final filtered = _filterCars(cars, currentQuery);

        emit(CarsCollectionState.data(
          cars: cars,
          filteredCars: filtered,
          totalPurchasePrice: purchaseTotal,
          totalEstimatedValue: estimatedTotal,
          brandStats: stats,
          query: currentQuery,
          viewType: currentViewType,
        ));
      },
      onError: (error) {
        debugPrint('CarsCollectionCubit stream error: $error');
        emit(const CarsCollectionState.error('errorUnknown'));
      },
    );
  }

  void search(String query) {
    state.whenOrNull(data: (cars, filtered, purchaseTotal, estimatedTotal, stats, q, viewType) {
      final newFiltered = _filterCars(cars, query);
      emit(CarsCollectionState.data(
        cars: cars,
        filteredCars: newFiltered,
        totalPurchasePrice: purchaseTotal,
        totalEstimatedValue: estimatedTotal,
        brandStats: stats,
        query: query,
        viewType: viewType,
      ));
    });
  }

  void toggleView() {
    state.whenOrNull(data: (cars, filtered, purchaseTotal, estimatedTotal, stats, query, viewType) {
      final newType = viewType == CollectionViewType.grid ? CollectionViewType.list : CollectionViewType.grid;
      emit(CarsCollectionState.data(
        cars: cars,
        filteredCars: filtered,
        totalPurchasePrice: purchaseTotal,
        totalEstimatedValue: estimatedTotal,
        brandStats: stats,
        query: query,
        viewType: newType,
      ));
    });
  }

  List<CarModel> _filterCars(List<CarModel> cars, String query) {
    if (query.isEmpty) return cars;
    final q = query.toLowerCase();
    return cars.where((c) {
      final matchText = [
        c.brand,
        c.modelName,
        c.series ?? '',
        c.toyMaker ?? '',
        c.purchasePrice.toString(),
      ].join(' ').toLowerCase();
      return matchText.contains(q);
    }).toList();
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

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:autoworld164/features/garage/data/repositories/cars_repository.dart';
import 'package:autoworld164/features/garage/models/car_model.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'cars_collection_cubit.freezed.dart';

enum CollectionViewType { grid, list }
enum SortType { date, series, price, producer }
enum SortOrder { asc, desc }

@freezed
sealed class CarsCollectionState with _$CarsCollectionState {
  const factory CarsCollectionState.initial() = CarsCollectionInitial;
  const factory CarsCollectionState.loading() = CarsCollectionLoading;
  const factory CarsCollectionState.error(String errorKey) = CarsCollectionError;
  const factory CarsCollectionState.data({
    required List<CarModel> cars,
    required List<CarModel> filteredCars,
    required double totalPurchasePrice,
    @Default({}) Map<String, int> brandStats,
    @Default('') String query,
    @Default(CollectionViewType.grid) CollectionViewType viewType,
    @Default(SortType.date) SortType sortType,
    @Default(SortOrder.desc) SortOrder sortOrder,
  }) = CarsCollectionData;
}

@injectable
class CarsCollectionCubit extends Cubit<CarsCollectionState> {
  CarsCollectionCubit(this._carsRepository)
      : super(const CarsCollectionState.initial()) {
    _init();
  }

  static const _prefKey = 'garage_view_type';
  final CarsRepository _carsRepository;
  StreamSubscription<List<CarModel>>? _subscription;

  Future<CollectionViewType> _loadViewType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_prefKey) == 'list'
        ? CollectionViewType.list
        : CollectionViewType.grid;
  }

  Future<void> _saveViewType(CollectionViewType type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, type == CollectionViewType.list ? 'list' : 'grid');
  }

  void _init() {
    Future.microtask(() async {
      emit(const CarsCollectionState.loading());
      final savedViewType = await _loadViewType();
      _subscription = _carsRepository.carsStream.listen(
      (cars) {
        double purchaseTotal = 0;
        final stats = <String, int>{};

        for (final car in cars) {
          purchaseTotal += car.purchasePrice;
          
          final key = (car.toyMaker ?? car.brand).trim();
          if (key.isNotEmpty) {
            stats[key] = (stats[key] ?? 0) + 1;
          }
        }

        final currentQuery = state.maybeWhen(
          data: (c, fc, pt, st, q, vt, stype, sorder) => q,
          orElse: () => '',
        );
        final currentViewType = state.maybeWhen(
          data: (c, fc, pt, st, q, vt, stype, sorder) => vt,
          orElse: () => savedViewType,
        );

        final filtered = _filterCars(cars, currentQuery);

        emit(CarsCollectionState.data(
          cars: cars,
          filteredCars: filtered,
          totalPurchasePrice: purchaseTotal,
          brandStats: stats,
          query: currentQuery,
          viewType: currentViewType,
          sortType: state.maybeWhen(data: (c, fc, pt, st, q, vt, stype, sorder) => stype, orElse: () => SortType.date),
          sortOrder: state.maybeWhen(data: (c, fc, pt, st, q, vt, stype, sorder) => sorder, orElse: () => SortOrder.desc),
        ));
      },
      onError: (error) {
        debugPrint('CarsCollectionCubit stream error: $error');
        emit(const CarsCollectionState.error('errorUnknown'));
      },
    );
    });
  }

  void search(String query) {
    state.whenOrNull(data: (cars, filtered, purchaseTotal, stats, q, viewType, st, so) {
      final newFiltered = _sortCars(_filterCars(cars, query), st, so);
      emit(CarsCollectionState.data(
        cars: cars,
        filteredCars: newFiltered,
        totalPurchasePrice: purchaseTotal,
        brandStats: stats,
        query: query,
        viewType: viewType,
        sortType: st,
        sortOrder: so,
      ));
    });
  }

  void toggleView() {
    state.whenOrNull(data: (cars, filtered, purchaseTotal, stats, query, viewType, st, so) {
      final newType = viewType == CollectionViewType.grid ? CollectionViewType.list : CollectionViewType.grid;
      _saveViewType(newType);
      emit(CarsCollectionState.data(
        cars: cars,
        filteredCars: filtered,
        totalPurchasePrice: purchaseTotal,
        brandStats: stats,
        query: query,
        viewType: newType,
        sortType: st,
        sortOrder: so,
      ));
    });
  }

  void changeSort(SortType type) {
    state.whenOrNull(data: (cars, filtered, purchaseTotal, stats, query, viewType, sortType, sortOrder) {
      SortOrder newOrder = SortOrder.desc;
      if (sortType == type) {
        newOrder = sortOrder == SortOrder.desc ? SortOrder.asc : SortOrder.desc;
      }
      
      final sorted = _sortCars(_filterCars(cars, query), type, newOrder);
      
      emit(CarsCollectionState.data(
        cars: cars,
        filteredCars: sorted,
        totalPurchasePrice: purchaseTotal,
        brandStats: stats,
        query: query,
        viewType: viewType,
        sortType: type,
        sortOrder: newOrder,
      ));
    });
  }

  List<CarModel> _sortCars(List<CarModel> cars, SortType type, SortOrder order) {
    final sorted = List<CarModel>.from(cars);
    sorted.sort((a, b) {
      int cmp;
      switch (type) {
        case SortType.date:
          cmp = (a.purchaseDate ?? DateTime(1900)).compareTo(b.purchaseDate ?? DateTime(1900));
          break;
        case SortType.series:
          cmp = (a.series ?? '').toLowerCase().compareTo((b.series ?? '').toLowerCase());
          break;
        case SortType.price:
          cmp = a.purchasePrice.compareTo(b.purchasePrice);
          break;
        case SortType.producer:
          cmp = (a.toyMaker ?? a.brand).toLowerCase().compareTo((b.toyMaker ?? b.brand).toLowerCase());
          break;
      }
      return order == SortOrder.asc ? cmp : -cmp;
    });
    return sorted;
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

import 'dart:async';
import 'package:flutter/widgets.dart' show debugPrint;
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:autoworld164/features/market/data/repositories/market_repository.dart';
import 'package:autoworld164/features/market/models/market_car_model.dart';
import 'package:autoworld164/features/garage/presentation/cubit/cars_collection_cubit.dart';
import 'package:autoworld164/features/garage/data/repositories/cars_repository.dart';
import 'package:autoworld164/features/garage/models/car_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'market_cubit.freezed.dart';

@freezed
class MarketState with _$MarketState {
  const factory MarketState.initial() = MarketInitial;
  const factory MarketState.loading() = MarketLoading;
  const factory MarketState.data({
    required List<MarketCarModel> cars,
    required List<MarketCarModel> filteredCars,
    @Default('') String query,
    @Default(CollectionViewType.grid) CollectionViewType viewType,
    @Default(SortType.date) SortType sortType,
    @Default(SortOrder.desc) SortOrder sortOrder,
  }) = MarketData;
  const factory MarketState.error(String errorKey) = MarketError;
}

@injectable
class MarketCubit extends Cubit<MarketState> {
  MarketCubit(this._repository, this._carsRepository) : super(const MarketState.initial()) {
    _init();
  }

  static const _prefKey = 'market_view_type';
  final MarketRepository _repository;
  final CarsRepository _carsRepository;
  StreamSubscription? _subscription;

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
    emit(const MarketState.loading());
    Future.microtask(() async {
      final savedViewType = await _loadViewType();
      _subscription = _repository.marketCarsStream.listen(
        (cars) {
          final currentQuery = state.maybeWhen(
            data: (c, fc, q, vt, st, so) => q,
            orElse: () => '',
          );
          final currentViewType = state.maybeWhen(
            data: (c, fc, q, vt, st, so) => vt,
            orElse: () => savedViewType,
          );
          final currentSort = state.maybeWhen(
            data: (c, fc, q, vt, st, so) => st,
            orElse: () => SortType.date,
          );
          final currentOrder = state.maybeWhen(
            data: (c, fc, q, vt, st, so) => so,
            orElse: () => SortOrder.desc,
          );
          _updateData(cars, currentQuery, currentViewType, currentSort, currentOrder);
        },
        onError: (e) {
          emit(const MarketState.error('error_generic'));
        },
      );
    });
  }

  void _updateData(List<MarketCarModel> allCars, String query, CollectionViewType viewType, SortType sort, SortOrder order) {
    var filtered = allCars.where((car) {
      final search = query.toLowerCase();
      return car.brand.toLowerCase().contains(search) || 
             car.modelName.toLowerCase().contains(search) ||
             (car.series?.toLowerCase().contains(search) ?? false);
    }).toList();

    // Sort
    filtered.sort((a, b) {
      int cmp;
      switch (sort) {
        case SortType.series:
          cmp = (a.series ?? '').compareTo(b.series ?? '');
          break;
        case SortType.price:
          cmp = a.price.compareTo(b.price);
          break;
        case SortType.producer:
          cmp = (a.toyMaker ?? '').compareTo(b.toyMaker ?? '');
          break;
        case SortType.date:
          cmp = a.createdAt.compareTo(b.createdAt);
          break;
        case SortType.name:
          cmp = '${a.brand} ${a.modelName}'.toLowerCase().compareTo('${b.brand} ${b.modelName}'.toLowerCase());
          break;
      }
      return order == SortOrder.asc ? cmp : -cmp;
    });

    emit(MarketState.data(
      cars: allCars,
      filteredCars: filtered,
      query: query,
      viewType: viewType,
      sortType: sort,
      sortOrder: order,
    ));
  }

  void search(String query) {
    state.whenOrNull(data: (cars, fc, q, vt, st, so) {
      _updateData(cars, query, vt, st, so);
    });
  }

  void toggleView() {
    state.whenOrNull(data: (cars, fc, q, vt, st, so) {
      final nextView = vt == CollectionViewType.grid ? CollectionViewType.list : CollectionViewType.grid;
      _saveViewType(nextView);
      emit((state as MarketData).copyWith(viewType: nextView));
    });
  }

  void changeSort(SortType type) {
    state.whenOrNull(data: (cars, fc, q, vt, st, so) {
      var nextOrder = so;
      if (st == type) {
        nextOrder = so == SortOrder.asc ? SortOrder.desc : SortOrder.asc;
      } else {
        nextOrder = type == SortType.date ? SortOrder.desc : SortOrder.asc;
      }
      _updateData(cars, q, vt, type, nextOrder);
    });
  }

  Future<void> moveFromGarage(CarModel car) async {
    try {
      // 1. Add to market
      await _repository.addMarketCar(
        brand: car.brand,
        modelName: car.modelName,
        toyMaker: car.toyMaker,
        series: car.series,
        price: car.purchasePrice,
        status: car.status,
        isExchange: true,
        isSale: true,
        isAuction: false,
        initialPhotoPaths: car.allPhotoPaths,
      );

      // 2. Delete from garage
      await _carsRepository.deleteCar(car);
      
      // retry() or wait for stream to update (BehaviorSubject will update automatically)
    } catch (e) {
      debugPrint('MarketCubit moveFromGarage error: $e');
      rethrow;
    }
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

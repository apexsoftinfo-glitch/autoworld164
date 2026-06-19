import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:autoworld164/features/garage/models/car_model.dart';
import 'package:autoworld164/features/garage/presentation/cubit/car_form_cubit.dart';

import '../../../../support/mocks.dart';

void main() {
  late MockCarsRepository carsRepository;

  setUp(() {
    carsRepository = MockCarsRepository();
    registerFallbackValue(
      CarModel(
        id: '1',
        userId: 'u1',
        brand: 'Dummy',
        modelName: 'Dummy',
        toyMaker: 'Hot Wheels',
        purchaseDate: DateTime.now(),
        createdAt: DateTime.now(),
      ),
    );
    when(() => carsRepository.getProducers()).thenAnswer((_) async => []);
    when(() => carsRepository.getSeries()).thenAnswer((_) async => []);
  });

  group('CarFormCubit', () {
    blocTest<CarFormCubit, CarFormState>(
      'emits success after adding new car successfully',
      build: () {
        when(() => carsRepository.addCar(
              brand: any(named: 'brand'),
              modelName: any(named: 'modelName'),
              toyMaker: any(named: 'toyMaker'),
              series: any(named: 'series'),
              purchaseDate: any(named: 'purchaseDate'),
              purchasePrice: any(named: 'purchasePrice'),
              status: any(named: 'status'),
              photos: any(named: 'photos'),
              internetUrls: any(named: 'internetUrls'),
            )).thenAnswer((_) async {});
        return CarFormCubit(carsRepository);
      },
      act: (cubit) => cubit.saveCar(
        brand: 'Hot Wheels',
        modelName: 'Speedster',
        purchasePrice: 10,
        status: 'Nowy',
      ),
      expect: () => [
        const CarFormState.loading(producers: [], series: []),
        const CarFormState.success(),
      ],
    );

    blocTest<CarFormCubit, CarFormState>(
      'loadInitialData emits loading then initial with producers and series',
      build: () {
        when(() => carsRepository.getProducers())
            .thenAnswer((_) async => ['Custom Co']);
        when(() => carsRepository.getSeries())
            .thenAnswer((_) async => ['Custom Series']);
        return CarFormCubit(carsRepository);
      },
      act: (cubit) => cubit.loadInitialData(),
      expect: () => [
        const CarFormState.loading(producers: [], series: []),
        const CarFormState.initial(producers: ['Custom Co'], series: ['Custom Series']),
      ],
    );

    blocTest<CarFormCubit, CarFormState>(
      'emits error when repo throws error',
      build: () {
        when(() => carsRepository.addCar(
              brand: any(named: 'brand'),
              modelName: any(named: 'modelName'),
              toyMaker: any(named: 'toyMaker'),
              series: any(named: 'series'),
              purchaseDate: any(named: 'purchaseDate'),
              purchasePrice: any(named: 'purchasePrice'),
              status: any(named: 'status'),
              photos: any(named: 'photos'),
              internetUrls: any(named: 'internetUrls'),
            )).thenThrow(Exception('database error'));
        return CarFormCubit(carsRepository);
      },
      act: (cubit) => cubit.saveCar(
        brand: 'Hot Wheels',
        modelName: 'Speedster',
        purchasePrice: 10,
        status: 'Nowy',
      ),
      expect: () => [
        const CarFormState.loading(producers: [], series: []),
        const CarFormState.error('network_error', producers: [], series: []),
      ],
    );

    blocTest<CarFormCubit, CarFormState>(
      'deleteSeries emits loading then initial with updated series list on success',
      build: () {
        when(() => carsRepository.deleteSeries(any())).thenAnswer((_) async {});
        when(() => carsRepository.getSeries()).thenAnswer((_) async => ['Series A', 'Series B']);
        return CarFormCubit(carsRepository);
      },
      act: (cubit) => cubit.deleteSeries('Series C'),
      expect: () => [
        const CarFormState.loading(producers: [], series: []),
        const CarFormState.initial(producers: [], series: ['Series A', 'Series B']),
      ],
    );

    blocTest<CarFormCubit, CarFormState>(
      'deleteSeries emits loading then error when repo throws error',
      build: () {
        when(() => carsRepository.deleteSeries(any())).thenThrow(Exception('series_has_models'));
        return CarFormCubit(carsRepository);
      },
      act: (cubit) => cubit.deleteSeries('Series C'),
      expect: () => [
        const CarFormState.loading(producers: [], series: []),
        const CarFormState.error('series_has_models', producers: [], series: []),
      ],
    );
  });
}

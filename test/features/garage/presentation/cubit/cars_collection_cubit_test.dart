import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myapp/features/garage/models/car_model.dart';
import 'package:myapp/features/garage/presentation/cubit/cars_collection_cubit.dart';

import '../../../../support/mocks.dart';

void main() {
  late MockCarsRepository carsRepository;

  setUp(() {
    carsRepository = MockCarsRepository();
  });

  group('CarsCollectionCubit', () {
    final mockCars = [
      CarModel(
        id: '1',
        userId: 'u1',
        brand: 'Hot Wheels',
        modelName: 'M1',
        purchasePrice: 10.0,
        estimatedValue: 15.0,
        createdAt: DateTime(2023),
      ),
      CarModel(
        id: '2',
        userId: 'u1',
        brand: 'Matchbox',
        modelName: 'M2',
        purchasePrice: 5.0,
        estimatedValue: 5.0,
        createdAt: DateTime(2023),
      ),
    ];

    blocTest<CarsCollectionCubit, CarsCollectionState>(
      'emits data with correctly calculated totals on stream',
      build: () {
        when(() => carsRepository.carsStream)
            .thenAnswer((_) => Stream.value(mockCars));
        return CarsCollectionCubit(carsRepository);
      },
      expect: () => [
        const CarsCollectionState.loading(),
        CarsCollectionState.data(
          cars: mockCars,
          totalPurchasePrice: 15.0,
          totalEstimatedValue: 20.0,
        ),
      ],
    );

    blocTest<CarsCollectionCubit, CarsCollectionState>(
      'emits error state on stream error',
      build: () {
        when(() => carsRepository.carsStream)
            .thenAnswer((_) => Stream.error(Exception('Fail')));
        return CarsCollectionCubit(carsRepository);
      },
      expect: () => [
        const CarsCollectionState.loading(),
        const CarsCollectionState.error('errorUnknown'),
      ],
    );
  });
}

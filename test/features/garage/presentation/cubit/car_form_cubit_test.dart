import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myapp/features/garage/models/car_model.dart';
import 'package:myapp/features/garage/presentation/cubit/car_form_cubit.dart';

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
        createdAt: DateTime.now(),
      ),
    );
  });

  group('CarFormCubit', () {
    blocTest<CarFormCubit, CarFormState>(
      'emits success after adding new car successfully',
      build: () {
        when(() => carsRepository.addCar(
              brand: any(named: 'brand'),
              modelName: any(named: 'modelName'),
              series: any(named: 'series'),
              purchasePrice: any(named: 'purchasePrice'),
              estimatedValue: any(named: 'estimatedValue'),
              photo: any(named: 'photo'),
            )).thenAnswer((_) async {});
        return CarFormCubit(carsRepository);
      },
      act: (cubit) => cubit.saveCar(
        brand: 'Hot Wheels',
        modelName: 'Speedster',
        purchasePrice: 10,
        estimatedValue: 15,
      ),
      expect: () => [
        const CarFormState.loading(),
        const CarFormState.success(),
      ],
    );

    blocTest<CarFormCubit, CarFormState>(
      'emits error when repo throws error',
      build: () {
        when(() => carsRepository.addCar(
              brand: any(named: 'brand'),
              modelName: any(named: 'modelName'),
              series: any(named: 'series'),
              purchasePrice: any(named: 'purchasePrice'),
              estimatedValue: any(named: 'estimatedValue'),
              photo: any(named: 'photo'),
            )).thenThrow(Exception('database error'));
        return CarFormCubit(carsRepository);
      },
      act: (cubit) => cubit.saveCar(
        brand: 'Hot Wheels',
        modelName: 'Speedster',
        purchasePrice: 10,
        estimatedValue: 15,
      ),
      expect: () => [
        const CarFormState.loading(),
        const CarFormState.error('errorUnknown'),
      ],
    );
  });
}

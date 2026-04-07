import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myapp/features/garage/data/data_sources/cars_data_source.dart';
import 'package:myapp/features/garage/data/repositories/cars_repository.dart';
import 'package:myapp/features/garage/models/car_model.dart';
import 'dart:io';

class MockCarsDataSource extends Mock implements CarsDataSource {}
class MockFile extends Mock implements File {}

void main() {
  late MockCarsDataSource mockDataSource;
  late CarsRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockCarsDataSource();
    repository = CarsRepositoryImpl(mockDataSource);
  });

  group('CarsRepositoryImpl', () {
    test('carsStream transforms data to CarModels', () async {
      final mockData = [
        {
          'id': '123',
          'user_id': 'abc',
          'brand': 'Hot Wheels',
          'model_name': 'Test',
          'created_at': DateTime(2023).toIso8601String(),
        }
      ];
      when(() => mockDataSource.fetchCars())
          .thenAnswer((_) async => mockData);

      final stream = repository.carsStream;

      expect(
        await stream.first,
        [
          isA<CarModel>()
              .having((c) => c.id, 'id', '123')
              .having((c) => c.brand, 'brand', 'Hot Wheels'),
        ],
      );
    });

    test('addCar passes mapped data to data source', () async {
      when(() => mockDataSource.addCar(any(), any(), any()))
          .thenAnswer((_) async {});
      when(() => mockDataSource.fetchCars())
          .thenAnswer((_) async => []);

      await repository.addCar(
        brand: 'Majorette',
        modelName: 'Porsche',
        purchasePrice: 10.0,
        estimatedValue: 20.0,
        status: 'Nowy',
      );

      verify(() => mockDataSource.addCar(
            any(),
            [],
            [],
          )).called(1);
    });
  });
}

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
    test('carsStream transforms data to CarModels', () {
      final mockData = [
        {
          'id': '123',
          'user_id': 'abc',
          'brand': 'Hot Wheels',
          'model_name': 'Test',
          'created_at': DateTime(2023).toIso8601String(),
        }
      ];
      when(() => mockDataSource.watchCars())
          .thenAnswer((_) => Stream.value(mockData));

      final stream = repository.carsStream;

      expect(
        stream,
        emits([
          isA<CarModel>()
              .having((c) => c.id, 'id', '123')
              .having((c) => c.brand, 'brand', 'Hot Wheels'),
        ]),
      );
    });

    test('addCar passes mapped data to data source', () async {
      when(() => mockDataSource.addCar(any(), any()))
          .thenAnswer((_) async {});

      await repository.addCar(
        brand: 'Majorette',
        modelName: 'Porsche',
        purchasePrice: 10,
        estimatedValue: 20,
      );

      verify(() => mockDataSource.addCar(
            {
              'brand': 'Majorette',
              'model_name': 'Porsche',
              'toy_maker': null,
              'series': null,
              'purchase_date': any(), // It defaults to now in repo if not passed
              'purchase_price': 10.0,
              'estimated_value': 20.0,
            },
            [],
          )).called(1);
    });
  });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:autoworld164/features/hunting/data/repositories/hunting_repository.dart';
import 'package:autoworld164/features/hunting/presentation/cubit/hunting_cubit.dart';

import '../../../support/mocks.dart';

void main() {
  late MockHuntingRepository huntingRepository;

  setUp(() {
    huntingRepository = MockHuntingRepository();
  });

  group('HuntingCubit', () {
    final mockResults = [
      HuntingResult(
        shopName: 'Allegro',
        searchUrl: 'https://allegro.pl/listing?string=test',
        promoQuery: 'https://allegro.pl/listing?string=test+promocja',
      ),
    ];

    blocTest<HuntingCubit, HuntingState>(
      'emits [loading, data] when search is called with valid query',
      build: () {
        when(() => huntingRepository.getSearchSources(any()))
            .thenReturn(mockResults);
        return HuntingCubit(huntingRepository);
      },
      act: (cubit) => cubit.search('test'),
      expect: () => [
        const HuntingState.loading(),
        HuntingState.data(results: mockResults, query: 'test'),
      ],
    );

    blocTest<HuntingCubit, HuntingState>(
      'emits [initial] when search is called with empty query',
      build: () => HuntingCubit(huntingRepository),
      act: (cubit) => cubit.search(' '),
      expect: () => [
        const HuntingState.initial(),
      ],
    );

    blocTest<HuntingCubit, HuntingState>(
      'emits [initial] when clear is called',
      build: () => HuntingCubit(huntingRepository),
      act: (cubit) => cubit.clear(),
      expect: () => [
        const HuntingState.initial(),
      ],
    );
  });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myapp/features/news/models/news_model.dart';
import 'package:myapp/features/news/presentation/news_cubit.dart';

import '../../../support/mocks.dart';

void main() {
  late MockNewsRepository newsRepository;

  setUp(() {
    newsRepository = MockNewsRepository();
  });

  group('NewsCubit', () {
    final mockNews = [
      NewsModel(
        id: '1',
        title: 'Recent News',
        content: 'Content',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];

    blocTest<NewsCubit, NewsState>(
      'starts loading news on creation and filters properly',
      build: () {
        when(() => newsRepository.watchNews())
            .thenAnswer((_) => Stream.value(mockNews).asyncMap((event) async {
                  await Future.delayed(Duration.zero);
                  return event;
                }));
        return NewsCubit(newsRepository);
      },
      expect: () => [
        const NewsState.loading(),
        predicate<NewsState>((state) {
          if (state is! Data) return false;
          return state.news.length == 1 && state.news.first.id == '1';
        }),
      ],
    );

    blocTest<NewsCubit, NewsState>(
      'manual loadNews triggers success',
      build: () {
        when(() => newsRepository.watchNews())
            .thenAnswer((_) => Stream.value(<NewsModel>[]));
        return NewsCubit(newsRepository);
      },
      act: (cubit) {
        when(() => newsRepository.watchNews())
            .thenAnswer((_) => Stream.value(mockNews).asyncMap((event) async {
                  await Future.delayed(Duration.zero);
                  return event;
                }));
        cubit.loadNews();
      },
      verify: (cubit) {
        expect(cubit.state, isA<Data>());
        final data = cubit.state as Data;
        expect(data.news.length, equals(1));
        expect(data.news.first.id, equals('1'));
      },
    );

    blocTest<NewsCubit, NewsState>(
      'manual loadNews triggers error',
      build: () {
        when(() => newsRepository.watchNews())
            .thenAnswer((_) => Stream.value(<NewsModel>[]));
        return NewsCubit(newsRepository);
      },
      act: (cubit) {
        when(() => newsRepository.watchNews())
            .thenAnswer((_) => Stream.error(Exception('fail')));
        cubit.loadNews();
      },
      expect: () => [
        const NewsState.loading(),
        isA<Error>(),
      ],
    );
  });
}

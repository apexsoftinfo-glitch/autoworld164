import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myapp/app/session/data/repositories/session_repository.dart';
import 'package:myapp/app/session/models/session_status_model.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../support/mocks.dart';

void main() {
  late MockAuthRepository authRepository;
  late MockSharedUserRepository sharedUserRepository;
  late MockSubscriptionRepository subscriptionRepository;

  late BehaviorSubject<dynamic> authController;
  late BehaviorSubject<dynamic> profileController;
  late BehaviorSubject<bool> isProController;

  setUp(() {
    authRepository = MockAuthRepository();
    sharedUserRepository = MockSharedUserRepository();
    subscriptionRepository = MockSubscriptionRepository();

    authController = BehaviorSubject.seeded(null);
    profileController = BehaviorSubject.seeded(null);
    isProController = BehaviorSubject.seeded(false);

    when(
      () => authRepository.watchPrincipal(),
    ).thenAnswer((_) => authController.stream.cast());
    when(
      () => sharedUserRepository.watchSharedUser(any()),
    ).thenAnswer((_) => profileController.stream.cast());
    when(
      () => subscriptionRepository.watchIsPro(any()),
    ).thenAnswer((_) => isProController.stream);
    when(
      () => sharedUserRepository.getSharedUser(any()),
    ).thenAnswer((_) async => null);
    when(
      () => subscriptionRepository.getIsPro(any()),
    ).thenAnswer((_) async => false);
  });

  tearDown(() async {
    await authController.close();
    await profileController.close();
    await isProController.close();
  });

  test('emits unauthenticated when there is no auth principal', () async {
    final repository = SessionRepositoryImpl(
      authRepository,
      sharedUserRepository,
      subscriptionRepository,
    );

    await Future<void>.delayed(const Duration(milliseconds: 10));

    expect(repository.current, const SessionStatusModel.unauthenticated());

    repository.dispose();
  });

  test(
    'builds authenticated guest session from profile and subscription streams',
    () async {
      final repository = SessionRepositoryImpl(
        authRepository,
        sharedUserRepository,
        subscriptionRepository,
      );

      authController.add(
        buildPrincipal(userId: 'guest-1', email: null, isAnonymous: true),
      );
      profileController.add(buildSharedUser(id: 'guest-1', firstName: 'Adam'));
      isProController.add(true);

      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(
        repository.current,
        SessionStatusModel.authenticated(
          session: buildSessionModel(
            userId: 'guest-1',
            isAnonymous: true,
            isPro: true,
            sharedUser: buildSharedUser(id: 'guest-1', firstName: 'Adam'),
          ),
        ),
      );

      repository.dispose();
    },
  );

  test('switches session when auth principal changes', () async {
    final repository = SessionRepositoryImpl(
      authRepository,
      sharedUserRepository,
      subscriptionRepository,
    );

    authController.add(
      buildPrincipal(userId: 'guest-1', email: null, isAnonymous: true),
    );
    profileController.add(buildSharedUser(id: 'guest-1', firstName: 'Guest'));

    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(
      repository.current,
      SessionStatusModel.authenticated(
        session: buildSessionModel(
          userId: 'guest-1',
          isAnonymous: true,
          sharedUser: buildSharedUser(id: 'guest-1', firstName: 'Guest'),
        ),
      ),
    );

    authController.add(
      buildPrincipal(
        userId: 'user-2',
        email: 'user@example.com',
        isAnonymous: false,
      ),
    );
    profileController.add(buildSharedUser(id: 'user-2', firstName: 'User'));

    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(
      repository.current,
      SessionStatusModel.authenticated(
        session: buildSessionModel(
          userId: 'user-2',
          email: 'user@example.com',
          isAnonymous: false,
          sharedUser: buildSharedUser(id: 'user-2', firstName: 'User'),
        ),
      ),
    );

    repository.dispose();
  });
}

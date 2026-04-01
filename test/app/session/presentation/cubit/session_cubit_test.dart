import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myapp/app/session/models/session_status_model.dart';
import 'package:myapp/app/session/presentation/cubit/session_cubit.dart';

import '../../../../support/mocks.dart';

void main() {
  late MockSessionRepository sessionRepository;
  late StreamController<SessionStatusModel> sessionController;

  setUp(() {
    sessionRepository = MockSessionRepository();
    sessionController = StreamController<SessionStatusModel>();

    when(
      () => sessionRepository.sessionStream,
    ).thenAnswer((_) => sessionController.stream);
    when(
      () => sessionRepository.current,
    ).thenReturn(const SessionStatusModel.loading());
    when(() => sessionRepository.refresh()).thenAnswer((_) async {});
  });

  tearDown(() async {
    if (!sessionController.isClosed) {
      await sessionController.close();
    }
  });

  test('starts in initial before first repository emission', () {
    final cubit = SessionCubit(sessionRepository);

    expect(cubit.state, const SessionState.initial());

    cubit.close();
  });

  blocTest<SessionCubit, SessionState>(
    'emits unauthenticated when repository emits unauthenticated state',
    build: () => SessionCubit(sessionRepository),
    act: (_) async =>
        sessionController.add(const SessionStatusModel.unauthenticated()),
    expect: () => [const SessionState.unauthenticated()],
  );

  blocTest<SessionCubit, SessionState>(
    'emits authenticated when repository emits session model',
    build: () => SessionCubit(sessionRepository),
    act: (_) => sessionController.add(
      buildAuthenticatedSessionStatus(userId: 'guest-1', isAnonymous: true),
    ),
    expect: () => [
      SessionState.authenticated(
        session: buildSessionModel(userId: 'guest-1', isAnonymous: true),
      ),
    ],
  );

  blocTest<SessionCubit, SessionState>(
    'emits error when repository stream fails',
    build: () => SessionCubit(sessionRepository),
    act: (_) async {
      sessionController.addError(Exception('network error'));
      await sessionController.close();
    },
    expect: () => [const SessionState.error(errorKey: 'network_error')],
  );
}

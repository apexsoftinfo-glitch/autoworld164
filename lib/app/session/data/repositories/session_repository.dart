import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../features/auth/data/repositories/auth_repository.dart';
import '../../../../features/auth/models/auth_principal_model.dart';
import '../../../../features/profiles/data/repositories/shared_user_repository.dart';
import '../../../../features/profiles/models/shared_user_model.dart';
import '../../../../features/subscription/data/repositories/subscription_repository.dart';
import '../../models/session_status_model.dart';
import '../../models/user_session_model.dart';

// Keep this repository read-only. It aggregates the current session state
// and must not perform profile creation or any other write-side effects.
abstract class SessionRepository {
  Stream<SessionStatusModel> get sessionStream;

  SessionStatusModel get current;

  Future<void> refresh();

  void dispose();
}

@LazySingleton(as: SessionRepository)
class SessionRepositoryImpl implements SessionRepository {
  SessionRepositoryImpl(
    this._authRepository,
    this._sharedUserRepository,
    this._subscriptionRepository,
  ) {
    _startSessionStream();
  }

  final AuthRepository _authRepository;
  final SharedUserRepository _sharedUserRepository;
  final SubscriptionRepository _subscriptionRepository;

  final BehaviorSubject<SessionStatusModel> _controller =
      BehaviorSubject<SessionStatusModel>.seeded(
        const SessionStatusModel.loading(),
      );
  StreamSubscription<SessionStatusModel>? _sessionSubscription;

  @override
  Stream<SessionStatusModel> get sessionStream => _controller.stream.distinct();

  @override
  SessionStatusModel get current => _controller.value;

  @override
  Future<void> refresh() async {
    _startSessionStream();

    final currentSession = current.sessionOrNull;
    final userId = currentSession?.userId;
    if (userId == null) return;

    try {
      final results = await Future.wait<Object?>([
        _sharedUserRepository.getSharedUser(userId),
        _subscriptionRepository.getIsPro(userId),
      ]);
      final sharedUser = results[0] as SharedUserModel?;
      final isPro = results[1] as bool;

      _controller.add(
        SessionStatusModel.authenticated(
          session: UserSessionModel(
            userId: currentSession!.userId,
            email: currentSession.email,
            isAnonymous: currentSession.isAnonymous,
            sharedUser: sharedUser,
            isPro: isPro,
          ),
        ),
      );
    } catch (error) {
      debugPrint('❌ [SessionRepository] refresh error: $error');
      rethrow;
    }
  }

  @override
  void dispose() {
    _sessionSubscription?.cancel();
    _controller.close();
  }

  Stream<SessionStatusModel> _buildSessionStream() {
    return _authRepository.watchPrincipal().distinct(_samePrincipal).switchMap((
      principal,
    ) {
      if (principal == null) {
        return Stream<SessionStatusModel>.value(
          const SessionStatusModel.unauthenticated(),
        );
      }

      return Rx.combineLatest2<SharedUserModel?, bool, SessionStatusModel>(
        _sharedUserRepository.watchSharedUser(principal.userId),
        _subscriptionRepository.watchIsPro(principal.userId),
        (sharedUser, isPro) {
          return SessionStatusModel.authenticated(
            session: UserSessionModel(
              userId: principal.userId,
              email: principal.email,
              isAnonymous: principal.isAnonymous,
              sharedUser: sharedUser,
              isPro: isPro,
            ),
          );
        },
      ).startWith(const SessionStatusModel.loading());
    });
  }

  bool _samePrincipal(AuthPrincipalModel? previous, AuthPrincipalModel? next) {
    return previous?.userId == next?.userId &&
        previous?.email == next?.email &&
        previous?.isAnonymous == next?.isAnonymous;
  }

  void _startSessionStream() {
    _sessionSubscription?.cancel();
    _sessionSubscription = _buildSessionStream().listen(
      _controller.add,
      onError: (Object error, StackTrace stackTrace) {
        debugPrint('❌ [SessionRepository] stream error: $error');
        _controller.addError(error, stackTrace);
      },
    );
  }
}

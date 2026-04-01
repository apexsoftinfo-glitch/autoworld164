import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

abstract class SubscriptionDataSource {
  Stream<bool> watchIsPro(String userId);

  Future<bool> getIsPro(String userId);

  Future<void> purchasePro(String userId);

  // Temporary developer-only override for toggling Pro before RevenueCat is wired.
  Future<void> setDeveloperProOverride({
    required String userId,
    required bool isPro,
  });
}

@LazySingleton(as: SubscriptionDataSource)
class FakeSubscriptionDataSource implements SubscriptionDataSource {
  final _controllers = <String, BehaviorSubject<bool>>{};

  @override
  Stream<bool> watchIsPro(String userId) {
    debugPrint(
      'ℹ️ [SubscriptionDataSource] watchIsPro subscribed userId=$userId',
    );
    return _controllerFor(userId).stream.distinct();
  }

  @override
  Future<bool> getIsPro(String userId) async {
    final isPro = _controllerFor(userId).value;
    debugPrint(
      'ℹ️ [SubscriptionDataSource] getIsPro userId=$userId isPro=$isPro',
    );
    return isPro;
  }

  @override
  Future<void> purchasePro(String userId) async {
    debugPrint(
      'ℹ️ [SubscriptionDataSource] purchasePro started userId=$userId',
    );
    _controllerFor(userId).add(true);
    debugPrint(
      '✅ [SubscriptionDataSource] purchasePro succeeded userId=$userId',
    );
  }

  @override
  Future<void> setDeveloperProOverride({
    required String userId,
    required bool isPro,
  }) async {
    debugPrint(
      'ℹ️ [SubscriptionDataSource] setDeveloperProOverride started userId=$userId isPro=$isPro',
    );
    _controllerFor(userId).add(isPro);
    debugPrint(
      '✅ [SubscriptionDataSource] setDeveloperProOverride succeeded userId=$userId isPro=$isPro',
    );
  }

  BehaviorSubject<bool> _controllerFor(String userId) {
    return _controllers.putIfAbsent(userId, () {
      debugPrint(
        'ℹ️ [SubscriptionDataSource] Creating controller userId=$userId initialIsPro=false',
      );
      return BehaviorSubject<bool>.seeded(false);
    });
  }
}

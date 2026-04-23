import 'package:mocktail/mocktail.dart';
import 'package:autoworld164/app/locale/data/repositories/app_locale_repository.dart';
import 'package:autoworld164/app/session/data/repositories/session_repository.dart';
import 'package:autoworld164/app/session/models/session_status_model.dart';
import 'package:autoworld164/app/session/models/user_session_model.dart';
import 'package:autoworld164/features/auth/data/repositories/auth_repository.dart';
import 'package:autoworld164/features/auth/models/auth_principal_model.dart';
import 'package:autoworld164/features/profiles/data/repositories/shared_user_repository.dart';
import 'package:autoworld164/features/profiles/models/shared_user_model.dart';
import 'package:autoworld164/features/subscription/data/repositories/subscription_repository.dart';
import 'package:autoworld164/features/garage/data/repositories/cars_repository.dart';
import 'package:autoworld164/features/news/data/news_repository.dart';
import 'package:autoworld164/features/hunting/data/repositories/hunting_repository.dart';
import 'package:autoworld164/features/settings/data/repositories/settings_repository.dart';

import 'package:autoworld164/features/garage/presentation/cubit/cars_collection_cubit.dart';
import 'package:autoworld164/app/session/presentation/cubit/session_cubit.dart';
import 'package:autoworld164/features/settings/presentation/settings_cubit.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockCarsRepository extends Mock implements CarsRepository {}
class MockCarsCollectionCubit extends Mock implements CarsCollectionCubit {}
class MockNewsRepository extends Mock implements NewsRepository {}
class MockHuntingRepository extends Mock implements HuntingRepository {}
class MockSessionCubit extends Mock implements SessionCubit {}
class MockSettingsCubit extends Mock implements SettingsCubit {}


class MockSharedUserRepository extends Mock implements SharedUserRepository {}

class MockSubscriptionRepository extends Mock
    implements SubscriptionRepository {}

class MockAppLocaleRepository extends Mock implements AppLocaleRepository {}

class MockSessionRepository extends Mock implements SessionRepository {}
class MockSettingsRepository extends Mock implements SettingsRepository {}

AuthPrincipalModel buildPrincipal({
  required String userId,
  String? email,
  bool isAnonymous = false,
}) {
  return AuthPrincipalModel(
    userId: userId,
    email: email,
    isAnonymous: isAnonymous,
  );
}

SharedUserModel buildSharedUser({required String id, String? firstName}) {
  return SharedUserModel(id: id, firstName: firstName);
}

UserSessionModel buildSessionModel({
  required String userId,
  String? email,
  bool isAnonymous = false,
  bool isPro = false,
  SharedUserModel? sharedUser,
}) {
  return UserSessionModel(
    userId: userId,
    email: email,
    isAnonymous: isAnonymous,
    sharedUser: sharedUser,
    isPro: isPro,
  );
}

SessionStatusModel buildAuthenticatedSessionStatus({
  required String userId,
  String? email,
  bool isAnonymous = false,
  bool isPro = false,
  SharedUserModel? sharedUser,
}) {
  return SessionStatusModel.authenticated(
    session: buildSessionModel(
      userId: userId,
      email: email,
      isAnonymous: isAnonymous,
      isPro: isPro,
      sharedUser: sharedUser,
    ),
  );
}

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../features/profiles/models/shared_user_model.dart';
import 'user_tier.dart';

part 'user_session_model.freezed.dart';

@freezed
abstract class UserSessionModel with _$UserSessionModel {
  const UserSessionModel._();

  const factory UserSessionModel({
    required String userId,
    required String? email,
    required bool isAnonymous,
    required SharedUserModel? sharedUser,
    @Default(false) bool isPro,
  }) = _UserSessionModel;

  UserTier get tier {
    if (isPro) return UserTier.pro;
    if (isAnonymous) return UserTier.guest;
    return UserTier.registered;
  }

  bool get shouldShowRegisterCTA => isAnonymous;

  bool get shouldShowProtectProBanner => isAnonymous && isPro;

  String? get displayNameOrNull {
    final firstName = sharedUser?.firstName;
    if (firstName != null && firstName.isNotEmpty) return firstName;
    if (email != null && email!.isNotEmpty) return email!;
    return null;
  }
}

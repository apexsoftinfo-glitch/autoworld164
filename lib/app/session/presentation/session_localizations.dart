import 'package:flutter/widgets.dart';

import '../../../l10n/l10n.dart';
import '../models/user_session_model.dart';
import '../models/user_tier.dart';
import 'cubit/session_cubit.dart';

extension SessionLocalizationBuildContextX on BuildContext {
  String sessionDisplayName(SessionState session) {
    final l10n = this.l10n;

    return switch (session) {
      SessionAuthenticated(:final session) => _userDisplayName(l10n, session),
      SessionInitial() => l10n.loadingLabel,
      SessionUnauthenticated() => l10n.registeredUserDisplayName,
      SessionError() => l10n.sessionErrorTitle,
    };
  }

  String accountTypeLabel(SessionState session) {
    return session.isAnonymousUser
        ? l10n.accountTypeGuest
        : l10n.accountTypeRegistered;
  }

  String booleanLabel(bool value) {
    return value ? l10n.commonYes : l10n.commonNo;
  }

  String tierLabel(UserTier tier) {
    return switch (tier) {
      UserTier.guest => l10n.userTierGuest,
      UserTier.registered => l10n.userTierRegistered,
      UserTier.pro => l10n.userTierPro,
    };
  }

  String _userDisplayName(AppLocalizations l10n, UserSessionModel session) {
    final displayName = session.displayNameOrNull;
    if (displayName != null) {
      return displayName;
    }

    return session.isAnonymous
        ? l10n.guestDisplayName
        : l10n.registeredUserDisplayName;
  }
}

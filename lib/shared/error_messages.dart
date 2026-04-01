import '../l10n/l10n.dart';

String mapErrorToKey(Object error) {
  final message = error.toString().toLowerCase();

  if (message.contains('invalid login credentials')) {
    return 'invalid_credentials';
  }

  if (message.contains('anonymous sign-ins are disabled')) {
    return 'anonymous_auth_disabled';
  }

  if (message.contains('email')) {
    return 'email_error';
  }

  if (message.contains('password')) {
    return 'password_error';
  }

  if (message.contains('network')) {
    return 'network_error';
  }

  if (message.contains('delete_account_setup_required')) {
    return 'delete_account_setup_required';
  }

  if (message.contains('delete_account_failed')) {
    return 'delete_account_failed';
  }

  if ((message.contains('shared_users') || message.contains('profiles')) &&
      (message.contains('schema cache') ||
          message.contains('column') ||
          message.contains('relation'))) {
    return 'shared_users_setup_required';
  }

  return 'unknown_error';
}

String messageForErrorKey(AppLocalizations l10n, String? errorKey) {
  return switch (errorKey) {
    'invalid_credentials' => l10n.errorInvalidCredentials,
    'anonymous_auth_disabled' => l10n.errorAnonymousAuthDisabled,
    'email_error' => l10n.errorEmail,
    'password_error' => l10n.errorPassword,
    'network_error' => l10n.errorNetwork,
    'delete_account_setup_required' => l10n.errorDeleteAccountSetupRequired,
    'delete_account_failed' => l10n.errorDeleteAccountFailed,
    'shared_users_setup_required' => l10n.errorSharedUsersSetupRequired,
    'delete_account_not_implemented' => l10n.errorDeleteAccountNotImplemented,
    'unknown_error' || null => l10n.errorUnknown,
    _ => l10n.errorWithKey(errorKey),
  };
}

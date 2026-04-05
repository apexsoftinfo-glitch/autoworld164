import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/locale/models/app_locale_option_model.dart';
import '../../../../app/locale/presentation/cubit/app_locale_cubit.dart';
import '../../../../app/developer/ui/developer_screen.dart';
import '../../../../app/profile/presentation/cubit/account_actions_cubit.dart';
import '../../../../app/session/presentation/cubit/session_cubit.dart';
import '../../../../app/session/presentation/session_localizations.dart';
import '../../../../core/di/injection.dart';
import '../../../../features/auth/presentation/ui/login_screen.dart';
import '../../../../features/auth/presentation/ui/register_screen.dart';
import '../../../../core/config/revenuecat_config.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/error_messages.dart';
import '../cubit/profile_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppLocaleCubit>.value(value: getIt<AppLocaleCubit>()),
        BlocProvider<SessionCubit>.value(value: getIt<SessionCubit>()),
        BlocProvider<ProfileCubit>(create: (_) => getIt<ProfileCubit>()),
        BlocProvider<AccountActionsCubit>(
          create: (_) => getIt<AccountActionsCubit>(),
        ),
      ],
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatefulWidget {
  const _ProfileView();

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
  late final TextEditingController _firstNameController;
  late final FocusNode _firstNameFocusNode;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _firstNameFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _firstNameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionCubit>().state;
    final sharedUser = session.sharedUserOrNull;
    final firstName = sharedUser?.firstName ?? '';
    final l10n = context.l10n;

    if (!_firstNameFocusNode.hasFocus &&
        _firstNameController.text != firstName) {
      _firstNameController.text = firstName;
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state.successKey == 'profile_saved') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.profileSavedSnackbar)),
              );
              context.read<ProfileCubit>().clearFeedback();
            }
          },
        ),
        BlocListener<AccountActionsCubit, AccountActionsState>(
          listener: (context, state) {
            if (state.successKey == 'pro_enabled') {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(l10n.proEnabledSnackbar)));
              context.read<AccountActionsCubit>().clearFeedback();
            }
          },
        ),
      ],
      child: PopScope(
        canPop: !_hasUnsavedChanges(firstName),
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop || !_hasUnsavedChanges(firstName)) return;

          final shouldDiscard = await _confirmDiscardChanges(context);
          if (!context.mounted || !shouldDiscard) return;
          Navigator.of(context).pop();
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                l10n.profileTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            extendBodyBehindAppBar: true,
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/warm_garage.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withValues(
                      alpha: 0.8,
                    ), // Very dark to keep form elements readable
                    BlendMode.darken,
                  ),
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: BlocBuilder<ProfileCubit, ProfileState>(
                        builder: (context, profileState) {
                          return BlocBuilder<
                            AccountActionsCubit,
                            AccountActionsState
                          >(
                            builder: (context, accountState) {
                              final isSavingName = profileState.isSaving;
                              final activeAccountAction =
                                  accountState.activeAction;
                              final isInteractionLocked =
                                  isSavingName || activeAccountAction != null;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  if (session.shouldShowProtectProBanner) ...[
                                    const _ProtectProBanner(),
                                    const SizedBox(height: 24),
                                  ],
                                  TextField(
                                    controller: _firstNameController,
                                    focusNode: _firstNameFocusNode,
                                    enabled: !isInteractionLocked,
                                    keyboardType: TextInputType.name,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration: InputDecoration(
                                      labelText: l10n.firstNameFieldLabel,
                                    ),
                                    textInputAction: TextInputAction.done,
                                    onSubmitted: (_) =>
                                        _saveFirstName(context, session),
                                  ),
                                  const SizedBox(height: 16),
                                  FilledButton(
                                    onPressed: !isInteractionLocked
                                        ? () => _saveFirstName(context, session)
                                        : null,
                                    child: isSavingName
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Text(l10n.saveFirstNameButtonLabel),
                                  ),
                                  const SizedBox(height: 16),
                                  _AppLanguageDropdown(
                                    isEnabled: !isInteractionLocked,
                                  ),
                                  if (profileState.errorKey != null) ...[
                                    const SizedBox(height: 16),
                                    SelectableText(
                                      messageForErrorKey(
                                        l10n,
                                        profileState.errorKey,
                                      ),
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.error,
                                      ),
                                    ),
                                  ],
                                  if (accountState.errorKey != null) ...[
                                    const SizedBox(height: 16),
                                    SelectableText(
                                      messageForErrorKey(
                                        l10n,
                                        accountState.errorKey,
                                      ),
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.error,
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 32),
                                  if (session.isAnonymousUser) ...[
                                    FilledButton.tonal(
                                      onPressed: !isInteractionLocked
                                          ? () async {
                                              final result =
                                                  await Navigator.of(
                                                    context,
                                                  ).push<bool>(
                                                    MaterialPageRoute<bool>(
                                                      builder: (_) =>
                                                          const RegisterScreen(),
                                                    ),
                                                  );
                                              if (!context.mounted) return;
                                              if (result == true) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      l10n.accountSecuredSnackbar,
                                                    ),
                                                  ),
                                                );
                                              }
                                            }
                                          : null,
                                      child: Text(l10n.registerButtonLabel),
                                    ),
                                    const SizedBox(height: 12),
                                    OutlinedButton(
                                      onPressed: !isInteractionLocked
                                          ? () => Navigator.of(context)
                                                .push<void>(
                                                  MaterialPageRoute<void>(
                                                    builder: (_) =>
                                                        const LoginScreen(),
                                                  ),
                                                )
                                          : null,
                                      child: Text(l10n.loginButtonLabel),
                                    ),
                                    const SizedBox(height: 12),
                                  ],
                                  if (!session.isAnonymousUser) ...[
                                    OutlinedButton(
                                      onPressed: !isInteractionLocked
                                          ? () => context
                                                .read<AccountActionsCubit>()
                                                .signOut()
                                          : null,
                                      child:
                                          activeAccountAction ==
                                              AccountAction.signOut
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : Text(l10n.logoutButtonLabel),
                                    ),
                                    const SizedBox(height: 12),
                                  ],
                                  if (!session.isProUser &&
                                      RevenueCatConfig.isEnabled) ...[
                                    FilledButton(
                                      onPressed:
                                          !isInteractionLocked &&
                                              session.userIdOrNull != null
                                          ? () => context
                                                .read<AccountActionsCubit>()
                                                .buyPro(session.userIdOrNull!)
                                          : null,
                                      child:
                                          activeAccountAction ==
                                              AccountAction.buyPro
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : Text(l10n.buyProButtonLabel),
                                    ),
                                    const SizedBox(height: 12),
                                  ],
                                  OutlinedButton(
                                    onPressed: !isInteractionLocked
                                        ? () => _confirmDeleteAccount(context)
                                        : null,
                                    child:
                                        activeAccountAction ==
                                            AccountAction.deleteAccount
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Text(l10n.deleteAccountButtonLabel),
                                  ),
                                  if (kDebugMode) ...[
                                    const Divider(height: 48),
                                    _ProfileSummary(session: session),
                                    const SizedBox(height: 12),
                                    OutlinedButton.icon(
                                      onPressed: !isInteractionLocked
                                          ? () => Navigator.of(context)
                                                .push<void>(
                                                  MaterialPageRoute<void>(
                                                    builder: (_) =>
                                                        const DeveloperScreen(),
                                                  ),
                                                )
                                          : null,
                                      icon: const Icon(Icons.developer_mode),
                                      label: Text(l10n.developerToolsTitle),
                                    ),
                                  ],
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _hasUnsavedChanges(String firstName) {
    return _firstNameController.text.trim() != firstName.trim();
  }

  Future<bool> _confirmDiscardChanges(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.discardChangesTitle),
        content: Text(context.l10n.discardChangesBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.l10n.stayButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(context.l10n.discardButtonLabel),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  Future<void> _confirmDeleteAccount(BuildContext context) async {
    final l10n = context.l10n;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteAccountDialogTitle),
        content: Text(l10n.deleteAccountDialogBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.deleteAccountCancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: Text(l10n.deleteAccountConfirmButtonLabel),
          ),
        ],
      ),
    );

    if (context.mounted && result == true) {
      context.read<AccountActionsCubit>().deleteAccount();
    }
  }

  void _saveFirstName(BuildContext context, SessionState session) {
    final userId = session.userIdOrNull;
    if (userId == null) return;

    FocusScope.of(context).unfocus();
    context.read<ProfileCubit>().saveFirstName(
      userId: userId,
      firstName: _firstNameController.text,
    );
  }
}

class _AppLanguageDropdown extends StatelessWidget {
  const _AppLanguageDropdown({required this.isEnabled});

  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<AppLocaleCubit, AppLocaleState>(
      builder: (context, state) {
        final isSelectionEnabled = isEnabled && !state.isSaving;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<AppLocaleOptionModel>(
              initialValue: state.selectedOption,
              decoration: InputDecoration(
                labelText: l10n.profileLanguageSectionTitle,
                helperText: l10n.profileLanguageSectionDescription,
              ),
              items: [
                DropdownMenuItem(
                  value: AppLocaleOptionModel.system,
                  child: Text(l10n.languageOptionSystem),
                ),
                DropdownMenuItem(
                  value: AppLocaleOptionModel.polish,
                  child: Text(l10n.languageOptionPolish),
                ),
                DropdownMenuItem(
                  value: AppLocaleOptionModel.english,
                  child: Text(l10n.languageOptionEnglish),
                ),
              ],
              onChanged: isSelectionEnabled
                  ? (option) {
                      if (option == null) return;
                      context.read<AppLocaleCubit>().selectLocale(option);
                    }
                  : null,
            ),
            if (state.selectedOption == AppLocaleOptionModel.system) ...[
              const SizedBox(height: 4),
              Text(
                l10n.languageOptionSystemDescription,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            if (state.errorKey != null) ...[
              const SizedBox(height: 8),
              SelectableText(
                messageForErrorKey(l10n, state.errorKey),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _ProfileSummary extends StatelessWidget {
  const _ProfileSummary({required this.session});

  final SessionState session;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.sessionDisplayName(session),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            SelectableText(l10n.sessionUserId(session.userIdOrNull ?? '-')),
            const SizedBox(height: 8),
            SelectableText(l10n.sessionEmail(session.emailOrNull ?? '-')),
            const SizedBox(height: 8),
            SelectableText(l10n.sessionPlan(context.tierLabel(session.tier))),
          ],
        ),
      ),
    );
  }
}

class _ProtectProBanner extends StatelessWidget {
  const _ProtectProBanner();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.protectProBannerTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onErrorContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.protectProBannerBody,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

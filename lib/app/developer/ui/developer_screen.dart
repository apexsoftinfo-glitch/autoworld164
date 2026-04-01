import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../profile/presentation/cubit/account_actions_cubit.dart';
import '../../../core/di/injection.dart';
import '../../../core/config/app_config.dart';
import '../../../core/config/revenuecat_config.dart';
import '../../../l10n/l10n.dart';
import '../../session/presentation/cubit/session_cubit.dart';
import '../../session/presentation/session_localizations.dart';

class DeveloperScreen extends StatelessWidget {
  const DeveloperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SessionCubit>.value(value: getIt<SessionCubit>()),
        BlocProvider<AccountActionsCubit>(
          create: (_) => getIt<AccountActionsCubit>(),
        ),
      ],
      child: const _DeveloperView(),
    );
  }
}

class _DeveloperView extends StatelessWidget {
  const _DeveloperView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.developerToolsTitle)),
      body: SafeArea(
        child: BlocBuilder<SessionCubit, SessionState>(
          builder: (context, session) {
            final userId = session.userIdOrNull;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l10n.developerDiagnosticsTitle,
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.developerDiagnosticsBody,
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 24),
                      if (!AppConfig.hasRevenueCatKeys) ...[
                        _WarningCard(
                          title: l10n.revenueCatDisconnectedTitle,
                          body: l10n.revenueCatDisconnectedBody,
                        ),
                        const SizedBox(height: 24),
                      ],
                      _SectionCard(
                        title: l10n.sessionSectionTitle,
                        children: [
                          _SelectableInfoRow(
                            label: l10n.firstNameFieldLabel,
                            value: session.sharedUserOrNull?.firstName ?? '-',
                          ),
                          _InfoRow(
                            label: l10n.loggedInLabel,
                            value: context.booleanLabel(
                              session.isAuthenticated,
                            ),
                          ),
                          _InfoRow(
                            label: l10n.anonymousLabel,
                            value: context.booleanLabel(
                              session.isAnonymousUser,
                            ),
                          ),
                          _InfoRow(
                            label: l10n.planLabel,
                            value: context.tierLabel(session.tier),
                          ),
                          _InfoRow(
                            label: l10n.proLabel,
                            value: context.booleanLabel(session.isProUser),
                          ),
                          _SelectableInfoRow(
                            label: l10n.userIdLabel,
                            value: session.userIdOrNull ?? '-',
                          ),
                          _SelectableInfoRow(
                            label: l10n.emailLabel,
                            value: session.emailOrNull ?? '-',
                          ),
                          _SelectableInfoRow(
                            label: l10n.displayNameLabel,
                            value: context.sessionDisplayName(session),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _SectionCard(
                        title: l10n.supabaseSectionTitle,
                        children: [
                          _InfoRow(
                            label: l10n.keysConfiguredLabel,
                            value: context.booleanLabel(
                              AppConfig.hasSupabaseKeys,
                            ),
                          ),
                          _SelectableInfoRow(
                            label: l10n.supabaseUrlLabel,
                            value: AppConfig.hasSupabaseKeys
                                ? AppConfig.maskedSupabaseUrl
                                : l10n.missingValueLabel,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _SectionCard(
                        title: l10n.revenueCatSectionTitle,
                        children: [
                          _InfoRow(
                            label: l10n.supportedPlatformLabel,
                            value: context.booleanLabel(
                              AppConfig.isRevenueCatSupportedPlatform,
                            ),
                          ),
                          _InfoRow(
                            label: l10n.keysConfiguredLabel,
                            value: context.booleanLabel(
                              AppConfig.hasRevenueCatKeys,
                            ),
                          ),
                          _InfoRow(
                            label: l10n.sdkActiveLabel,
                            value: context.booleanLabel(
                              RevenueCatConfig.isEnabled,
                            ),
                          ),
                          _SelectableInfoRow(
                            label: l10n.currentKeySourceLabel,
                            value: AppConfig.hasRevenueCatKeys
                                ? AppConfig.maskedRevenueCatApiKey
                                : l10n.missingValueLabel,
                          ),
                          if (!RevenueCatConfig.isEnabled &&
                              session.isAuthenticated &&
                              userId != null) ...[
                            const SizedBox(height: 8),
                            BlocBuilder<
                              AccountActionsCubit,
                              AccountActionsState
                            >(
                              builder: (context, accountState) {
                                final isLoading =
                                    accountState.activeAction ==
                                    AccountAction.developerProOverride;

                                return SwitchListTile(
                                  value: session.isProUser,
                                  onChanged: isLoading
                                      ? null
                                      : (value) {
                                          context
                                              .read<AccountActionsCubit>()
                                              .setDeveloperProOverride(
                                                userId: userId,
                                                isPro: value,
                                              );
                                        },
                                  title: Text(l10n.debugForceProTitle),
                                  subtitle: Text(l10n.debugForceProSubtitle),
                                );
                              },
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _WarningCard extends StatelessWidget {
  const _WarningCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onErrorContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              body,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _SelectableInfoRow extends StatelessWidget {
  const _SelectableInfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: SelectableText(value)),
        ],
      ),
    );
  }
}

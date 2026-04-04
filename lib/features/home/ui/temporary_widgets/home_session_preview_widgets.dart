import 'package:flutter/material.dart';

import '../../../../app/session/presentation/cubit/session_cubit.dart';
import '../../../../app/session/presentation/session_localizations.dart';
import '../../../../l10n/l10n.dart';

class HomeSessionPreviewButton extends StatelessWidget {
  const HomeSessionPreviewButton({
    required this.isExpanded,
    required this.onTap,
    super.key,
  });

  final bool isExpanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(18));

    return Align(
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: borderRadius,
              border: Border.all(color: Colors.black.withValues(alpha: 0.10)),
            ),
            child: Text(
              isExpanded ? 'Ukryj aktualną sesję' : 'Pokaż aktualną sesję',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeSessionPreviewCard extends StatelessWidget {
  const HomeSessionPreviewCard({required this.session, super.key});

  final SessionState session;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final optionRows =
        <({String label, List<String> options, String selected})>[
          (
            label: 'Typ konta',
            options: [l10n.accountTypeGuest, l10n.accountTypeRegistered],
            selected: context.accountTypeLabel(session),
          ),
          (
            label: 'Pro',
            options: [l10n.commonYes, l10n.commonNo],
            selected: context.booleanLabel(session.isProUser),
          ),
          (
            label: 'Limity',
            options: [
              l10n.userTierGuest,
              l10n.userTierRegistered,
              l10n.userTierPro,
            ],
            selected: context.tierLabel(session.tier),
          ),
        ];
    final dataRows = <String>[
      l10n.sessionFirstName(session.sharedUserOrNull?.firstName ?? '-'),
      l10n.sessionEmail(session.emailOrNull ?? '-'),
      l10n.sessionDisplayNameValue(context.sessionDisplayName(session)),
      l10n.sessionUserId(session.userIdOrNull ?? '-'),
    ];

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            for (final row in optionRows)
              _HomeSessionOptionsRow(
                label: row.label,
                options: row.options,
                selectedLabel: row.selected,
              ),
            for (var index = 0; index < dataRows.length; index++)
              _HomeSessionTextRow(
                text: dataRows[index],
                showDivider: index < dataRows.length - 1,
              ),
          ],
        ),
      ),
    );
  }
}

class _HomeSessionOptionsRow extends StatelessWidget {
  const _HomeSessionOptionsRow({
    required this.label,
    required this.options,
    required this.selectedLabel,
  });

  final String label;
  final List<String> options;
  final String selectedLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 88,
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.black.withValues(alpha: 0.58),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        for (var index = 0; index < options.length; index++)
                          Padding(
                            padding: EdgeInsets.only(
                              right: index < options.length - 1 ? 14 : 0,
                            ),
                            child: Text(
                              options[index],
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: Colors.black.withValues(
                                      alpha: options[index] == selectedLabel
                                          ? 1
                                          : 0.30,
                                    ),
                                    fontWeight: options[index] == selectedLabel
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: Colors.black.withValues(alpha: 0.08)),
      ],
    );
  }
}

class _HomeSessionTextRow extends StatelessWidget {
  const _HomeSessionTextRow({required this.text, required this.showDivider});

  final String text;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: SelectableText(
              text,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(height: 1.4),
            ),
          ),
        ),
        if (showDivider)
          Divider(height: 1, color: Colors.black.withValues(alpha: 0.08)),
      ],
    );
  }
}

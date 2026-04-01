import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../../features/auth/presentation/ui/login_screen.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/error_messages.dart';
import '../../auth/presentation/cubit/welcome_cubit.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WelcomeCubit>(
      create: (_) => getIt<WelcomeCubit>(),
      child: const _WelcomeView(),
    );
  }
}

class _WelcomeView extends StatelessWidget {
  const _WelcomeView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: BlocBuilder<WelcomeCubit, WelcomeState>(
                  builder: (context, state) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _WelcomeAppIcon(),
                        const SizedBox(height: 24),
                        Text(
                          l10n.welcomeTitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.welcomeBody,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        if (state.errorKey != null) ...[
                          const SizedBox(height: 24),
                          SelectableText(
                            messageForErrorKey(l10n, state.errorKey),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ],
                        const SizedBox(height: 32),
                        FilledButton(
                          onPressed: state.isLoading
                              ? null
                              : () => context
                                    .read<WelcomeCubit>()
                                    .continueAsGuest(),
                          child: state.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(l10n.continueAsGuestButtonLabel),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: state.isLoading
                              ? null
                              : () => Navigator.of(context).push<void>(
                                  MaterialPageRoute<void>(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                ),
                          child: Text(l10n.loginButtonLabel),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WelcomeAppIcon extends StatelessWidget {
  const _WelcomeAppIcon();

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    final image = Image.asset(
      'assets/images/icon/icon.png',
      width: 88,
      height: 88,
      fit: BoxFit.cover,
    );

    return Center(
      child: switch (platform) {
        TargetPlatform.android => ClipOval(child: image),
        TargetPlatform.iOS => ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: image,
        ),
        _ => ClipRRect(borderRadius: BorderRadius.circular(24), child: image),
      },
    );
  }
}

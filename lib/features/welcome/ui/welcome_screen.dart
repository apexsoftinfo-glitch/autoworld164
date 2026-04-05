import 'dart:ui';
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
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/images/warm_garage.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                const Color(
                  0xFF2D1B0D,
                ).withValues(alpha: 0.6), // Heavily dimmed for readability
                BlendMode.darken,
              ),
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: BlocBuilder<WelcomeCubit, WelcomeState>(
                    builder: (context, state) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                          child: Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: const Color(
                                  0xFFFFD700,
                                ).withValues(alpha: 0.2),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const _WelcomeAppIcon(),
                                const SizedBox(height: 24),
                                Text(
                                  l10n.welcomeTitle,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        color: const Color(0xFFFFD700),
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  l10n.welcomeBody,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(color: Colors.white70),
                                ),
                                if (state.errorKey != null) ...[
                                  const SizedBox(height: 24),
                                  SelectableText(
                                    messageForErrorKey(l10n, state.errorKey),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.error,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 32),
                                FilledButton(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: const Color(0xFFFFD700),
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                      letterSpacing: 1,
                                    ),
                                  ),
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
                                            color: Colors.black,
                                          ),
                                        )
                                      : Text(
                                          l10n.continueAsGuestButtonLabel
                                              .toUpperCase(),
                                        ),
                                ),
                                const SizedBox(height: 16),
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFFFFD700),
                                    side: const BorderSide(
                                      color: Color(0xFFFFD700),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  onPressed: state.isLoading
                                      ? null
                                      : () => Navigator.of(context).push<void>(
                                          MaterialPageRoute<void>(
                                            builder: (_) => const LoginScreen(),
                                          ),
                                        ),
                                  child: Text(
                                    l10n.loginButtonLabel.toUpperCase(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
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
          borderRadius: BorderRadius.circular(20),
          child: image,
        ),
        _ => ClipRRect(borderRadius: BorderRadius.circular(20), child: image),
      },
    );
  }
}

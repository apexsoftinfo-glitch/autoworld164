import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/developer/ui/developer_screen.dart';
import '../../../../app/session/presentation/cubit/session_cubit.dart';
import '../../../../core/di/injection.dart';
import '../../../../features/profiles/presentation/ui/profile_screen.dart';
import '../../../../l10n/l10n.dart';
import 'home_session_preview_widgets.dart';

class HomeSessionPreviewScreen extends StatelessWidget {
  const HomeSessionPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SessionCubit>.value(
      value: getIt<SessionCubit>(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Aktualna sesja'),
              actions: [
                IconButton(
                  onPressed: () => Navigator.of(context).push<void>(
                    MaterialPageRoute<void>(
                      builder: (_) => const ProfileScreen(),
                    ),
                  ),
                  icon: const Icon(Icons.person_outline),
                ),
              ],
            ),
            body: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      BlocBuilder<SessionCubit, SessionState>(
                        builder: (context, session) {
                          return HomeSessionPreviewCard(session: session);
                        },
                      ),
                      if (kDebugMode) ...[
                        const SizedBox(height: 24),
                        Align(
                          alignment: Alignment.center,
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.of(context).push<void>(
                              MaterialPageRoute<void>(
                                builder: (_) => const DeveloperScreen(),
                              ),
                            ),
                            icon: const Icon(Icons.developer_mode),
                            label: Text(context.l10n.developerToolsTitle),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

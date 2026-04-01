import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../session/presentation/cubit/session_cubit.dart';

class SessionNavigationObserver extends StatelessWidget {
  const SessionNavigationObserver({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SessionCubit, SessionState>(
      listenWhen: (previous, current) {
        final previousUserId = previous.userIdOrNull;
        final currentUserId = current.userIdOrNull;

        final signedOut = previous.isAuthenticated && current.isUnauthenticated;
        final principalChanged = previousUserId != currentUserId;

        return signedOut || principalChanged;
      },
      listener: (context, state) {
        debugPrint(
          'ℹ️ [SessionNavigationObserver] Popping to root currentUserId=${state.userIdOrNull ?? "-"} authenticated=${state.isAuthenticated}',
        );
        Navigator.of(
          context,
          rootNavigator: true,
        ).popUntil((route) => route.isFirst);
      },
      child: child,
    );
  }
}

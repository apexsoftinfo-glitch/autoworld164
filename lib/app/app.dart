import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'locale/presentation/cubit/app_locale_cubit.dart';
import '../l10n/l10n.dart';
import 'navigation/session_navigation_observer.dart';
import 'router/app_gate.dart';
import 'session/presentation/cubit/session_cubit.dart';
import 'ui/missing_supabase_keys_screen.dart';

class App extends StatelessWidget {
  const App({required this.hasSupabaseKeys, super.key});

  final bool hasSupabaseKeys;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppLocaleCubit>.value(
      value: GetIt.I<AppLocaleCubit>(),
      child: BlocBuilder<AppLocaleCubit, AppLocaleState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'AutoWorld164',
            debugShowCheckedModeBanner: false,
            locale: state.localeOrNull,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: const Color(0xFF0C0C0C),
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFFFFD700), // Gold
                secondary: Color(0xFFFF9800), // Amber
                surface: Colors.black54,
              ),
              useMaterial3: true,
            ),
            home: _AppShell(hasSupabaseKeys: hasSupabaseKeys),
          );
        },
      ),
    );
  }
}

class _AppShell extends StatelessWidget {
  const _AppShell({required this.hasSupabaseKeys});

  final bool hasSupabaseKeys;

  @override
  Widget build(BuildContext context) {
    return hasSupabaseKeys
        ? BlocProvider<SessionCubit>.value(
            value: GetIt.I<SessionCubit>(),
            child: const SessionNavigationObserver(child: AppGate()),
          )
        : const MissingSupabaseKeysScreen();
  }
}

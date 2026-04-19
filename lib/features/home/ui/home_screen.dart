import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../profiles/presentation/ui/profile_screen.dart';
import '../../news/ui/news_screen.dart';
import '../../settings/ui/settings_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection.dart';
import '../../garage/presentation/cubit/cars_collection_cubit.dart';
import '../../garage/ui/garage_screen.dart';
import '../../garage/ui/car_form_screen.dart';
import '../../../app/session/presentation/cubit/session_cubit.dart';
import '../../hunting/ui/hunting_screen.dart';
import '../../settings/presentation/settings_cubit.dart';
import '../../../l10n/l10n.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = context.read<SessionCubit>().state.sessionOrNull?.userId;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<CarsCollectionCubit>()),
        BlocProvider.value(value: context.read<SessionCubit>()),
        if (userId != null)
          BlocProvider(create: (context) => getIt<SettingsCubit>()..init(userId)),
      ],
      child: const _HomeScreenView(),
    );
  }
}

class _HomeScreenView extends StatelessWidget {
  const _HomeScreenView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/warm_garage.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              const Color(0xFF2D1B0D).withValues(alpha: 0.4),
              BlendMode.darken,
            ),
          ),
        ),
        child: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BlocBuilder<SettingsCubit, SettingsState>(
                              builder: (context, state) {
                                final garageName = state.maybeWhen(
                                  data: (settings, profile, isGuest, pendingEmail) => settings.garageName,
                                  orElse: () => null,
                                );
                                final title = garageName != null && garageName.isNotEmpty 
                                  ? 'GARAŻ $garageName' 
                                  : 'GARAŻ';
                                return Text(
                                  title.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w200,
                                    letterSpacing: -1,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProfileScreen(),
                            ),
                          ),
                          child: BlocBuilder<SessionCubit, SessionState>(
                            builder: (context, state) {
                              final photoUrl = state.sharedUserOrNull?.photoUrl;
                              return Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFFFFD700).withValues(alpha: 0.5),
                                    width: 1,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x33FFD700),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.black26,
                                  backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                                  child: photoUrl == null ? const Icon(
                                    Icons.person,
                                    color: Color(0xFFFFD700),
                                  ) : null,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),



                    // Navigation Grid
                    const Text(
                      'MENU GŁÓWNE',
                      style: TextStyle(
                        color: Colors.white24,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _VIPCard(
                          label: 'MÓJ GARAŻ',
                          icon: Icons.auto_awesome,
                          color: const Color(0xFFFFD700),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const GarageScreen()),
                          ),
                        ),
                        _VIPCard(
                          label: 'NOWOŚCI',
                          icon: Icons.new_releases,
                          color: const Color(0xFFFFD700),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const NewsScreen()),
                          ),
                        ),
                        _VIPCard(
                          label: 'HOT HUNT',
                          icon: Icons.explore,
                          color: const Color(0xFFFFD700),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const HuntingScreen()),
                          ),
                        ),
                        _VIPCard(
                          label: 'USTAWIENIA',
                          icon: Icons.tune,
                          color: Colors.white,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SettingsScreen()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    const SizedBox(height: 64),
                    Center(
                      child: Text(
                        context.l10n.homeMadeInPoland,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white12,
                          fontSize: 9,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),

            // Unified Bottom Command Bar (Stats + Action)
            Positioned(
              bottom: 32,
              left: 20,
              right: 20,
              child: BlocBuilder<CarsCollectionCubit, CarsCollectionState>(
                builder: (context, state) {
                  final pieces = state.maybeWhen(
                    data: (cars, filtered, purchasePrice, estimatedValue, stats, q, vt) => cars.length.toString(),
                    orElse: () => '0',
                  );
                  final value = state.maybeWhen(
                    data: (cars, filtered, purchasePrice, estimatedValue, stats, q, vt) {
                      final isPolish = Localizations.localeOf(context).languageCode == 'pl';
                      final currencyFormat = NumberFormat.simpleCurrency(
                        locale: isPolish ? 'pl_PL' : 'en_US',
                        name: isPolish ? 'PLN' : 'USD',
                        decimalDigits: 0,
                      );
                      
                      if (estimatedValue >= 1000000) {
                        return '${(estimatedValue / 1000000).toStringAsFixed(1)}M ${currencyFormat.currencySymbol}';
                      } else if (estimatedValue >= 1000) {
                        return '${(estimatedValue / 1000).toStringAsFixed(1)}K ${currencyFormat.currencySymbol}';
                      }
                      return currencyFormat.format(estimatedValue);
                    },
                    orElse: () {
                      final isPolish = Localizations.localeOf(context).languageCode == 'pl';
                      return isPolish ? '0 PLN' : '\$0';
                    },
                  );

                  return _GlassBox(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    borderColor: const Color(0xFFFFD700).withValues(alpha: 0.3),
                    child: Row(
                      children: [
                        const SizedBox(width: 8),
                        _VIPStat(label: 'PIECES', value: pieces),
                        const SizedBox(width: 24),
                        _VIPStat(label: 'VALUE', value: value),
                        const Spacer(),
                        // Stylish Add Button
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const CarFormScreen()),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD700),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFFFFD700,
                                  ).withValues(alpha: 0.4),
                                  blurRadius: 15,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add, color: Colors.black, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'DODAJ MODEL',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 11,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassBox extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color? borderColor;
  const _GlassBox({
    required this.child,
    required this.padding,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: borderColor ?? Colors.white.withValues(alpha: 0.1),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}



class _VIPStat extends StatelessWidget {
  final String label;
  final String value;
  const _VIPStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFD700),
            height: 1.0,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 7,
            fontWeight: FontWeight.w900,
            color: Colors.white38,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

class _VIPCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _VIPCard({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _GlassBox(
      padding: const EdgeInsets.all(0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
                color: color.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

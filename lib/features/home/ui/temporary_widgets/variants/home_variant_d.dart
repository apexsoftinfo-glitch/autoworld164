import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../features/profiles/presentation/ui/profile_screen.dart';

class HomeVariantDScreen extends StatelessWidget {
  const HomeVariantDScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const nightBlue = Color(0xFF0F172A);
    const luminousCyan = Color(0xFF22D3EE);

    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: nightBlue,
        textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
      ),
      child: Scaffold(
        body: Stack(
          children: [
            // --- BACKGROUND ACCENTS ---
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: luminousCyan.withValues(alpha: 0.15),
                ),
              ).animate().fadeIn(duration: 1.seconds).scale(begin: const Offset(0.5, 0.5)),
            ),
            
            SafeArea(
              child: CustomScrollView(
                slivers: [
                  // --- GLOSSY HEADER ---
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AutoWorld164',
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: luminousCyan,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Cześć, Anatol',
                                style: GoogleFonts.outfit(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          _GlowAvatar(
                            onTap: () => Navigator.of(context).push<void>(
                              MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ---主 NAVIGATION TILES (GLASSMORPISM) ---
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: [
                        _GlassTile(
                          title: 'Mój garaż',
                          label: '154 Auta',
                          icon: Icons.auto_awesome_motion_outlined,
                          onTap: () => _notify(context, 'GARAGE'),
                        ),
                        _GlassTile(
                          title: 'Nowości',
                          label: 'Hot! Nowe',
                          icon: Icons.rocket_launch_outlined,
                          onTap: () => _notify(context, 'NEWS'),
                        ),
                        _GlassTile(
                          title: 'Market',
                          label: '12 Aukcji',
                          icon: Icons.currency_exchange_outlined,
                          onTap: () => _notify(context, 'MARKET'),
                        ),
                        _GlassTile(
                          title: 'Ustawienia',
                          label: 'Konfiguracja',
                          icon: Icons.blur_on_outlined,
                          onTap: () => _notify(context, 'SETTINGS'),
                        ),
                      ],
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 40)),

                  // --- GLOWING DASHBOARD ---
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _GlowBox(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'PODSUMOWANIE',
                                  style: GoogleFonts.outfit(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 2,
                                    color: Colors.white60,
                                  ),
                                ),
                                const Icon(Icons.show_chart, color: luminousCyan, size: 16),
                              ],
                            ),
                            const SizedBox(height: 24),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _GlassStat(label: 'ILORAZ', value: '154'),
                                _GlassStat(label: 'KOSZT', value: '\$2.4K'),
                                _GlassStat(label: 'WARTOŚĆ', value: '\$3.2K', isGlow: true),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _notify(BuildContext context, String path) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.cyan[900],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Text('NAWIGACJA DO: $path', style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _GlassTile extends StatelessWidget {
  final String title;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _GlassTile({
    required this.title,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.cyan.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: const Color(0xFF22D3EE), size: 20),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    Text(
                      label,
                      style: GoogleFonts.outfit(fontSize: 12, color: Colors.white54),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.95, 0.95));
  }
}

class _GlowAvatar extends StatelessWidget {
  final VoidCallback onTap;

  const _GlowAvatar({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF22D3EE).withValues(alpha: 0.3),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
          border: Border.all(color: const Color(0xFF22D3EE), width: 1.5),
        ),
        child: const CircleAvatar(
          radius: 20,
          backgroundColor: Color(0xFF1E293B),
          child: Icon(Icons.person_outline, size: 20, color: Colors.white),
        ),
      ),
    );
  }
}

class _GlowBox extends StatelessWidget {
  final Widget child;

  const _GlowBox({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 1),
          ),
          child: child,
        ),
      ),
    ).animate().slideY(begin: 0.1, duration: 600.ms).fadeIn();
  }
}

class _GlassStat extends StatelessWidget {
  final String label;
  final String value;
  final bool isGlow;

  const _GlassStat({required this.label, required this.value, this.isGlow = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: Colors.white38,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            shadows: isGlow
                ? [
                    const Shadow(
                      color: Color(0xFF22D3EE),
                      blurRadius: 10,
                    ),
                  ]
                : [],
          ),
        ),
      ],
    );
  }
}

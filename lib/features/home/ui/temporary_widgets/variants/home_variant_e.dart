import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../features/profiles/presentation/ui/profile_screen.dart';

class HomeVariantEScreen extends StatelessWidget {
  const HomeVariantEScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const racingGreen = Color(0xFF004225);
    const vintageCream = Color(0xFFFDF5E6);
    const ochreYellow = Color(0xFFDAA520);

    return Theme(
      data: ThemeData(
        textTheme: GoogleFonts.playfairDisplayTextTheme().copyWith(
          bodyMedium: GoogleFonts.roboto(),
        ),
      ),
      child: Scaffold(
        backgroundColor: vintageCream,
        body: SafeArea(
          child: Stack(
            children: [
              // --- RETRO RACING STRIPE ---
              Positioned(
                left: 40,
                top: 0,
                bottom: 0,
                child: Row(
                  children: [
                    Container(width: 8, color: racingGreen.withValues(alpha: 0.1)),
                    const SizedBox(width: 4),
                    Container(width: 2, color: ochreYellow.withValues(alpha: 0.2)),
                  ],
                ),
              ),

              CustomScrollView(
                slivers: [
                  // --- CLASSIC HEADER ---
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(72, 40, 28, 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'A U T O W O R L D',
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  color: racingGreen,
                                  letterSpacing: 2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Dzień dobry,\nPanie Anatolu',
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                  fontStyle: FontStyle.italic,
                                  height: 1.1,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          _RetroAvatar(
                            onTap: () => Navigator.of(context).push<void>(
                              MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 600.ms).slideX(begin: 0.05),
                  ),

                  // --- RETRO MENU CARDS ---
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(72, 0, 28, 0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _RetroMenuItem(
                          title: 'Mój Garaż',
                          info: 'Ewidencja Kolekcji',
                          icon: Icons.directions_car_filled_outlined,
                          onTap: () => _retroAlert(context, 'GARAŻ'),
                          color: racingGreen,
                        ),
                        _RetroMenuItem(
                          title: 'Wydarzenia',
                          info: 'Nowości ze świata',
                          icon: Icons.event_note_outlined,
                          onTap: () => _retroAlert(context, 'Wydarzenia'),
                        ),
                        _RetroMenuItem(
                          title: 'Targowisko',
                          info: 'Giełda i wymiana',
                          icon: Icons.storefront_outlined,
                          onTap: () => _retroAlert(context, 'Targowisko'),
                        ),
                        _RetroMenuItem(
                          title: 'Ustawienia',
                          info: 'Preferencje kierowcy',
                          icon: Icons.tune_outlined,
                          onTap: () => _retroAlert(context, 'Ustawienia'),
                        ),
                      ]),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 60)),

                  // --- HERITAGE FOOTER ---
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(72, 0, 28, 40),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(4, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PODSUMOWANIE KOLEKCJI',
                              style: GoogleFonts.roboto(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                                color: racingGreen,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _RetroStat(label: 'ILORAZ', value: '154'),
                                _RetroStat(label: 'KOSZT', value: '\$2.4K'),
                                _RetroStat(label: 'WARTOŚĆ', value: '\$3.2K'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _retroAlert(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF004225),
        content: Text(
          'ROZPOCZĘTO PROCEDURĘ: $title',
          style: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
    );
  }
}

class _RetroMenuItem extends StatelessWidget {
  final String title;
  final String info;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  const _RetroMenuItem({
    required this.title,
    required this.info,
    required this.icon,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color?.withValues(alpha: 0.05) ?? Colors.transparent,
          border: Border.all(color: color?.withValues(alpha: 0.2) ?? Colors.black12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color ?? Colors.black54, size: 28),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  info,
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    color: Colors.black45,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RetroAvatar extends StatelessWidget {
  final VoidCallback onTap;

  const _RetroAvatar({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF004225), width: 1),
          shape: BoxShape.circle,
        ),
        child: const CircleAvatar(
          radius: 20,
          backgroundColor: Color(0xFF004225),
          child: Icon(Icons.person, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

class _RetroStat extends StatelessWidget {
  final String label;
  final String value;

  const _RetroStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: Colors.black45,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}

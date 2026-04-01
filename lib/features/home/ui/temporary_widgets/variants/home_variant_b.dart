import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../features/profiles/presentation/ui/profile_screen.dart';

class HomeVariantBScreen extends StatelessWidget {
  const HomeVariantBScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const racingGreen = Color(0xFF004225);
    const boneWhite = Color(0xFFF8F8F4);
    const charcoal = Color(0xFF121212);

    return Theme(
      data: ThemeData(
        textTheme: GoogleFonts.spaceGroteskTextTheme().copyWith(
          bodyMedium: GoogleFonts.inter(),
        ),
      ),
      child: Scaffold(
        backgroundColor: boneWhite,
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // --- MINIMALIST HEADER ---
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28, 40, 28, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AUTOWORLD164',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 4,
                              color: charcoal.withValues(alpha: 0.4),
                            ),
                          ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2),
                          const SizedBox(height: 8),
                          Text(
                            'Witaj w garażu,\nAnatol',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              height: 1.1,
                              color: charcoal,
                            ),
                          ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideX(begin: -0.1),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).push<void>(
                          MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
                        ),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            border: Border.all(color: charcoal.withValues(alpha: 0.1), width: 1),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(Icons.person_outline, size: 20, color: charcoal),
                          ),
                        ).animate().scale(delay: 200.ms),
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              // --- NAVIGATION LIST (EDITORIAL STYLE) ---
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _EditorialNavItem(
                      title: 'Mój garaż',
                      count: '154',
                      onTap: () => _showMsg(context, 'Garaż'),
                      accentColor: racingGreen,
                    ),
                    _EditorialNavItem(
                      title: 'Nowości',
                      count: '2',
                      onTap: () => _showMsg(context, 'Nowości'),
                    ),
                    _EditorialNavItem(
                      title: 'Marketplace',
                      onTap: () => _showMsg(context, 'Marketplace'),
                    ),
                    _EditorialNavItem(
                      title: 'Ustawienia',
                      onTap: () => _showMsg(context, 'Ustawienia'),
                    ),
                  ]),
                ),
              ),

              const SliverFillRemaining(
                hasScrollBody: false,
                child: Spacer(),
              ),

              // --- BOTTOM DASHBOARD (MINIMALIST) ---
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(28, 40, 28, 40),
                  child: Column(
                    children: [
                      Container(
                        height: 1,
                        color: charcoal.withValues(alpha: 0.1),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _SmallStat(label: 'GARAŻ', value: '154'),
                          _SmallStat(label: 'KUPIONE', value: '\$2,400'),
                          _SmallStat(label: 'WARTOŚĆ', value: '\$3,250', isUp: true),
                        ],
                      ).animate().fadeIn(delay: 400.ms),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMsg(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF121212),
        content: Text(
          'OTWIERANIE: $title',
          style: GoogleFonts.spaceGrotesk(fontSize: 12, letterSpacing: 1),
        ),
      ),
    );
  }
}

class _EditorialNavItem extends StatelessWidget {
  final String title;
  final String? count;
  final VoidCallback onTap;
  final Color? accentColor;

  const _EditorialNavItem({
    required this.title,
    this.count,
    required this.onTap,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.black.withValues(alpha: 0.05), width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (accentColor != null)
                  Container(
                    width: 4,
                    height: 24,
                    color: accentColor,
                    margin: const EdgeInsets.only(right: 12),
                  ),
                Text(
                  title.toUpperCase(),
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            if (count != null)
              Text(
                count!,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[500],
                ),
              )
            else
              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class _SmallStat extends StatelessWidget {
  final String label;
  final String value;
  final bool isUp;

  const _SmallStat({
    required this.label,
    required this.value,
    this.isUp = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            color: Colors.grey[400],
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              value,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (isUp)
              const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Icon(Icons.north_east, size: 14, color: Color(0xFF004225)),
              ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../features/profiles/presentation/ui/profile_screen.dart';

class HomeVariantCScreen extends StatelessWidget {
  const HomeVariantCScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const safetyOrange = Color(0xFFFF4D00);
    const asphaltGray = Color(0xFF2C2C2C);
    const steelBackground = Color(0xFFE5E5E5);

    return Theme(
      data: ThemeData(
        textTheme: GoogleFonts.jetBrainsMonoTextTheme(),
      ),
      child: Scaffold(
        backgroundColor: steelBackground,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- TACTICAL HEADER ---
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black, width: 3)),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SYSTEM: AUTOWORLD164',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: safetyOrange,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'WITAJ, ANATOL',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: asphaltGray,
                          ),
                        ),
                      ],
                    ),
                    _TacticalButton(
                      onTap: () => Navigator.of(context).push<void>(
                        MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
                      ),
                      icon: Icons.person_sharp,
                    ),
                  ],
                ),
              ),

              // --- GRID TILES (NEO-BRUTALISM) ---
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(24),
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  children: [
                    _NeoTile(
                      title: 'GARAŻ',
                      data: '154 UNITS',
                      icon: Icons.garage,
                      onTap: () => _alert(context, 'GARAGE'),
                      color: Colors.white,
                    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1),
                    _NeoTile(
                      title: 'NEWS',
                      data: '2 NEW',
                      icon: Icons.electrical_services_sharp,
                      onTap: () => _alert(context, 'NEWS'),
                      color: Colors.white,
                    ).animate().fadeIn(delay: 100.ms, duration: 300.ms).slideY(begin: 0.1),
                    _NeoTile(
                      title: 'MARKET',
                      data: 'ACTIVE',
                      icon: Icons.shopping_cart_sharp,
                      onTap: () => _alert(context, 'MARKET'),
                      color: Colors.white,
                    ).animate().fadeIn(delay: 200.ms, duration: 300.ms).slideY(begin: 0.1),
                    _NeoTile(
                      title: 'CONFIG',
                      data: 'V0.1-A',
                      icon: Icons.settings_input_component_sharp,
                      onTap: () => _alert(context, 'CONFIG'),
                      color: safetyOrange,
                      isDark: true,
                    ).animate().fadeIn(delay: 300.ms, duration: 300.ms).slideY(begin: 0.1),
                  ],
                ),
              ),

              // --- DATA FOOTER ---
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: asphaltGray,
                  border: Border(top: BorderSide(color: Colors.black, width: 3)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _StatusIndicator(label: 'CONNECTED', isActive: true),
                        _StatusIndicator(label: 'DB_SYNC', isActive: true),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _DataPoint(label: 'UNITS', value: '154'),
                        _DataPoint(label: 'INVEST', value: '2.4K'),
                        _DataPoint(label: 'VALUE', value: '3.2K', isWarning: true),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _alert(BuildContext context, String tag) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFFFF4D00),
        behavior: SnackBarBehavior.floating,
        content: Text(
          'ACCESSING: $tag...',
          style: GoogleFonts.jetBrainsMono(fontWeight: FontWeight.w900, color: Colors.white),
        ),
      ),
    );
  }
}

class _NeoTile extends StatelessWidget {
  final String title;
  final String data;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final bool isDark;

  const _NeoTile({
    required this.title,
    required this.data,
    required this.icon,
    required this.onTap,
    required this.color,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.black, width: 3),
          boxShadow: const [
            BoxShadow(color: Colors.black, offset: Offset(6, 6)),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: isDark ? Colors.white : Colors.black, size: 28),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.jetBrainsMono(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  data,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white.withValues(alpha: 0.7) : Colors.black.withValues(alpha: 0.5),
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

class _TacticalButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;

  const _TacticalButton({required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: const [
            BoxShadow(color: Colors.black, offset: Offset(3, 3)),
          ],
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  final String label;
  final bool isActive;

  const _StatusIndicator({required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? Colors.greenAccent : Colors.redAccent,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 8,
            color: Colors.white.withValues(alpha: 0.6),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _DataPoint extends StatelessWidget {
  final String label;
  final String value;
  final bool isWarning;

  const _DataPoint({required this.label, required this.value, this.isWarning = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 10,
            color: Colors.white.withValues(alpha: 0.5),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: isWarning ? const Color(0xFFFFB800) : Colors.white,
          ),
        ),
      ],
    );
  }
}

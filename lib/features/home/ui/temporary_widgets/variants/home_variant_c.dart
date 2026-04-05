import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../profiles/presentation/ui/profile_screen.dart';

class HomeVariantCScreen extends StatelessWidget {
  const HomeVariantCScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A), // Midnight Navy
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFE2B25A), // Soft Gold
          surface: Color(0xFF1E293B), // Slate Blue
        ),
      ),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topCenter,
              radius: 1.5,
              colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),
                  // Premium Profile Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'WIĘCEJ NIŻ KOLEKCJA',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 3,
                              color: Color(0xFFE2B25A),
                            ),
                          ),
                          Text(
                            'WITAJ, ANATOL',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Serif',
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ProfileScreen()),
                        ),
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundColor: Color(0xFFE2B25A),
                          child: Icon(Icons.person, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),

                  // Glassmorphism Stats Card
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _GalleryStat(label: 'KURACJA', value: '124'),
                            _GalleryStat(label: 'VALOR', value: '2.500 PLN'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Elegant Tile Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    children: [
                      _MuseumTile(
                        label: 'MÓJ GARAŻ',
                        icon: Icons.auto_awesome,
                        onTap: () {},
                      ),
                      _MuseumTile(
                        label: 'NOWOŚCI',
                        icon: Icons.new_releases_outlined,
                        onTap: () {},
                      ),
                      _MuseumTile(
                        label: 'HUNTING',
                        icon: Icons.explore_outlined,
                        onTap: () {},
                      ),
                      _MuseumTile(
                        label: 'USTAWIENIA',
                        icon: Icons.tune_outlined,
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.large(
          onPressed: () {},
          backgroundColor: const Color(0xFFE2B25A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: const Icon(Icons.add, color: Colors.black, size: 36),
        ),
      ),
    );
  }
}

class _GalleryStat extends StatelessWidget {
  final String label;
  final String value;

  const _GalleryStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.white38, letterSpacing: 2),
        ),
      ],
    );
  }
}

class _MuseumTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _MuseumTile({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.03),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kurator Garażu zaraz wyświetli te sekcję...')),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: const Color(0xFFE2B25A)),
              const SizedBox(height: 16),
              Text(
                label,
                style: const TextStyle(fontSize: 12, letterSpacing: 1.5, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

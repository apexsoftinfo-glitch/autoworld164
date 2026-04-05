import 'package:flutter/material.dart';
import '../../../../profiles/presentation/ui/profile_screen.dart';

class HomeVariantEScreen extends StatelessWidget {
  const HomeVariantEScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF1F5F9),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0EA5E9), // Cyan
          secondary: const Color(0xFFEC4899), // Pink
          tertiary: const Color(0xFF22C55E), // Green
        ),
      ),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Fun Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.black12, width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFFE2E8F0),
                        offset: Offset(0, 4),
                        blurRadius: 4,
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Witaj, Anatol!',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          Text(
                            'TWÓJ SUPER GARAŻ!',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0EA5E9),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ProfileScreen()),
                        ),
                        icon: const CircleAvatar(
                          radius: 20,
                          backgroundColor: Color(0xFFEC4899),
                          child: Icon(Icons.star, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Fun Stats Bubble
                const Row(
                  children: [
                    _BubbleStat(
                      label: 'AUTA',
                      value: '124',
                      color: Color(0xFF0EA5E9),
                    ),
                    SizedBox(width: 12),
                    _BubbleStat(
                      label: 'WARTOŚĆ',
                      value: '2500 zł',
                      color: Color(0xFF22C55E),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Playful Navigation Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _ToyTile(
                      label: 'MÓJ GARAŻ',
                      icon: Icons.palette,
                      color: const Color(0xFF0EA5E9),
                      onTap: () {},
                    ),
                    _ToyTile(
                      label: 'NOWOŚCI',
                      icon: Icons.celebration,
                      color: const Color(0xFFEC4899),
                      onTap: () {},
                    ),
                    _ToyTile(
                      label: 'HUNTING',
                      icon: Icons.military_tech,
                      color: const Color(0xFFF59E0B),
                      onTap: () {},
                    ),
                    _ToyTile(
                      label: 'USTAWIENIA',
                      icon: Icons.auto_awesome,
                      color: const Color(0xFF6366F1),
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 100), // Space for FAB
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          backgroundColor: const Color(0xFFEC4899),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          label: const Text(
            'DODAJ AUTO!',
            style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
          ),
          icon: const Icon(Icons.rocket_launch, color: Colors.white),
        ),
      ),
    );
  }
}

class _BubbleStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _BubbleStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.2), width: 2),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: color.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToyTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ToyTile({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Zabawa z sekcją $label startuje!')),
        ),
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.1),
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

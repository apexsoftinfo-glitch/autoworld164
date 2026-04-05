import 'package:flutter/material.dart';
import '../../../../profiles/presentation/ui/profile_screen.dart';

class HomeVariantBScreen extends StatelessWidget {
  const HomeVariantBScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF003399), // Hot Wheels Blue
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6600), // Hot Wheels Orange
          primary: const Color(0xFFFF6600),
          secondary: const Color(0xFFFFCC00), // Yellow
          brightness: Brightness.dark,
        ),
      ),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0044BB), Color(0xFF002277)],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Hot Wheels style Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'WITAJ W AKCJI!',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFCC00),
                              letterSpacing: 2,
                            ),
                          ),
                          Text(
                            'GARAŻ ANATOLA',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.italic,
                              color: Colors.white,
                              letterSpacing: -1,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
                        icon: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(color: Color(0xFFFF6600), shape: BoxShape.circle),
                          child: const CircleAvatar(radius: 20, backgroundColor: Colors.white, child: Icon(Icons.person, color: Color(0xFF003399))),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Power Stats Bar
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(12),
                      border: const Border(left: BorderSide(color: Color(0xFFFF6600), width: 6)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _HWStat(label: 'MODELE', value: '124'),
                        _HWStat(label: 'WARTOŚĆ', value: '2500 zł'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Navigation Grid with "Flame" accents
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _HWCard(label: 'MÓJ GARAŻ', icon: Icons.speed, color: const Color(0xFFFF6600)),
                      _HWCard(label: 'NOWOŚCI', icon: Icons.whatshot, color: const Color(0xFFFFCC00)),
                      _HWCard(label: 'HUNTING', icon: Icons.track_changes, color: Colors.white),
                      _HWCard(label: 'USTAWIENIA', icon: Icons.settings, color: Colors.white70),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: const Color(0xFFFFCC00),
          child: const Icon(Icons.add, color: Color(0xFF003399), size: 36),
        ),
      ),
    );
  }
}

class _HWStat extends StatelessWidget {
  final String label;
  final String value;
  const _HWStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white, fontStyle: FontStyle.italic)),
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white54)),
      ],
    );
  }
}

class _HWCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _HWCard({required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(
                label,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: color, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../profiles/presentation/ui/profile_screen.dart';

class HomeVariantCScreen extends StatelessWidget {
  const HomeVariantCScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF334155), // Slate
          primary: const Color(0xFF0F172A),
          surface: const Color(0xFFF8FAFC),
        ),
      ),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9).withValues(alpha: 0.5),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  // Modern Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('CENTRALNE POLECENIA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 3, color: Color(0xFF64748B))),
                          Text('OPERATOR: ANATOL', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300, color: Color(0xFF1E293B))),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
                        icon: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCBD5E1)), borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.person_outline, size: 24, color: Color(0xFF0F172A)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),

                  // Minimalist Stats Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: const [BoxShadow(color: Color(0xFFF1F5F9), offset: Offset(0, 4), blurRadius: 10)],
                    ),
                    padding: const EdgeInsets.all(24),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _ModernStat(label: 'UNITS', value: '124'),
                        _ModernStat(label: 'MARKET VALUE', value: '2.500 zł'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),

                  // High-tech Tile Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    children: [
                      _ModernCard(label: 'GARAŻ', icon: Icons.grid_view_rounded, subLabel: 'KOLEKCJA'),
                      _ModernCard(label: 'NOWOŚCI', icon: Icons.trending_up, subLabel: 'RYNEK'),
                      _ModernCard(label: 'HUNTING', icon: Icons.center_focus_strong, subLabel: 'ZDOBYCZ'),
                      _ModernCard(label: 'USTAWIENIA', icon: Icons.tune, subLabel: 'SYSTEM'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: const Color(0xFF0F172A),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}

class _ModernStat extends StatelessWidget {
  final String label;
  final String value;
  const _ModernStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 1.5)),
      ],
    );
  }
}

class _ModernCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final String subLabel;

  const _ModernCard({required this.label, required this.icon, required this.subLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE2E8F0))),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: const Color(0xFF0F172A)),
          const Spacer(),
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          Text(subLabel, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../profiles/presentation/ui/profile_screen.dart';

class HomeVariantBScreen extends StatelessWidget {
  const HomeVariantBScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE50914), // Racing Red
          brightness: Brightness.dark,
          secondary: const Color(0xFFFFD700), // Speed Yellow
        ),
      ),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF1A1A1A),
                const Color(0xFF121212).withValues(alpha: 0.9),
                const Color(0xFF0D0D0D),
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Header with Slanted/Dynamic Feel
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CZEŚĆ, ANATOL!',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                              color: const Color(0xFFFFD700),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'TWÓJ GARAŻ',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.italic,
                              color: Colors.white,
                              letterSpacing: -1,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ProfileScreen()),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFE50914), width: 2),
                          ),
                          child: const CircleAvatar(
                            radius: 24,
                            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=anatol'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Racing Summary Bar
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _RacingStat(label: 'MODELE', value: '124', color: const Color(0xFFFFD700)),
                        Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.1)),
                        const _RacingStat(label: 'WARTOŚĆ', value: '2.5K PLN', color: Color(0xFFE50914)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Carbon-style Navigation Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _SpeedCard(
                        title: 'MÓJ GARAŻ',
                        icon: Icons.directions_car,
                        accent: const Color(0xFFE50914),
                        onTap: () => _alert(context, 'Garaż'),
                      ),
                      _SpeedCard(
                        title: 'NOWOŚCI',
                        icon: Icons.bolt,
                        accent: const Color(0xFFFFD700),
                        onTap: () => _alert(context, 'Nowości'),
                      ),
                      _SpeedCard(
                        title: 'HUNTING',
                        icon: Icons.search,
                        accent: Colors.cyanAccent,
                        onTap: () => _alert(context, 'Hunting'),
                      ),
                      _SpeedCard(
                        title: 'USTAWIENIA',
                        icon: Icons.settings,
                        accent: Colors.white54,
                        onTap: () => _alert(context, 'Ustawienia'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _alert(context, 'Dodaj model'),
          backgroundColor: const Color(0xFFE50914),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.add, color: Colors.white, size: 32),
        ),
      ),
    );
  }

  void _alert(BuildContext context, String screen) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Szybki start: $screen')),
    );
  }
}

class _RacingStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _RacingStat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: color, fontStyle: FontStyle.italic),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white54, letterSpacing: 1),
        ),
      ],
    );
  }
}

class _SpeedCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  const _SpeedCard({required this.title, required this.icon, required this.accent, required this.onTap});

  @override
  State<_SpeedCard> createState() => _SpeedCardState();
}

class _SpeedCardState extends State<_SpeedCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
            border: Border.all(color: widget.accent.withValues(alpha: _isPressed ? 0.8 : 0.2), width: 1.5),
            boxShadow: [
              if (_isPressed)
                BoxShadow(color: widget.accent.withValues(alpha: 0.3), blurRadius: 12, spreadRadius: 2),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, size: 44, color: widget.accent),
              const SizedBox(height: 12),
              Text(
                widget.title,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

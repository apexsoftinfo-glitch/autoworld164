import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../profiles/presentation/ui/profile_screen.dart';

class HomeVariantDScreen extends StatelessWidget {
  const HomeVariantDScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0C0C0C),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFFD700), // Gold
          secondary: Color(0xFFFF9800), // Amber
          surface: Colors.black54,
        ),
      ),
      child: Scaffold(
        body: Stack(
          children: [
            // Warmer Background Image (Warm lighting diecast collection)
            Positioned.fill(
              child: Image.network(
                'https://images.unsplash.com/photo-1594736797933-d0501ba2fe65?q=80&w=2680&auto=format&fit=crop',
                fit: BoxFit.cover,
                color: const Color(0xFF2D1B0D).withValues(alpha: 0.6), // Warm Amber Overlay
                colorBlendMode: BlendMode.darken,
              ),
            ),
            
            // Premium VIP Content
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    // High-end Profile Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'VIP SHOWROOM', 
                              style: TextStyle(
                                fontSize: 10, 
                                fontWeight: FontWeight.w900, 
                                letterSpacing: 5, 
                                color: Color(0xFFFFD700),
                              ),
                            ),
                            Text(
                              'GARAŻ ANATOLA', 
                              style: TextStyle(
                                fontSize: 26, 
                                fontWeight: FontWeight.w200, 
                                letterSpacing: -1,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFFFFD700).withValues(alpha: 0.5), width: 1),
                              boxShadow: const [BoxShadow(color: Color(0x33FFD700), blurRadius: 10)],
                            ),
                            child: const CircleAvatar(
                              radius: 20, 
                              backgroundColor: Colors.black26, 
                              child: Icon(Icons.person, color: Color(0xFFFFD700)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),

                    // Golden Amber Stats Card (Translucent)
                    _GlassBox(
                      padding: const EdgeInsets.all(28),
                      borderColor: const Color(0xFFFFD700).withValues(alpha: 0.2),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _VIPStat(label: 'PIECES', value: '124'),
                          _VIPStat(label: 'EST. VALUE', value: '2.5K PLN'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Prestigious Navigation Grid
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _VIPCard(label: 'MY GARAGE', icon: Icons.auto_awesome, color: const Color(0xFFFFD700)),
                        _VIPCard(label: 'UPDATES', icon: Icons.trending_up, color: Colors.white70),
                        _VIPCard(label: 'HOT HUNT', icon: Icons.explore, color: Colors.white70),
                        _VIPCard(label: 'SYSTEM', icon: Icons.tune, color: Colors.white30),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: const Color(0xFFFFD700),
          child: const Icon(Icons.add, color: Colors.black, size: 32),
        ),
      ),
    );
  }
}

class _GlassBox extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color? borderColor;
  const _GlassBox({required this.child, required this.padding, this.borderColor});

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
            border: Border.all(color: borderColor ?? Colors.white.withValues(alpha: 0.1)),
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
      children: [
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFFFD700), letterSpacing: 1)),
        Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.white38, letterSpacing: 3)),
      ],
    );
  }
}

class _VIPCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _VIPCard({required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return _GlassBox(
      padding: const EdgeInsets.all(0),
      child: InkWell(
        onTap: () {},
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

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
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFF1F5F9), // White/Silver
          secondary: Color(0xFF94A3B8), // Slate
        ),
      ),
      child: Scaffold(
        body: Stack(
          children: [
            // Background Image (1/64 Collection vibe)
            Positioned.fill(
              child: Image.network(
                'https://images.unsplash.com/photo-1581235720704-06d3acfcb36f?q=80&w=2680&auto=format&fit=crop',
                fit: BoxFit.cover,
                color: Colors.black45,
                colorBlendMode: BlendMode.darken,
              ),
            ),
            
            // Glassmorphism Overlay
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    // VIP Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('PRIVATE COLLECTION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 4, color: Colors.white70)),
                            Text('ANATOL K.', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, fontFamily: 'Serif', color: Colors.white)),
                          ],
                        ),
                        IconButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
                          icon: const CircleAvatar(radius: 20, backgroundColor: Colors.white12, child: Icon(Icons.person, color: Colors.white)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),

                    // Translucent Stats Card
                    _GlassBox(
                      padding: const EdgeInsets.all(24),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _VIPStat(label: 'PIECES', value: '124'),
                          _VIPStat(label: 'EST. VALUE', value: '2.5K PLN'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),

                    // VIP Transparent Grid
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _VIPCard(label: 'MY GARAGE', icon: Icons.auto_awesome, onTap: () {}),
                        _VIPCard(label: 'LATEST', icon: Icons.trending_up, onTap: () {}),
                        _VIPCard(label: 'HUNTING', icon: Icons.explore, onTap: () {}),
                        _VIPCard(label: 'PROFILE', icon: Icons.manage_accounts, onTap: () {}),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassBox extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const _GlassBox({required this.child, required this.padding});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
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
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1)),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.white60, letterSpacing: 2)),
      ],
    );
  }
}

class _VIPCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _VIPCard({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _GlassBox(
      padding: const EdgeInsets.all(0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: Colors.white70),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.5, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

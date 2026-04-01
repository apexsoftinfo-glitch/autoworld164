import 'package:flutter/material.dart';

import '../../../../../features/profiles/presentation/ui/profile_screen.dart';

class HomeVariantAScreen extends StatelessWidget {
  const HomeVariantAScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER SECTION ---
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AutoWorld164',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Witaj w garażu, Anatol!',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push<void>(
                      MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
                    ),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey[300],
                      child: Icon(Icons.person_outline, color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
            ),

            // --- MAIN NAVIGATION GRID ---
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _NavTile(
                    title: 'Mój garaż',
                    subtitle: '154 modele',
                    icon: Icons.garage_outlined,
                    onTap: () => _showPlaceholder(context, 'Mój garaż'),
                    isPrimary: true,
                  ),
                  _NavTile(
                    title: 'Nowości',
                    subtitle: '2 nowe artykuły',
                    icon: Icons.newspaper_outlined,
                    onTap: () => _showPlaceholder(context, 'Nowości'),
                  ),
                  _NavTile(
                    title: 'Marketplace',
                    subtitle: 'Aktualne oferty',
                    icon: Icons.shopping_bag_outlined,
                    onTap: () => _showPlaceholder(context, 'Marketplace'),
                  ),
                  _NavTile(
                    title: 'Ustawienia',
                    subtitle: 'Konto, Pref.',
                    icon: Icons.settings_outlined,
                    onTap: () => _showPlaceholder(context, 'Ustawienia'),
                  ),
                ],
              ),
            ),

            // --- STATISTICS DASHBOARD (BOTTOM) ---
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'STATYSTYKI GARAŻU',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              letterSpacing: 1.2,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '+ \$850',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _StatItem(label: 'W GARAŻU', value: '154'),
                      _StatItem(label: 'KUPIONE ZA', value: '\$2,400'),
                      _StatItem(label: 'WARTOŚĆ TERAZ', value: '\$3,250'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPlaceholder(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Przejście do: $title (Placeholder)')),
    );
  }
}

class _NavTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  const _NavTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isPrimary ? Colors.grey[300] : Colors.grey[200],
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, size: 32, color: Colors.grey[800]),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
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

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[500],
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

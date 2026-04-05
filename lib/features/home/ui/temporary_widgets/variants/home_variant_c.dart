import 'package:flutter/material.dart';
import '../../../../profiles/presentation/ui/profile_screen.dart';

class HomeVariantCScreen extends StatelessWidget {
  const HomeVariantCScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('AW164 HUB'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Top Value Card (The "Financial Focus")
            const _FinancialCard(),
            const SizedBox(height: 24),

            // Navigation Grid (Small, clean tiles)
            const Row(
              children: [
                Expanded(child: _SmallActionCard(label: 'Mój garaż', icon: Icons.collections, color: Colors.grey)),
                SizedBox(width: 12),
                Expanded(child: _SmallActionCard(label: 'Nowości', icon: Icons.new_releases, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                Expanded(child: _SmallActionCard(label: 'Hunting', icon: Icons.ads_click, color: Colors.grey)),
                SizedBox(width: 12),
                Expanded(child: _SmallActionCard(label: 'Ustawienia', icon: Icons.tune, color: Colors.grey)),
              ],
            ),

            const SizedBox(height: 24),

            // Top Brands List (Another stats-like component)
            const Text(
              'Statystyki marek',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const _BrandStatItem(label: 'Hot Wheels', count: 85, color: Colors.grey),
            const _BrandStatItem(label: 'Majorette', count: 52, color: Colors.grey),
            const _BrandStatItem(label: 'Matchbox', count: 12, color: Colors.grey),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}

class _FinancialCard extends StatelessWidget {
  const _FinancialCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'ŁĄCZNA WARTOŚĆ',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '12 450,00 zł',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Divider(height: 32),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatMiniItem(label: 'Modele', value: '149'),
              _StatMiniItem(label: 'Wydano (mc)', value: '349 zł'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatMiniItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatMiniItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}

class _SmallActionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _SmallActionCard({required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _BrandStatItem extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _BrandStatItem({required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: LinearProgressIndicator(
        value: count / 100,
        backgroundColor: Colors.grey[200],
        valueColor: AlwaysStoppedAnimation<Color>(color),
        minHeight: 12,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}

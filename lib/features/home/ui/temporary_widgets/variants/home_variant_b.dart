import 'package:flutter/material.dart';
import '../../../../profiles/presentation/ui/profile_screen.dart';

class HomeVariantBScreen extends StatelessWidget {
  const HomeVariantBScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'AW164',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                      ),
                    ),
                    IconButton(
                      icon: const CircleAvatar(
                        radius: 18,
                        child: Icon(Icons.person, size: 20),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProfileScreen()),
                      ),
                    ),
                  ],
                ),
              ),

              // Horizontal Navigation Hub
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    _NavIcon(
                      label: 'Garaż',
                      icon: Icons.directions_car,
                      onTap: () {},
                    ),
                    _NavIcon(
                      label: 'Nowości',
                      icon: Icons.newspaper,
                      onTap: () {},
                    ),
                    _NavIcon(
                      label: 'Hunting',
                      icon: Icons.search,
                      onTap: () {},
                    ),
                    _NavIcon(
                      label: 'Ustawienia',
                      icon: Icons.settings,
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Recently Added Section (The "Immediate feedback" part)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Ostatnio dodane',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Zobacz wszystko'),
                    ),
                  ],
                ),
              ),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: ListTile(
                      leading: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.image, color: Colors.grey),
                      ),
                      title: Text('Model Auta #${index + 1}'),
                      subtitle: const Text('Hot Wheels • 2023'),
                      trailing: const Text(
                        '15 PLN',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: Colors.grey[800],
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Dodaj auto', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _NavIcon({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.grey[200],
            child: Icon(icon, color: Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

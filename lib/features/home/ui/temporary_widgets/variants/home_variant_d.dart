import 'package:flutter/material.dart';
import '../../../../profiles/presentation/ui/profile_screen.dart';

class HomeVariantDScreen extends StatelessWidget {
  const HomeVariantDScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF262626),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF6B00), // Safety Orange
          surface: Color(0xFF333333),
          onSurface: Color(0xFFE5E5E5),
        ),
      ),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            border: Border.fromBorderSide(BorderSide(color: Color(0xFFFF6B00), width: 2)),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Industrial Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'GARAGE ID: 0164-X',
                            style: TextStyle(
                              fontSize: 10,
                              fontFamily: 'Courier',
                              color: Color(0xFFFF6B00),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'OPERATOR: ANATOL',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Courier',
                              letterSpacing: -1,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        iconSize: 40,
                        icon: const Icon(Icons.settings_input_component, color: Color(0xFFFF6B00)),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ProfileScreen()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Bolt-style Stats Bar
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          _IndustrialStat(label: 'UNITS', value: '124'),
                          const VerticalDivider(color: Colors.white12, width: 1),
                          _IndustrialStat(label: 'ASSET VALUE', value: '2500 PLN'),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Stencil-style Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    children: [
                      _IndustrialTile(
                        label: 'GARAŻ',
                        icon: Icons.inventory_2,
                        number: '01',
                        onTap: () {},
                      ),
                      _IndustrialTile(
                        label: 'NOWOŚCI',
                        icon: Icons.event,
                        number: '02',
                        onTap: () {},
                      ),
                      _IndustrialTile(
                        label: 'HUNTING',
                        icon: Icons.troubleshoot,
                        number: '03',
                        onTap: () {},
                      ),
                      _IndustrialTile(
                        label: 'USTAWIENIA',
                        icon: Icons.construction,
                        number: '04',
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: const Color(0xFFFF6B00),
          shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
          child: const Icon(Icons.add_shopping_cart, color: Colors.black, size: 30),
        ),
      ),
    );
  }
}

class _IndustrialStat extends StatelessWidget {
  final String label;
  final String value;

  const _IndustrialStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, fontFamily: 'Courier')),
            Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontFamily: 'Courier')),
          ],
        ),
      ),
    );
  }
}

class _IndustrialTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final String number;
  final VoidCallback onTap;

  const _IndustrialTile({required this.label, required this.icon, required this.number, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.05),
      child: InkWell(
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Operacja $label w toku...'))),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(border: Border.all(color: Colors.white10)),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Text(number, style: const TextStyle(fontSize: 10, color: Color(0xFFFF6B00), fontWeight: FontWeight.bold)),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 40, color: Colors.grey),
                    const SizedBox(height: 12),
                    Text(
                      label,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Courier', letterSpacing: 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

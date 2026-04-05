import 'package:flutter/material.dart';

import 'variants/home_variant_a.dart';
import 'variants/home_variant_b.dart';
import 'variants/home_variant_c.dart';
import 'variants/home_variant_d.dart';
import 'variants/home_variant_e.dart';
import 'home_variant_switcher.dart';

const _homeVariantLabels = ['A', 'B', 'C', 'D', 'E'];

class HomePreviewShell extends StatefulWidget {
  const HomePreviewShell({super.key});

  @override
  State<HomePreviewShell> createState() => _HomePreviewShellState();
}

class _HomePreviewShellState extends State<HomePreviewShell> {
  int _selectedVariant = 0;

  @override
  Widget build(BuildContext context) {
    final variants = [
      HomeVariantAScreen(),
      HomeVariantBScreen(),
      HomeVariantCScreen(),
      HomeVariantDScreen(),
      HomeVariantEScreen(),
    ];

    return Column(
      children: [
        Expanded(child: variants[_selectedVariant]),
        HomeVariantSwitcher(
          labels: _homeVariantLabels,
          selectedVariant: _selectedVariant,
          onVariantSelected: (variant) {
            setState(() {
              _selectedVariant = variant;
            });
          },
        ),
      ],
    );
  }
}

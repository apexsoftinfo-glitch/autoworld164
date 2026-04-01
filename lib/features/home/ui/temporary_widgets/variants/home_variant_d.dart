import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../app/developer/ui/developer_screen.dart';
import '../../../../../features/profiles/presentation/ui/profile_screen.dart';
import '../../../../../l10n/l10n.dart';

class HomeVariantDScreen extends StatelessWidget {
  const HomeVariantDScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Variant',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Colors.black.withValues(alpha: 0.52),
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'D',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.person_outline),
            label: Text("Profil użytkownika"),
            onPressed: () => Navigator.of(context).push<void>(
              MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
            ),
          ),
          if (kDebugMode) ...[
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => const DeveloperScreen(),
                  ),
                ),
                icon: const Icon(Icons.developer_mode),
                label: Text(context.l10n.developerToolsTitle),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'temporary_widgets/home_preview_shell.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: HomePreviewShell()));
  }
}

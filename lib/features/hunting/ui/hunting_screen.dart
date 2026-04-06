import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/di/injection.dart';
import '../data/repositories/hunting_repository.dart';
import '../presentation/cubit/hunting_cubit.dart';

class HuntingScreen extends StatelessWidget {
  const HuntingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HuntingCubit>(),
      child: const _HuntingView(),
    );
  }
}

class _HuntingView extends StatefulWidget {
  const _HuntingView();

  @override
  State<_HuntingView> createState() => _HuntingViewState();
}

class _HuntingViewState extends State<_HuntingView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nie można otworzyć linku')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'HOT HUNT',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 5,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/warm_garage.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.black.withValues(alpha: 0.6),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: _SearchField(
                    controller: _searchController,
                    onSearch: (val) => context.read<HuntingCubit>().search(val),
                  ),
                ),
                Expanded(
                  child: BlocBuilder<HuntingCubit, HuntingState>(
                    builder: (context, state) {
                      return switch (state) {
                        Initial() => const _HuntingInitial(),
                        Loading() => const Center(
                            child: CircularProgressIndicator(color: Color(0xFFFFD700)),
                          ),
                        Error(errorKey: final _) => const Center(
                            child: Text(
                              'Wystąpił błąd podczas wyszukiwania',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        Data(results: final results, query: final _) =>
                          _HuntingResults(
                            results: results,
                            onLaunch: _launchUrl,
                          ),
                      };
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSearch;

  const _SearchField({required this.controller, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: 'Wpisz model (np. Supra RLC)',
          hintStyle: const TextStyle(color: Colors.white38),
          prefixIcon: const Icon(Icons.search, color: Color(0xFFFFD700)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          suffixIcon: IconButton(
            icon: const Icon(Icons.send, color: Color(0xFFFFD700)),
            onPressed: () => onSearch(controller.text),
          ),
        ),
        onSubmitted: onSearch,
      ),
    );
  }
}

class _HuntingInitial extends StatelessWidget {
  const _HuntingInitial();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.explore_outlined, size: 64, color: Colors.white12),
          SizedBox(height: 16),
          Text(
            'ZNAJDŹ SWÓJ WYMARZONY MODEL',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Przeszukaj najpopularniejsze platformy w poszukiwaniu okazji i promocji.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white24, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _HuntingResults extends StatelessWidget {
  final List<HuntingResult> results;
  final Function(String) onLaunch;

  const _HuntingResults({required this.results, required this.onLaunch});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        return _HuntSourceCard(result: result, onLaunch: onLaunch);
      },
    );
  }
}

class _HuntSourceCard extends StatelessWidget {
  final HuntingResult result;
  final Function(String) onLaunch;

  const _HuntSourceCard({required this.result, required this.onLaunch});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Icon(Icons.storefront, color: Color(0xFFFFD700), size: 24),
                const SizedBox(width: 12),
                Text(
                  result.shopName.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 14),
              ],
            ),
          ),
          const Divider(color: Colors.white12, height: 1),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: _ActionBtn(
                    label: 'SZUKAJ',
                    icon: Icons.search,
                    onTap: () => onLaunch(result.searchUrl),
                    isPrimary: true,
                  ),
                ),
                if (result.promoQuery != null) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionBtn(
                      label: 'PROMOCJE',
                      icon: Icons.local_offer_outlined,
                      onTap: () => onLaunch(result.promoQuery!),
                      isPrimary: false,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  const _ActionBtn({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFFFFD700) : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: isPrimary ? null : Border.all(color: Colors.white12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon, 
              size: 16, 
              color: isPrimary ? Colors.black : const Color(0xFFFFD700),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isPrimary ? Colors.black : Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 11,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

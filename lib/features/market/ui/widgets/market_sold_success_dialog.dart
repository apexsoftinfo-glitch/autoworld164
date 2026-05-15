import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../l10n/l10n.dart';

class MarketSoldSuccessDialog extends StatefulWidget {
  const MarketSoldSuccessDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const MarketSoldSuccessDialog(),
    );
  }

  @override
  State<MarketSoldSuccessDialog> createState() => _MarketSoldSuccessDialogState();
}

class _MarketSoldSuccessDialogState extends State<MarketSoldSuccessDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _burstAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _burstAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.7, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.8, curve: Curves.elasticOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF1A120B).withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.greenAccent.withValues(alpha: 0.1),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animation area
              SizedBox(
                height: 150,
                width: 150,
                child: AnimatedBuilder(
                  animation: _burstAnimation,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Burst particles (simulated)
                        ...List.generate(8, (index) {
                          final angle = (index * 45) * 3.14159 / 180;
                          return Opacity(
                            opacity: (1.0 - _burstAnimation.value).clamp(0.0, 1.0),
                            child: Transform.translate(
                              offset: Offset(
                                60 * _burstAnimation.value * (index % 2 == 0 ? 1 : 0.7) * (angle > 0 ? 1 : -1), // simplified
                                60 * _burstAnimation.value * (index % 2 == 0 ? 0.7 : 1) * (angle > 0 ? 1 : -1), // simplified
                              ),
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle),
                              ),
                            ),
                          );
                        }),
                        // Main Success Icon
                        Transform.scale(
                          scale: _burstAnimation.value,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.greenAccent.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.greenAccent, width: 3),
                            ),
                            child: const Icon(Icons.check_circle_outline, color: Colors.greenAccent, size: 48),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              // Text Content
              FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    children: [
                      Text(
                        l10n.marketSoldSuccessTitle.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.marketSoldSuccessMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // OK Button
              FadeTransition(
                opacity: _fadeAnimation,
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(l10n.okButtonLabel.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

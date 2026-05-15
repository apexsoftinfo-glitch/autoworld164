import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../l10n/l10n.dart';
import '../../../garage/models/car_model.dart';
import '../../../garage/ui/widgets/car_photo.dart';

class GarageMoveSuccessDialog extends StatefulWidget {
  final CarModel car;

  const GarageMoveSuccessDialog({required this.car, super.key});

  static Future<void> show(BuildContext context, CarModel car) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => GarageMoveSuccessDialog(car: car),
    );
  }

  @override
  State<GarageMoveSuccessDialog> createState() => _GarageMoveSuccessDialogState();
}

class _GarageMoveSuccessDialogState extends State<GarageMoveSuccessDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _carMoveAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _carMoveAnimation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOutBack),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 0.8, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 0.9, curve: Curves.elasticOut),
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
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF1A120B).withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: const Color(0xFFFFD700).withValues(alpha: 0.2)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animation area
              SizedBox(
                height: 120,
                width: double.infinity,
                child: AnimatedBuilder(
                  animation: _carMoveAnimation,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Track
                        Container(
                          height: 4,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white10,
                                const Color(0xFFFFD700).withValues(alpha: 0.3),
                                Colors.white10,
                              ],
                            ),
                          ),
                        ),
                        // Garage Icon (Left)
                        const Positioned(
                          left: 0,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.garage, color: Colors.white24, size: 32),
                              SizedBox(height: 4),
                              Text('GARAGE', style: TextStyle(color: Colors.white24, fontSize: 8, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        // Market Icon (Right)
                        const Positioned(
                          right: 0,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.storefront, color: Color(0xFFFFD700), size: 32),
                              SizedBox(height: 4),
                              Text('MARKET', style: TextStyle(color: Color(0xFFFFD700), fontSize: 8, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        // Moving Car
                        Align(
                          alignment: Alignment(_carMoveAnimation.value, 0),
                          child: Container(
                            width: 60,
                            height: 60,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFFFFD700), width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFFD700).withValues(alpha: 0.3),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: widget.car.displayPhotoPath != null
                                  ? CarPhoto(path: widget.car.displayPhotoPath!, fit: BoxFit.cover)
                                  : const Icon(Icons.directions_car, color: Color(0xFFFFD700)),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
              // Text Content
              FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    children: [
                      Text(
                        l10n.marketMoveSuccessTitle.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFFFFD700),
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.marketMoveSuccessMessage,
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
              // Close Button
              FadeTransition(
                opacity: _fadeAnimation,
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD700),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(l10n.closeButtonLabel.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5)),
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

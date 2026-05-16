import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/car_model.dart';
import '../ui/widgets/garage_card_poster.dart';

class GarageCardPngGenerator {
  static Future<void> generateAndShare(
    BuildContext context,
    CarModel car, {
    String? garageName,
    required bool isPolish,
  }) async {
    // 1. Prepare overlay for capture
    final overlayState = Overlay.of(context);
    final captureKey = GlobalKey();

    try {
      // Step 1: Pre-load images
      final allPaths = car.allPhotoPaths;
      ui.Image? mainImg;
      final List<ui.Image> galleryImgs = [];

      if (allPaths.isNotEmpty) {
        mainImg = await loadUiImage(allPaths.first, targetWidth: 800);
        if (allPaths.length > 1) {
          for (final path in allPaths.sublist(1)) {
            final img = await loadUiImage(path, targetWidth: 300);
            if (img != null) galleryImgs.add(img);
          }
        }
      }

      // Step 2: Render off-screen using Overlay
      late OverlayEntry entry;
      entry = OverlayEntry(
        builder: (context) => Positioned(
          left: -9999,
          top: -9999,
          child: RepaintBoundary(
            key: captureKey,
            child: MediaQuery(
              data: const MediaQueryData(size: Size(800, 1200)),
              child: GarageCardPoster(
                car: car,
                garageName: garageName,
                isPolish: isPolish,
                mainImage: mainImg,
                galleryImages: galleryImgs,
              ),
            ),
          ),
        ),
      );

      overlayState.insert(entry);
      
      // Wait for a few frames to ensure layout and rendering
      await Future.delayed(const Duration(milliseconds: 100));

      // Step 3: Capture the RepaintBoundary
      final boundary = captureKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) throw Exception('Capture boundary not found');

      final image = await boundary.toImage(pixelRatio: 2.0); // 2.0 for higher quality
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      entry.remove();

      if (byteData == null) throw Exception('Failed to get byte data');

      // Dispose ui.Images
      mainImg?.dispose();
      for (final img in galleryImgs) {
        img.dispose();
      }

      // Step 4: Save to temp and share
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/autoworld_${car.brand}_${car.modelName}.png');
      await file.writeAsBytes(byteData.buffer.asUint8List());

      // ignore: deprecated_member_use
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: '${car.brand} ${car.modelName}',
      );
    } catch (e) {
      debugPrint('GarageCardPngGenerator error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error generating PNG')),
        );
      }
    }
  }
}

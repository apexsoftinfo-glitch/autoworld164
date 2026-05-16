import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/car_model.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/config/app_config.dart';

/// Resolves a photo path to an absolute file path or http URL.
Future<String?> resolvePhotoPath(String path) async {
  if (path.startsWith('http')) return path;
  
  if (path.contains('/')) {
    // Legacy Supabase storage path: try local first
    final fileName = p.basename(path);
    final localCheck = p.join(AppConfig.docsPath, 'autoworld_photos', fileName);
    if (File(localCheck).existsSync()) {
      return localCheck;
    }
    final supabase = getIt<SupabaseClient>();
    return supabase.storage.from('autoworld_photos').getPublicUrl(path);
  }

  // Local file in documents directory
  final localPath = p.join(AppConfig.docsPath, 'autoworld_photos', path);
  if (File(localPath).existsSync()) {
    return localPath;
  }
  
  // Fallback to legacy market photos folder
  final legacyPath = p.join(AppConfig.docsPath, 'autoworld_market_photos', path);
  if (File(legacyPath).existsSync()) {
    return legacyPath;
  }

  return null;
}

/// Loads and decodes image to dart:ui.Image for synchronous off-screen rendering.
Future<ui.Image?> loadUiImage(String path, {int? targetWidth, int? targetHeight}) async {
  try {
    final resolved = await resolvePhotoPath(path);
    if (resolved == null) return null;

    Uint8List bytes;
    if (resolved.startsWith('http')) {
      final httpClient = HttpClient();
      final request = await httpClient.getUrl(Uri.parse(resolved));
      final response = await request.close();
      final chunks = <int>[];
      await for (final chunk in response) {
        chunks.addAll(chunk);
      }
      httpClient.close();
      bytes = Uint8List.fromList(chunks);
    } else {
      final file = File(resolved);
      if (!await file.exists()) return null;
      bytes = await file.readAsBytes();
    }

    final codec = await ui.instantiateImageCodec(
      bytes, 
      targetWidth: targetWidth, 
      targetHeight: targetHeight
    );
    final frame = await codec.getNextFrame();
    return frame.image;
  } catch (e) {
    debugPrint('loadUiImage error for $path: $e');
    return null;
  }
}

class GarageCardPoster extends StatelessWidget {
  final CarModel car;
  final String? garageName;
  final bool isPolish;
  final ui.Image? mainImage;
  final List<ui.Image> galleryImages;

  const GarageCardPoster({
    super.key,
    required this.car,
    this.garageName,
    required this.isPolish,
    this.mainImage,
    required this.galleryImages,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.simpleCurrency(
      locale: isPolish ? 'pl_PL' : 'en_US',
      name: isPolish ? 'PLN' : 'USD',
      decimalDigits: 0,
    );

    return DefaultTextStyle(
      style: const TextStyle(
        decoration: TextDecoration.none,
        color: Colors.white,
        fontFamily: 'sans-serif',
      ),
      child: Container(
        width: 800,
        height: 1200,
        decoration: const BoxDecoration(
          color: Color(0xFF1A120B),
        ),
        child: Stack(
          children: [
            // Background design elements
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFFFD700).withValues(alpha: 0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (garageName ?? 'AUTOWORLD164').toUpperCase(),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 4,
                              color: Color(0xFFFFD700),
                            ),
                          ),
                          Text(
                            isPolish ? 'KOLEKCJA MODELI 1/64' : '1/64 SCALE COLLECTION',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 2,
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFFFD700), width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '1/64',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFFFD700),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 60),

                  // Main Photo Container
                  Container(
                    width: double.infinity,
                    height: 450,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: mainImage != null
                          ? RawImage(image: mainImage!, fit: BoxFit.cover)
                          : Container(
                              color: Colors.white.withValues(alpha: 0.05),
                              child: const Icon(Icons.directions_car, color: Colors.white10, size: 100),
                            ),
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Car Info
                  if (car.toyMaker != null)
                    Text(
                      car.toyMaker!.toUpperCase(),
                      style: const TextStyle(
                        color: Color(0xFFFFD700),
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 3,
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    '${car.brand} ${car.modelName}',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  
                  const SizedBox(height: 32),

                  // Details Grid
                  Row(
                    children: [
                      _buildInfoTile(
                        isPolish ? 'STAN' : 'CONDITION',
                        _getLocalizedStatus(car.status, isPolish).toUpperCase(),
                      ),
                      const SizedBox(width: 24),
                      _buildInfoTile(
                        isPolish ? 'SERIA' : 'SERIES',
                        (car.series ?? '—').toUpperCase(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      _buildInfoTile(
                        isPolish ? 'WARTOŚĆ' : 'VALUE',
                        currencyFormat.format(car.purchasePrice),
                        highlight: true,
                      ),
                      const SizedBox(width: 24),
                      _buildInfoTile(
                        isPolish ? 'DATA' : 'DATE',
                        car.purchaseDate != null 
                            ? DateFormat('dd.MM.yyyy').format(car.purchaseDate!)
                            : '—',
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Gallery
                  if (galleryImages.isNotEmpty) ...[
                    Text(
                      isPolish ? 'GALERIA' : 'GALLERY',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 100,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: galleryImages.length,
                        separatorBuilder: (_, index) => const SizedBox(width: 16),
                        itemBuilder: (context, index) => Container(
                          width: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: RawImage(image: galleryImages[index], fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 48),

                  // Footer
                  Center(
                    child: Text(
                      'GENERATED BY AUTOWORLD164 APP',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, {bool highlight = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: highlight ? const Color(0xFFFFD700) : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLocalizedStatus(String status, bool isPolish) {
    if (isPolish) return status;
    return switch (status) {
      'Nowy' => 'New',
      'Idealny' => 'Mint',
      'Dobry' => 'Good',
      'Lekko uszkodzony' => 'Fair',
      'Uszkodzony' => 'Poor',
      'Luzak (bez opakowania)' => 'Loose (no box)',
      'Inne' => 'Other',
      _ => status,
    };
  }
}

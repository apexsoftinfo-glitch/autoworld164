import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/market_car_model.dart';
import '../../../../core/di/injection.dart';

/// Resolves a photo path to an absolute file path or http URL,
/// following the same logic as CarPhoto widget.
Future<String?> resolvePhotoPath(String path, String folderName) async {
  if (path.startsWith('http')) return path;
  if (path.contains('/')) {
    // Legacy Supabase storage path
    final supabase = getIt<SupabaseClient>();
    return supabase.storage.from('autoworld_photos').getPublicUrl(path);
  }
  // Local file in documents directory
  final docs = await getApplicationDocumentsDirectory();
  return p.join(docs.path, folderName, path);
}

/// Loads and decodes image to dart:ui.Image for synchronous off-screen rendering.
Future<ui.Image?> loadUiImage(String path, {String folderName = 'autoworld_market_photos'}) async {
  try {
    final resolved = await resolvePhotoPath(path, folderName);
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
      if (!await file.exists()) {
        debugPrint('loadUiImage: file not found: $resolved');
        return null;
      }
      bytes = await file.readAsBytes();
    }

    final codec = await ui.instantiateImageCodec(bytes, targetWidth: 150, targetHeight: 150);
    final frame = await codec.getNextFrame();
    return frame.image;
  } catch (e) {
    debugPrint('loadUiImage error for $path: $e');
    return null;
  }
}

/// Poster widget for off-screen PNG capture.
/// Photos order in row: photo | brand | model name | price
/// Accepts pre-decoded ui.Image objects so images render synchronously.
class MarketReportPoster extends StatelessWidget {
  final List<MarketCarModel> cars;
  final int page;
  final int totalPages;
  final double totalValue;
  final int totalCount;
  final bool isPolish;
  final Map<String, ui.Image> photoImages;

  const MarketReportPoster({
    super.key,
    required this.cars,
    required this.page,
    required this.totalPages,
    required this.totalValue,
    required this.totalCount,
    required this.isPolish,
    required this.photoImages,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.simpleCurrency(
      locale: isPolish ? 'pl_PL' : 'en_US',
      name: isPolish ? 'PLN' : 'USD',
      decimalDigits: 0,
    );

    // Wrap everything in DefaultTextStyle.fallback to remove yellow debug underlines
    return DefaultTextStyle(
      style: const TextStyle(
        decoration: TextDecoration.none,
        color: Colors.black,
        fontFamily: 'sans-serif',
      ),
      child: Container(
        width: 1000,
        color: Colors.white,
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isPolish ? 'SPRAWOZDANIE MARKETPLACE' : 'MARKETPLACE REPORT',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Text(
                      DateFormat('dd.MM.yyyy HH:mm').format(DateTime.now()),
                      style: TextStyle(
                        color: Colors.black.withValues(alpha: 0.4),
                        fontSize: 16,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
                Text(
                  'PAGE $page / $totalPages',
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.4),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Summary boxes
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(child: _buildStatBox(
                    isPolish ? 'ŁĄCZNIE MODELI' : 'TOTAL MODELS',
                    totalCount.toString(),
                    Colors.blue.shade700,
                  )),
                  const SizedBox(width: 20),
                  Expanded(child: _buildStatBox(
                    isPolish ? 'ŁĄCZNA WARTOŚĆ' : 'TOTAL VALUE',
                    currencyFormat.format(totalValue),
                    Colors.green.shade700,
                  )),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Models Table title
            Text(
              isPolish ? 'LISTA MODELI' : 'MODELS LIST',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 12),

            // Table header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                border: Border.all(color: Colors.black12),
              ),
              child: Row(
                children: [
                  // Photo col — wider (flex 2)
                  const SizedBox(width: 80),
                  const SizedBox(width: 12),
                  Expanded(flex: 2, child: _headerText(isPolish ? 'PRODUCENT' : 'PRODUCER')),
                  Expanded(flex: 3, child: _headerText(isPolish ? 'MARKA I MODEL' : 'BRAND & MODEL')),
                  Expanded(flex: 2, child: _headerText(isPolish ? 'CENA' : 'PRICE', align: TextAlign.right)),
                ],
              ),
            ),

            // Table rows
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...cars.map((car) => Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: Colors.grey.shade200)),
                    ),
                    child: Row(
                      children: [
                        // Photo — 80x70, placed BEFORE name (as requested)
                        Container(
                          width: 80,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: photoImages.containsKey(car.id)
                                ? RawImage(image: photoImages[car.id]!, fit: BoxFit.cover)
                                : const Icon(Icons.directions_car, color: Colors.black12, size: 32),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(flex: 2, child: _dataText(
                          car.toyMaker?.toUpperCase() ?? '-',
                          bold: true,
                          color: Colors.blue.shade900,
                        )),
                        Expanded(flex: 3, child: _dataText('${car.brand} ${car.modelName}')),
                        Expanded(flex: 2, child: _dataText(
                          currencyFormat.format(car.price),
                          bold: true,
                          color: Colors.green.shade900,
                          align: TextAlign.right,
                        )),
                      ],
                    ),
                  )),
                  // Fill empty rows for consistent height
                  if (cars.length < 10)
                    ...List.generate(10 - cars.length, (_) => Container(
                      height: 86,
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.grey.shade100)),
                      ),
                    )),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Footer
            Center(
              child: Text(
                'GENERATED BY AUTOWORLD164 APP',
                style: TextStyle(
                  color: Colors.black.withValues(alpha: 0.1),
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(
            color: Colors.black.withValues(alpha: 0.4),
            fontSize: 12,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.none,
          )),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(
            color: color,
            fontSize: 32,
            fontWeight: FontWeight.w900,
            decoration: TextDecoration.none,
          )),
        ],
      ),
    );
  }

  Widget _headerText(String text, {TextAlign align = TextAlign.left}) {
    return Text(text, textAlign: align, style: const TextStyle(
      color: Colors.black54,
      fontSize: 12,
      fontWeight: FontWeight.w900,
      letterSpacing: 1,
      decoration: TextDecoration.none,
    ));
  }

  Widget _dataText(String text, {bool bold = false, Color color = Colors.black87, TextAlign align = TextAlign.left}) {
    return Text(text, textAlign: align, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(
      color: color,
      fontSize: 14,
      fontWeight: bold ? FontWeight.w900 : FontWeight.w500,
      decoration: TextDecoration.none,
    ));
  }
}

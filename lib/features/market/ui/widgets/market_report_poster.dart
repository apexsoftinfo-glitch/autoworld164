import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/market_car_model.dart';

/// Poster widget for off-screen PNG capture.
/// Accepts pre-loaded image bytes so images render synchronously.
class MarketReportPoster extends StatelessWidget {
  final List<MarketCarModel> cars;
  final int page;
  final int totalPages;
  final double totalValue;
  final int totalCount;
  final bool isPolish;
  /// Map of car id → pre-loaded image bytes (may be absent if no photo)
  final Map<String, Uint8List> photoBytes;

  const MarketReportPoster({
    super.key,
    required this.cars,
    required this.page,
    required this.totalPages,
    required this.totalValue,
    required this.totalCount,
    required this.isPolish,
    required this.photoBytes,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.simpleCurrency(
      locale: isPolish ? 'pl_PL' : 'en_US',
      name: isPolish ? 'PLN' : 'USD',
      decimalDigits: 0,
    );

    return Container(
      width: 1000,
      padding: const EdgeInsets.all(40),
      decoration: const BoxDecoration(color: Colors.white),
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
                    isPolish ? 'SPRAWOZDANIE MARKETPLACE' : 'MARKETPLACE REPORT',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  Text(
                    DateFormat('dd.MM.yyyy HH:mm').format(DateTime.now()),
                    style: TextStyle(color: Colors.black.withValues(alpha: 0.4), fontSize: 16),
                  ),
                ],
              ),
              Text(
                'PAGE $page / $totalPages',
                style: TextStyle(color: Colors.black.withValues(alpha: 0.4), fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Summary boxes
          Row(
            children: [
              _buildStatBox(
                isPolish ? 'ŁĄCZNIE MODELI' : 'TOTAL MODELS',
                totalCount.toString(),
                Colors.blue.shade700,
              ),
              const SizedBox(width: 20),
              _buildStatBox(
                isPolish ? 'ŁĄCZNA WARTOŚĆ' : 'TOTAL VALUE',
                currencyFormat.format(totalValue),
                Colors.green.shade700,
              ),
            ],
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
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                // Table Header
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: Row(
                    children: [
                      _headerCell(isPolish ? 'FOTO' : 'PHOTO', flex: 1),
                      _headerCell(isPolish ? 'PRODUCENT' : 'PRODUCER', flex: 2),
                      _headerCell(isPolish ? 'MARKA I MODEL' : 'BRAND & MODEL', flex: 3),
                      _headerCell(isPolish ? 'CENA' : 'PRICE', flex: 2, align: TextAlign.right),
                    ],
                  ),
                ),
                // Table Rows
                ...cars.map((car) => Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey.shade200)),
                  ),
                  child: Row(
                    children: [
                      // Photo Cell — use pre-loaded bytes
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: photoBytes.containsKey(car.id)
                                ? Image.memory(photoBytes[car.id]!, fit: BoxFit.cover)
                                : const Icon(Icons.directions_car, color: Colors.black12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      _dataCell(car.toyMaker?.toUpperCase() ?? '-', flex: 2, isBold: true, color: Colors.blue.shade900),
                      _dataCell('${car.brand} ${car.modelName}', flex: 3),
                      _dataCell(currencyFormat.format(car.price), flex: 2, align: TextAlign.right, isBold: true, color: Colors.green.shade900),
                    ],
                  ),
                )),
                // Fill empty rows to keep consistent height
                if (cars.length < 10)
                  ...List.generate(10 - cars.length, (index) => Container(
                    height: 52,
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: Colors.grey.shade100)),
                    ),
                  )),
              ],
            ),
          ),

          const Spacer(),

          // Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'GENERATED BY AUTOWORLD164 APP',
                style: TextStyle(
                  color: Colors.black.withValues(alpha: 0.1),
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: Colors.black.withValues(alpha: 0.4), fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(color: color, fontSize: 32, fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerCell(String text, {int flex = 1, TextAlign align = TextAlign.left}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: align,
        style: const TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1),
      ),
    );
  }

  Widget _dataCell(String text, {int flex = 1, TextAlign align = TextAlign.left, bool isBold = false, Color color = Colors.black87}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: align,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: isBold ? FontWeight.w900 : FontWeight.w500,
        ),
      ),
    );
  }
}

/// Loads image bytes from a path (network URL or local file).
Future<Uint8List?> loadImageBytes(String path) async {
  try {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      final httpClient = HttpClient();
      final request = await httpClient.getUrl(Uri.parse(path));
      final response = await request.close();
      final bytes = <int>[];
      await for (final chunk in response) {
        bytes.addAll(chunk);
      }
      httpClient.close();
      return Uint8List.fromList(bytes);
    } else {
      // Local file
      final file = File(path);
      if (await file.exists()) {
        return await file.readAsBytes();
      }
    }
  } catch (e) {
    debugPrint('loadImageBytes error for $path: $e');
  }
  return null;
}

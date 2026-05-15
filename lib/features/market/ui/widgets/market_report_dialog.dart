import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/market_car_model.dart';
import 'market_report_poster.dart' show MarketReportPoster, loadUiImage;

class MarketReportDialog extends StatefulWidget {
  final List<MarketCarModel> cars;

  const MarketReportDialog({super.key, required this.cars});

  static Future<void> show(BuildContext context, List<MarketCarModel> cars) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => MarketReportDialog(cars: cars),
    );
  }

  @override
  State<MarketReportDialog> createState() => _MarketReportDialogState();
}

class _MarketReportDialogState extends State<MarketReportDialog> {
  bool _isExporting = false;

  @override
  Widget build(BuildContext context) {
    final isPolish = Localizations.localeOf(context).languageCode == 'pl';
    final currencyFormat = NumberFormat.simpleCurrency(
      locale: isPolish ? 'pl_PL' : 'en_US',
      name: isPolish ? 'PLN' : 'USD',
      decimalDigits: 0,
    );

    final totalCount = widget.cars.length;
    final totalValue = widget.cars.fold<double>(0, (sum, car) => sum + car.price);

    final Map<String, int> producerStats = {};
    for (final car in widget.cars) {
      final producer = car.toyMaker ?? (isPolish ? 'Nieznany' : 'Unknown');
      producerStats[producer] = (producerStats[producer] ?? 0) + 1;
    }
    final sortedProducers = producerStats.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return BackdropFilter(
      filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 500),
          decoration: BoxDecoration(
            color: const Color(0xFF1A120B).withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD700).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.analytics_outlined, color: Color(0xFFFFD700)),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      isPolish ? 'SPRAWOZDANIE' : 'MARKET REPORT',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white38),
                      onPressed: _isExporting ? null : () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Scrollable summary area
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          _buildStatCard(
                            isPolish ? 'ILOŚĆ' : 'COUNT',
                            totalCount.toString(),
                            Colors.blueAccent,
                          ),
                          const SizedBox(width: 12),
                          _buildStatCard(
                            isPolish ? 'WARTOŚĆ' : 'VALUE',
                            currencyFormat.format(totalValue),
                            const Color(0xFFFFD700),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                          itemCount: sortedProducers.length,
                          separatorBuilder: (context, index) => Divider(color: Colors.white.withValues(alpha: 0.05)),
                          itemBuilder: (context, index) {
                            final entry = sortedProducers[index];
                            return Row(
                              children: [
                                Text(
                                  entry.key.toUpperCase(),
                                  style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                Text(
                                  entry.value.toString(),
                                  style: const TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Actions
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _isExporting ? null : _handleExport,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFFFD700),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        icon: _isExporting
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                          : const Icon(Icons.share),
                        label: Text(
                          _isExporting
                            ? (isPolish ? 'GENEROWANIE...' : 'GENERATING...')
                            : (isPolish ? 'EKSPORTUJ PNG' : 'EXPORT PNG'),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleExport() async {
    setState(() => _isExporting = true);

    // Capture context-dependent values before async gaps
    final isPolish = Localizations.localeOf(context).languageCode == 'pl';
    final overlayState = Overlay.of(context);

    try {

      // Sort cars: price desc, then producer asc
      final sortedCars = List<MarketCarModel>.from(widget.cars)..sort((a, b) {
        int res = b.price.compareTo(a.price);
        if (res == 0) res = (a.toyMaker ?? '').compareTo(b.toyMaker ?? '');
        return res;
      });

      const int itemsPerPage = 10;
      final int totalCount = sortedCars.length;
      final double totalValue = widget.cars.fold<double>(0, (s, c) => s + c.price);
      final int totalPages = (totalCount / itemsPerPage).ceil();

      final List<XFile> shareFiles = [];
      final directory = await getTemporaryDirectory();

      for (int i = 0; i < totalPages; i++) {
        final start = i * itemsPerPage;
        final end = start + itemsPerPage < totalCount ? start + itemsPerPage : totalCount;
        final pageCars = sortedCars.sublist(start, end);

        // Step 1: pre-decode images to dart:ui.Image (fully async, before render)
        final Map<String, ui.Image> photoImages = {};
        for (final car in pageCars) {
          final path = car.displayPhotoPath;
          if (path != null) {
            final img = await loadUiImage(path);
            if (img != null) photoImages[car.id] = img;
          }
        }

        // Step 2: insert poster into real Flutter tree via Overlay, off-screen
        final captureKey = GlobalKey();
        late OverlayEntry entry;
        entry = OverlayEntry(builder: (_) => Positioned(
          left: -9999,
          top: -9999,
          width: 1000,
          height: 1500,
          child: RepaintBoundary(
            key: captureKey,
            child: MediaQuery(
              data: const MediaQueryData(size: Size(1000, 1500)),
              child: MarketReportPoster(
                cars: pageCars,
                page: i + 1,
                totalPages: totalPages,
                totalValue: totalValue,
                totalCount: totalCount,
                isPolish: isPolish,
                photoImages: photoImages,
              ),
            ),
          ),
        ));

        overlayState.insert(entry);

        // Step 3: wait for Flutter to fully render (3 frames to be safe)
        await SchedulerBinding.instance.endOfFrame;
        await SchedulerBinding.instance.endOfFrame;
        await SchedulerBinding.instance.endOfFrame;

        // Step 4: capture
        try {
          final boundary = captureKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
          if (boundary != null) {
            final image = await boundary.toImage(pixelRatio: 3.0);
            final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
            final buffer = byteData!.buffer.asUint8List();

            final path = '${directory.path}/market_report_p${i + 1}.png';
            await File(path).writeAsBytes(buffer);
            shareFiles.add(XFile(path));
          }
        } finally {
          entry.remove();
          // Dispose decoded images to free memory
          for (final img in photoImages.values) {
            img.dispose();
          }
        }
      }

      if (shareFiles.isNotEmpty) {
        // ignore: deprecated_member_use
        await Share.shareXFiles(
          shareFiles,
          text: isPolish ? 'Sprawozdanie AutoWorld164' : 'AutoWorld164 Market Report',
        );
      }
    } catch (e) {
      debugPrint('Export error: $e');
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/market_car_model.dart';
import '../../utils/market_report_pdf_generator.dart';

class MarketReportDialog extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final isPolish = Localizations.localeOf(context).languageCode == 'pl';
    final currencyFormat = NumberFormat.simpleCurrency(
      locale: isPolish ? 'pl_PL' : 'en_US',
      name: isPolish ? 'PLN' : 'USD',
      decimalDigits: 0,
    );

    final totalCount = cars.length;
    final totalValue = cars.fold<double>(0, (sum, car) => sum + car.price);

    final Map<String, int> producerStats = {};
    for (final car in cars) {
      final producer = car.toyMaker ?? (isPolish ? 'Nieznany' : 'Unknown');
      producerStats[producer] = (producerStats[producer] ?? 0) + 1;
    }
    final sortedProducers = producerStats.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        backgroundColor: Colors.transparent,
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
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
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
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Summary
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
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
              ),

              const SizedBox(height: 24),

              // List of producers
              Flexible(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
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
                          const SizedBox(width: 4),
                          Text(
                            isPolish ? 'szt.' : 'pcs',
                            style: const TextStyle(color: Colors.white24, fontSize: 9),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              // Actions
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => MarketReportPdfGenerator.generateAndShare(
                          cars: cars,
                          isPolish: isPolish,
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: const Color(0xFFFFD700).withValues(alpha: 0.4)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        icon: const Icon(Icons.picture_as_pdf, color: Color(0xFFFFD700)),
                        label: Text(
                          isPolish ? 'EKSPORTUJ PDF' : 'EXPORT PDF',
                          style: const TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold),
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

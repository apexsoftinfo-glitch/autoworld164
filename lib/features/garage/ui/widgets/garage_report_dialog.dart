import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../models/car_model.dart';
import '../../presentation/cubit/cars_collection_cubit.dart';

class GarageReportDialog extends StatelessWidget {
  const GarageReportDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<CarsCollectionCubit>(),
        child: const GarageReportDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CarsCollectionCubit, CarsCollectionState>(
      builder: (context, state) {
        final cars = state.maybeWhen(
          data: (c, fc, pt, st, q, vt, stype, sorder) => c,
          orElse: () => <CarModel>[],
        );
        return _GarageReportContent(cars: cars);
      },
    );
  }
}

class _GarageReportContent extends StatelessWidget {
  final List<CarModel> cars;
  const _GarageReportContent({required this.cars});

  @override
  Widget build(BuildContext context) {
    final isPolish = Localizations.localeOf(context).languageCode == 'pl';
    final currencyFormat = NumberFormat.simpleCurrency(
      locale: isPolish ? 'pl_PL' : 'en_US',
      name: isPolish ? 'PLN' : 'USD',
      decimalDigits: 0,
    );

    final totalCount = cars.length;
    final totalValue = cars.fold<double>(0, (sum, c) => sum + c.purchasePrice);
    final avgValue = totalCount > 0 ? totalValue / totalCount : 0.0;

    // Producer stats: name → {count, totalValue}
    final Map<String, ({int count, double value})> producerStats = {};
    for (final car in cars) {
      final key = (car.toyMaker ?? (isPolish ? 'Nieznany' : 'Unknown')).trim();
      final prev = producerStats[key] ?? (count: 0, value: 0.0);
      producerStats[key] = (count: prev.count + 1, value: prev.value + car.purchasePrice);
    }
    final sortedProducers = producerStats.entries.toList()
      ..sort((a, b) => b.value.count.compareTo(a.value.count));

    // Series stats: name → {count, totalValue}
    final Map<String, ({int count, double value})> seriesStats = {};
    for (final car in cars) {
      final key = (car.series ?? (isPolish ? 'Nieznany' : 'Unknown')).trim();
      final prev = seriesStats[key] ?? (count: 0, value: 0.0);
      seriesStats[key] = (count: prev.count + 1, value: prev.value + car.purchasePrice);
    }
    final sortedSeries = seriesStats.entries.toList()
      ..sort((a, b) => b.value.count.compareTo(a.value.count));

    // Monthly additions (last 12 months)
    final now = DateTime.now();
    final monthlyData = <String, int>{};
    for (int i = 11; i >= 0; i--) {
      final d = DateTime(now.year, now.month - i, 1);
      final key = DateFormat(isPolish ? 'MMM yy' : 'MMM yy', isPolish ? 'pl' : 'en').format(d);
      monthlyData[key] = 0;
    }
    for (final car in cars) {
      final d = car.purchaseDate;
      if (d == null) continue;
      final monthsAgo = (now.year - d.year) * 12 + (now.month - d.month);
      if (monthsAgo >= 0 && monthsAgo < 12) {
        final key = DateFormat(isPolish ? 'MMM yy' : 'MMM yy', isPolish ? 'pl' : 'en').format(d);
        monthlyData[key] = (monthlyData[key] ?? 0) + 1;
      }
    }
    final monthLabels = monthlyData.keys.toList();
    final monthCounts = monthlyData.values.toList();
    final maxMonthCount = monthCounts.reduce(max).clamp(1, double.maxFinite).toInt();

    return BackdropFilter(
      filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 500),
          decoration: BoxDecoration(
            color: const Color(0xFF1A120B).withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Header ──────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 16, 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD700).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.analytics_outlined, color: Color(0xFFFFD700)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        isPolish ? 'SPRAWOZDANIE GARAŻU' : 'GARAGE REPORT',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white38),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // ── Scrollable body ─────────────────────────────────────────
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Summary cards
                      Row(
                        children: [
                          _StatCard(
                            label: isPolish ? 'MODELI' : 'MODELS',
                            value: totalCount.toString(),
                            color: Colors.blueAccent,
                          ),
                          const SizedBox(width: 10),
                          _StatCard(
                            label: isPolish ? 'WARTOŚĆ' : 'VALUE',
                            value: currencyFormat.format(totalValue),
                            color: const Color(0xFFFFD700),
                          ),
                          const SizedBox(width: 10),
                          _StatCard(
                            label: isPolish ? 'ŚR. CENA' : 'AVG PRICE',
                            value: currencyFormat.format(avgValue),
                            color: Colors.greenAccent,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Monthly chart title
                      _SectionTitle(isPolish ? 'ZAKUPY PO MIESIĄCACH' : 'PURCHASES BY MONTH'),
                      const SizedBox(height: 12),
                      _MonthlyChart(
                        labels: monthLabels,
                        counts: monthCounts,
                        maxCount: maxMonthCount,
                      ),

                      const SizedBox(height: 24),

                      // Producer table title
                      _SectionTitle(isPolish ? 'WG PRODUCENTA' : 'BY PRODUCER'),
                      const SizedBox(height: 10),
                      _StatsTable(
                        label: isPolish ? 'PRODUCENT' : 'PRODUCER',
                        items: sortedProducers,
                        totalCount: totalCount,
                        totalValue: totalValue,
                        currencyFormat: currencyFormat,
                        isPolish: isPolish,
                      ),

                      const SizedBox(height: 24),

                      // Series table title
                      _SectionTitle(isPolish ? 'WG SERII' : 'BY SERIES'),
                      const SizedBox(height: 10),
                      _StatsTable(
                        label: isPolish ? 'SERIA' : 'SERIES',
                        items: sortedSeries,
                        totalCount: totalCount,
                        totalValue: totalValue,
                        currencyFormat: currencyFormat,
                        isPolish: isPolish,
                      ),

                      const SizedBox(height: 8),
                    ],
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

// ─────────────────────────────────────────────────────────────────────────────
// Stat card
// ─────────────────────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 1),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section title
// ─────────────────────────────────────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 3, height: 14, decoration: BoxDecoration(
          color: const Color(0xFFFFD700),
          borderRadius: BorderRadius.circular(2),
        )),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Monthly bar chart (pure Flutter, no packages)
// ─────────────────────────────────────────────────────────────────────────────
class _MonthlyChart extends StatelessWidget {
  final List<String> labels;
  final List<int> counts;
  final int maxCount;

  const _MonthlyChart({
    required this.labels,
    required this.counts,
    required this.maxCount,
  });

  @override
  Widget build(BuildContext context) {
    const chartHeight = 120.0;
    const barColor = Color(0xFFFFD700);
    const barColorEmpty = Color(0xFF2A2A2A);

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          SizedBox(
            height: chartHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(labels.length, (i) {
                final ratio = maxCount > 0 ? counts[i] / maxCount : 0.0;
                final barH = (ratio * (chartHeight - 20)).clamp(4.0, chartHeight - 20);
                final isEmpty = counts[i] == 0;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (!isEmpty)
                          Text(
                            counts[i].toString(),
                            style: const TextStyle(
                              color: Color(0xFFFFD700),
                              fontSize: 8,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        const SizedBox(height: 2),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeOutCubic,
                          height: isEmpty ? 4 : barH,
                          decoration: BoxDecoration(
                            color: isEmpty ? barColorEmpty : barColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 8),
          // Month labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(labels.length, (i) {
              // Show every 3rd label to avoid clutter
              final show = i % 3 == 0 || i == labels.length - 1;
              return Expanded(
                child: Center(
                  child: show
                    ? Text(
                        labels[i].toUpperCase(),
                        style: const TextStyle(color: Colors.white24, fontSize: 7, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      )
                    : const SizedBox.shrink(),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stats breakdown table
// ─────────────────────────────────────────────────────────────────────────────
class _StatsTable extends StatelessWidget {
  final String label;
  final List<MapEntry<String, ({int count, double value})>> items;
  final int totalCount;
  final double totalValue;
  final NumberFormat currencyFormat;
  final bool isPolish;

  const _StatsTable({
    required this.label,
    required this.items,
    required this.totalCount,
    required this.totalValue,
    required this.currencyFormat,
    required this.isPolish,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          // Header row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    label.toUpperCase(),
                    style: const TextStyle(color: Colors.white24, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1),
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: Text(
                    isPolish ? 'SZT.' : 'QTY',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white24, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1),
                  ),
                ),
                SizedBox(
                  width: 56,
                  child: Text(
                    isPolish ? 'UDZIAŁ' : 'SHARE',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white24, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    isPolish ? 'WARTOŚĆ' : 'VALUE',
                    textAlign: TextAlign.end,
                    style: const TextStyle(color: Colors.white24, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.white.withValues(alpha: 0.05)),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: items.length,
            separatorBuilder: (_, _) => Divider(height: 1, indent: 16, endIndent: 16, color: Colors.white.withValues(alpha: 0.04)),
            itemBuilder: (context, index) {
              final entry = items[index];
              final pct = totalCount > 0 ? (entry.value.count / totalCount * 100) : 0.0;
              final shareRatio = totalCount > 0 ? entry.value.count / totalCount : 0.0;
              final isTop = index == 0;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            entry.key.toUpperCase(),
                            style: TextStyle(
                              color: isTop ? const Color(0xFFFFD700) : Colors.white70,
                              fontSize: 11,
                              fontWeight: isTop ? FontWeight.w900 : FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 40,
                          child: Text(
                            entry.value.count.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                        SizedBox(
                          width: 56,
                          child: Text(
                            '${pct.toStringAsFixed(0)}%',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white38, fontSize: 11),
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: Text(
                            currencyFormat.format(entry.value.value),
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: isTop ? const Color(0xFFFFD700) : Colors.white54,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Share bar
                    LayoutBuilder(builder: (context, constraints) {
                      return Stack(
                        children: [
                          Container(
                            height: 3,
                            width: constraints.maxWidth,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          Container(
                            height: 3,
                            width: constraints.maxWidth * shareRatio,
                            decoration: BoxDecoration(
                              color: isTop
                                  ? const Color(0xFFFFD700)
                                  : const Color(0xFFFFD700).withValues(alpha: 0.35),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../models/market_car_model.dart';

class MarketReportPdfGenerator {
  static Future<void> generateAndShare({
    required List<MarketCarModel> cars,
    required bool isPolish,
  }) async {
    final pdf = pw.Document();

    final fontRegular = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();

    final theme = pw.ThemeData.withFont(
      base: fontRegular,
      bold: fontBold,
    );

    final currencyFormat = NumberFormat.simpleCurrency(
      locale: isPolish ? 'pl_PL' : 'en_US',
      name: isPolish ? 'PLN' : 'USD',
    );

    final dateFormat = DateFormat('dd.MM.yyyy HH:mm');

    // Calculations
    final totalCount = cars.length;
    final totalValue = cars.fold<double>(0, (sum, car) => sum + car.price);
    
    final Map<String, int> producerStats = {};
    for (final car in cars) {
      final producer = car.toyMaker ?? (isPolish ? 'Nieznany' : 'Unknown');
      producerStats[producer] = (producerStats[producer] ?? 0) + 1;
    }
    final sortedProducers = producerStats.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: theme,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Header
            pw.Container(
              padding: const pw.EdgeInsets.only(bottom: 8),
              decoration: const pw.BoxDecoration(
                border: pw.Border(bottom: pw.BorderSide(color: PdfColors.amber700, width: 2)),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('AutoWorld164 - ${isPolish ? 'SPRAWOZDANIE' : 'MARKET REPORT'}', 
                      style: pw.TextStyle(font: fontBold, fontSize: 14, color: PdfColors.amber700)),
                  pw.Text(dateFormat.format(DateTime.now()), 
                      style: pw.TextStyle(font: fontRegular, fontSize: 9, color: PdfColors.grey600)),
                ],
              ),
            ),
            pw.SizedBox(height: 24),

            // Summary Cards
            pw.Row(
              children: [
                _buildSummaryCard(
                  isPolish ? 'ŁĄCZNIE MODELI' : 'TOTAL MODELS',
                  totalCount.toString(),
                  PdfColors.blue700,
                  fontBold,
                ),
                pw.SizedBox(width: 16),
                _buildSummaryCard(
                  isPolish ? 'ŁĄCZNA WARTOŚĆ' : 'TOTAL VALUE',
                  currencyFormat.format(totalValue),
                  PdfColors.green700,
                  fontBold,
                ),
              ],
            ),
            pw.SizedBox(height: 32),

            // Producers Table
            pw.Text(isPolish ? 'STATYSTYKI WG PRODUCENTÓW' : 'STATS BY PRODUCER',
                style: pw.TextStyle(font: fontBold, fontSize: 11, color: PdfColors.grey700)),
            pw.SizedBox(height: 12),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey200, width: 0.5),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey100),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Text(isPolish ? 'PRODUCENT' : 'PRODUCER', style: pw.TextStyle(font: fontBold, fontSize: 9)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Text(isPolish ? 'ILOŚĆ' : 'COUNT', style: pw.TextStyle(font: fontBold, fontSize: 9), textAlign: pw.TextAlign.center),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Text(isPolish ? 'UDZIAŁ' : 'SHARE', style: pw.TextStyle(font: fontBold, fontSize: 9), textAlign: pw.TextAlign.right),
                    ),
                  ],
                ),
                ...sortedProducers.map((entry) {
                  final percentage = (entry.value / totalCount * 100).toStringAsFixed(1);
                  return pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(6),
                        child: pw.Text(entry.key, style: const pw.TextStyle(fontSize: 9)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(6),
                        child: pw.Text(entry.value.toString(), style: const pw.TextStyle(fontSize: 9), textAlign: pw.TextAlign.center),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(6),
                        child: pw.Text('$percentage%', style: const pw.TextStyle(fontSize: 9), textAlign: pw.TextAlign.right),
                      ),
                    ],
                  );
                }),
              ],
            ),
            
            pw.SizedBox(height: 32),
            
            // Footer Info
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.amber50,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                border: pw.Border.all(color: PdfColors.amber200),
              ),
              child: pw.Text(
                isPolish 
                  ? 'Niniejsze sprawozdanie zawiera dane z sekcji Wymiana/Sprzedaż aplikacji AutoWorld164.' 
                  : 'This report contains data from the Exchange/Sale section of the AutoWorld164 app.',
                style: pw.TextStyle(font: fontRegular, fontSize: 8, color: PdfColors.grey700, fontStyle: pw.FontStyle.italic),
              ),
            ),
          ];
        },
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'autoworld_market_report_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf',
    );
  }

  static pw.Widget _buildSummaryCard(String label, String value, PdfColor color, pw.Font fontBold) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(12),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: color.shade(0.2)),
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
          color: color.shade(0.02),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(label, style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
            pw.SizedBox(height: 4),
            pw.Text(value, style: pw.TextStyle(font: fontBold, fontSize: 16, color: color)),
          ],
        ),
      ),
    );
  }
}

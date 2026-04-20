import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/car_model.dart';

class CarPdfGenerator {
  static Future<void> generateAndShare(
    CarModel car, {
    required bool isPolish,
    required SupabaseClient supabase,
  }) async {
    final pdf = pw.Document();

    // Load fonts that support Polish characters (ą, ę, ó, ś, ź, ż, ć, ń)
    final fontRegular = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();
    final fontItalic = await PdfGoogleFonts.robotoItalic();

    final theme = pw.ThemeData.withFont(
      base: fontRegular,
      bold: fontBold,
      italic: fontItalic,
    );

    final currencyFormat = NumberFormat.simpleCurrency(
      locale: isPolish ? 'pl_PL' : 'en_US',
      name: isPolish ? 'PLN' : 'USD',
    );

    final dateFormat = DateFormat('dd.MM.yyyy');

    // Load ALL photos
    final allPaths = car.allPhotoPaths;
    final List<pw.ImageProvider> allImages = [];

    for (final photoPath in allPaths) {
      try {
        Uint8List? imageBytes;
        if (photoPath.startsWith('http')) {
          final response = await NetworkAssetBundle(Uri.parse(photoPath)).load('');
          imageBytes = response.buffer.asUint8List();
        } else if (photoPath.contains('/')) {
          // Supabase storage path
          final url = supabase.storage.from('autoworld_photos').getPublicUrl(photoPath);
          final response = await NetworkAssetBundle(Uri.parse(url)).load('');
          imageBytes = response.buffer.asUint8List();
        } else {
          // Local file
          final docs = await getApplicationDocumentsDirectory();
          final file = File(p.join(docs.path, 'autoworld_photos', photoPath));
          if (await file.exists()) {
            imageBytes = await file.readAsBytes();
          }
        }
        if (imageBytes != null) {
          allImages.add(pw.MemoryImage(imageBytes));
        }
      } catch (_) {
        // Skip unloadable image
      }
    }

    final pw.ImageProvider? mainImage = allImages.isNotEmpty ? allImages.first : null;
    final List<pw.ImageProvider> additionalImages = allImages.length > 1 ? allImages.sublist(1) : [];

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        theme: theme,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────────────────
              pw.Container(
                padding: const pw.EdgeInsets.only(bottom: 8),
                decoration: const pw.BoxDecoration(
                  border: pw.Border(bottom: pw.BorderSide(color: PdfColors.amber700, width: 2)),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('AutoWorld164', style: pw.TextStyle(font: fontBold, fontSize: 11, color: PdfColors.amber700)),
                    pw.Text(dateFormat.format(DateTime.now()), style: pw.TextStyle(font: fontRegular, fontSize: 9, color: PdfColors.grey600)),
                  ],
                ),
              ),
              pw.SizedBox(height: 16),

              // ── Main photo + Details ─────────────────────────────────────
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (mainImage != null)
                    pw.Container(
                      width: 190,
                      height: 145,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.grey300),
                        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                      ),
                      child: pw.ClipRRect(
                        horizontalRadius: 6,
                        verticalRadius: 6,
                        child: pw.Image(mainImage, fit: pw.BoxFit.cover),
                      ),
                    ),
                  pw.SizedBox(width: mainImage != null ? 16 : 0),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        if (car.toyMaker != null)
                          pw.Text(car.toyMaker!.toUpperCase(),
                              style: pw.TextStyle(font: fontBold, color: PdfColors.amber700, fontSize: 9)),
                        pw.Text('${car.brand} ${car.modelName}',
                            style: pw.TextStyle(font: fontBold, fontSize: 20)),
                        pw.SizedBox(height: 8),
                        _buildDetail(isPolish ? 'STAN' : 'STATUS', car.status, fontRegular: fontRegular, fontBold: fontBold),
                        _buildDetail(isPolish ? 'SERIA' : 'SERIES', car.series ?? '-', fontRegular: fontRegular, fontBold: fontBold),
                        _buildDetail(
                          isPolish ? 'DATA ZAKUPU' : 'PURCHASE DATE',
                          car.purchaseDate != null ? dateFormat.format(car.purchaseDate!) : '-',
                          fontRegular: fontRegular,
                          fontBold: fontBold,
                        ),
                        pw.Divider(color: PdfColors.grey200),
                        _buildDetail(isPolish ? 'CENA ZAKUPU' : 'PURCHASE PRICE', currencyFormat.format(car.purchasePrice), fontRegular: fontRegular, fontBold: fontBold),
                        _buildDetail(isPolish ? 'SZAC. WARTOŚĆ' : 'EST. VALUE', currencyFormat.format(car.estimatedValue), highlight: true, fontRegular: fontRegular, fontBold: fontBold),
                      ],
                    ),
                  ),
                ],
              ),

              // ── Additional photos grid ───────────────────────────────────
              if (additionalImages.isNotEmpty) ...[
                pw.SizedBox(height: 20),
                pw.Text(
                  isPolish ? 'GALERIA ZDJĘĆ' : 'PHOTO GALLERY',
                  style: pw.TextStyle(font: fontBold, fontSize: 9, color: PdfColors.grey600, letterSpacing: 1.5),
                ),
                pw.SizedBox(height: 8),
                pw.Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: additionalImages.map((img) {
                    return pw.Container(
                      width: 120,
                      height: 90,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.grey300),
                        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                      ),
                      child: pw.ClipRRect(
                        horizontalRadius: 6,
                        verticalRadius: 6,
                        child: pw.Image(img, fit: pw.BoxFit.cover),
                      ),
                    );
                  }).toList(),
                ),
              ],

              pw.Spacer(),

              // ── Footer ──────────────────────────────────────────────────
              pw.Divider(color: PdfColors.grey300),
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  'Generated by AutoWorld164  •  ${allImages.length} ${isPolish ? 'zdjęć' : 'photo(s)'}',
                  style: pw.TextStyle(font: fontRegular, fontSize: 8, color: PdfColors.grey500),
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'autoworld_${car.brand}_${car.modelName}.pdf',
    );
  }

  static pw.Widget _buildDetail(
    String label,
    String value, {
    bool highlight = false,
    required pw.Font fontRegular,
    required pw.Font fontBold,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 95,
            child: pw.Text(label, style: pw.TextStyle(font: fontRegular, fontSize: 9, color: PdfColors.grey600)),
          ),
          pw.Expanded(
            child: pw.Text(value, style: pw.TextStyle(
              font: highlight ? fontBold : fontRegular,
              fontSize: 10,
              color: highlight ? PdfColors.amber900 : PdfColors.black,
            )),
          ),
        ],
      ),
    );
  }
}

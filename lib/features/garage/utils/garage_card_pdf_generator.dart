import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/car_model.dart';

class GarageCardPdfGenerator {
  static Future<void> generateAndShare(
    CarModel car, {
    required String? garageName,
    required SupabaseClient supabase,
  }) async {
    final pdf = pw.Document();

    // Fonts with Polish character support
    final fontRegular = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();
    final fontLight = await PdfGoogleFonts.robotoLight();

    // Load App Icon
    final logoData = await rootBundle.load('assets/images/icon/icon.png');
    final logoImage = pw.MemoryImage(logoData.buffer.asUint8List());

    final theme = pw.ThemeData.withFont(
      base: fontRegular,
      bold: fontBold,
    );

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
          final url = supabase.storage.from('autoworld_photos').getPublicUrl(photoPath);
          final response = await NetworkAssetBundle(Uri.parse(url)).load('');
          imageBytes = response.buffer.asUint8List();
        } else {
          final docs = await getApplicationDocumentsDirectory();
          final file = File(p.join(docs.path, 'autoworld_photos', photoPath));
          if (await file.exists()) {
            imageBytes = await file.readAsBytes();
          }
        }
        if (imageBytes != null) {
          allImages.add(pw.MemoryImage(imageBytes));
        }
      } catch (_) {}
    }

    final pw.ImageProvider? mainImage = allImages.isNotEmpty ? allImages.first : null;
    final List<pw.ImageProvider> extraImages = allImages.length > 1 ? allImages.sublist(1) : [];

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        theme: theme,
        margin: const pw.EdgeInsets.all(0),
        build: (pw.Context context) {
          return pw.Column(
            children: [
              // ── Garage header banner (LIGHT) ──────────────────────────
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(horizontal: 32, vertical: 15),
                decoration: const pw.BoxDecoration(
                  color: PdfColors.white,
                  border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey200, width: 1)),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Row(
                      children: [
                        pw.Container(
                          width: 40,
                          height: 40,
                          decoration: pw.BoxDecoration(
                            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                          ),
                          child: pw.ClipRRect(
                            horizontalRadius: 8,
                            verticalRadius: 8,
                            child: pw.Image(logoImage),
                          ),
                        ),
                        pw.SizedBox(width: 15),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              (garageName ?? 'AutoWorld164').toUpperCase(),
                              style: pw.TextStyle(font: fontBold, fontSize: 18, color: PdfColors.black, letterSpacing: 2),
                            ),
                            pw.Text(
                              'KOLEKCJA 1/64',
                              style: pw.TextStyle(font: fontLight, fontSize: 8, color: PdfColors.grey600, letterSpacing: 2),
                            ),
                          ],
                        ),
                      ],
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.amber700, width: 1.5),
                        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                      ),
                      child: pw.Text(
                        '1/64',
                        style: pw.TextStyle(font: fontBold, fontSize: 14, color: PdfColors.amber700),
                      ),
                    ),
                  ],
                ),
              ),

              pw.Expanded(
                child: pw.Padding(
                  padding: const pw.EdgeInsets.all(28),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // ── Main photo (CONTAIN) ─────────────────────────────
                      if (mainImage != null)
                        pw.Container(
                          width: double.infinity,
                          height: 300,
                          decoration: pw.BoxDecoration(
                            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),
                            color: PdfColors.grey50,
                            border: pw.Border.all(color: PdfColors.grey200),
                          ),
                          child: pw.ClipRRect(
                            horizontalRadius: 12,
                            verticalRadius: 12,
                            child: pw.Center(
                              child: pw.Image(mainImage, fit: pw.BoxFit.contain),
                            ),
                          ),
                        )
                      else
                        pw.Container(
                          width: double.infinity,
                          height: 300,
                          decoration: pw.BoxDecoration(
                            color: PdfColors.grey100,
                            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),
                          ),
                          child: pw.Center(
                            child: pw.Text('Brak zdjęcia', style: pw.TextStyle(font: fontRegular, color: PdfColors.grey400)),
                          ),
                        ),

                      pw.SizedBox(height: 20),

                      // ── Car info ─────────────────────────────────────────
                      if (car.toyMaker != null)
                        pw.Text(
                          car.toyMaker!.toUpperCase(),
                          style: pw.TextStyle(font: fontBold, fontSize: 10, color: PdfColors.amber700, letterSpacing: 2),
                        ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        '${car.brand} ${car.modelName}',
                        style: pw.TextStyle(font: fontBold, fontSize: 28),
                      ),
                      pw.SizedBox(height: 18),

                      // ── Info grid ────────────────────────────────────────
                      pw.Row(
                        children: [
                          _infoBox('STAN', car.status.toUpperCase(), fontRegular: fontRegular, fontBold: fontBold),
                          pw.SizedBox(width: 12),
                          _infoBox('SERIA', car.series ?? '—', fontRegular: fontRegular, fontBold: fontBold),
                        ],
                      ),

                      // ── Extra photos grid ────────────────────────────────
                      if (extraImages.isNotEmpty) ...[
                        pw.SizedBox(height: 25),
                        pw.Text(
                          'GALERIA ZDJĘĆ',
                          style: pw.TextStyle(font: fontBold, fontSize: 8, color: PdfColors.grey500, letterSpacing: 2),
                        ),
                        pw.SizedBox(height: 10),
                        pw.Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: extraImages.map((img) => pw.Container(
                            width: 110,
                            height: 80,
                            decoration: pw.BoxDecoration(
                              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                              border: pw.Border.all(color: PdfColors.grey200),
                              color: PdfColors.grey50,
                            ),
                            child: pw.ClipRRect(
                              horizontalRadius: 8,
                              verticalRadius: 8,
                              child: pw.Center(child: pw.Image(img, fit: pw.BoxFit.contain)),
                            ),
                          )).toList(),
                        ),
                      ],

                      pw.Spacer(),

                      // ── Footer ───────────────────────────────────────────
                      pw.Divider(color: PdfColors.grey200),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('AutoWorld164', style: pw.TextStyle(font: fontRegular, fontSize: 8, color: PdfColors.grey400)),
                          if (allImages.isNotEmpty)
                            pw.Text('${allImages.length} zdjęć', style: pw.TextStyle(font: fontRegular, fontSize: 8, color: PdfColors.grey400)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'garage_${car.brand}_${car.modelName}.pdf',
    );
  }

  static pw.Widget _infoBox(
    String label,
    String value, {
    required pw.Font fontRegular,
    required pw.Font fontBold,
  }) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(12),
        decoration: pw.BoxDecoration(
          color: PdfColors.grey50,
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
          border: pw.Border.all(color: PdfColors.grey200),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(label, style: pw.TextStyle(font: fontRegular, fontSize: 8, color: PdfColors.grey500, letterSpacing: 1)),
            pw.SizedBox(height: 4),
            pw.Text(value, style: pw.TextStyle(font: fontBold, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

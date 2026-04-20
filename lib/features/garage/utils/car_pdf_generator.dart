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

    // Load Image
    pw.ImageProvider? carImage;
    final photoPath = car.displayPhotoPath;
    
    if (photoPath != null) {
      try {
        Uint8List? imageBytes;
        if (photoPath.startsWith('http')) {
          final response = await NetworkAssetBundle(Uri.parse(photoPath)).load("");
          imageBytes = response.buffer.asUint8List();
        } else if (photoPath.contains('/')) {
          // Supabase path
          final url = supabase.storage.from('autoworld_photos').getPublicUrl(photoPath);
          final response = await NetworkAssetBundle(Uri.parse(url)).load("");
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
          carImage = pw.MemoryImage(imageBytes);
        }
      } catch (e) {
        // Fallback or ignore image
      }
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        theme: theme,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('AutoWorld164 - Collection Export', style: pw.TextStyle(font: fontBold, fontSize: 10)),
                    pw.Text(dateFormat.format(DateTime.now()), style: pw.TextStyle(font: fontRegular, fontSize: 10)),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (carImage != null)
                    pw.Container(
                      width: 200,
                      height: 150,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.grey300),
                        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                      ),
                      child: pw.ClipRRect(
                        horizontalRadius: 8,
                        verticalRadius: 8,
                        child: pw.Image(carImage, fit: pw.BoxFit.cover),
                      ),
                    ),
                  pw.SizedBox(width: 20),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(car.toyMaker?.toUpperCase() ?? 'UNKNOWN TOY MAKER',
                            style: pw.TextStyle(font: fontBold, color: PdfColors.amber700, fontSize: 10)),
                        pw.Text('${car.brand} ${car.modelName}',
                            style: pw.TextStyle(font: fontBold, fontSize: 24)),
                        pw.SizedBox(height: 10),
                        _buildDetail(isPolish ? 'STAN' : 'STATUS', car.status.toUpperCase(), fontRegular: fontRegular, fontBold: fontBold),
                        _buildDetail(isPolish ? 'SERIA' : 'SERIES', car.series ?? '-', fontRegular: fontRegular, fontBold: fontBold),
                        _buildDetail(isPolish ? 'DATA ZAKUPU' : 'PURCHASE DATE', 
                            car.purchaseDate != null ? dateFormat.format(car.purchaseDate!) : '-', fontRegular: fontRegular, fontBold: fontBold),
                        pw.Divider(color: PdfColors.grey200),
                        _buildDetail(isPolish ? 'CENA ZAKUPU' : 'PURCHASE PRICE', currencyFormat.format(car.purchasePrice), fontRegular: fontRegular, fontBold: fontBold),
                        _buildDetail(isPolish ? 'SZAC. WARTOŚĆ' : 'ESTIMATED VALUE', currencyFormat.format(car.estimatedValue), highlight: true, fontRegular: fontRegular, fontBold: fontBold),
                      ],
                    ),
                  ),
                ],
              ),
              pw.Spacer(),
              pw.Divider(color: PdfColors.grey400),
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Text('Generated by AutoWorld164', style: pw.TextStyle(font: fontRegular, fontSize: 8, color: PdfColors.grey500)),
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
            width: 100,
            child: pw.Text(label, style: pw.TextStyle(font: fontRegular, fontSize: 10, color: PdfColors.grey700)),
          ),
          pw.Text(value, style: pw.TextStyle(
            font: highlight ? fontBold : fontRegular,
            fontSize: 11,
            color: highlight ? PdfColors.amber900 : PdfColors.black,
          )),
        ],
      ),
    );
  }
}

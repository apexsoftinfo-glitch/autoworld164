import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

class MarketReportImageGenerator {
  static Future<void> captureAndShare(GlobalKey key, String fileName) async {
    try {
      final boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      // Increase pixelRatio for better quality
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final buffer = byteData!.buffer.asUint8List();

      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/$fileName.png');
      await file.writeAsBytes(buffer);

      // ignore: deprecated_member_use
      await Share.shareXFiles([XFile(file.path)], text: 'AutoWorld164 Market Report');
    } catch (e) {
      debugPrint('Error capturing image: $e');
    }
  }
}

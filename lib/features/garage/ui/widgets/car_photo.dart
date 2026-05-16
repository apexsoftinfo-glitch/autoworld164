import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/config/app_config.dart';

class CarPhoto extends StatelessWidget {
  final String path;
  final BoxFit fit;
  final Widget? placeholder;
  final String folderName;

  const CarPhoto({
    required this.path,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.folderName = 'autoworld_photos',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (path.isEmpty) return placeholder ?? const Icon(Icons.error);

    if (path.startsWith('http')) {
      return Image.network(
        path,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => placeholder ?? const Icon(Icons.error),
      );
    }
    
    if (p.isAbsolute(path)) {
      return Image.file(
        File(path),
        fit: fit,
        cacheWidth: 600,
        errorBuilder: (context, error, stackTrace) => placeholder ?? const Icon(Icons.error),
      );
    }

    // Legacy support: Supabase storage paths contain '/'
    if (path.contains('/')) {
      // Recovery: check if the file exists locally first (in case upload was interrupted or we want to prioritize local)
      final fileName = p.basename(path);
      final localCheck = p.join(AppConfig.docsPath, 'autoworld_photos', fileName);
      if (File(localCheck).existsSync()) {
        return Image.file(
          File(localCheck),
          fit: fit,
          cacheWidth: 600,
        );
      }

      final supabase = getIt<SupabaseClient>();
      final url = supabase.storage.from('autoworld_photos').getPublicUrl(path);
      return Image.network(
        url,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => placeholder ?? const Icon(Icons.error),
      );
    }

    // Local file: resolve synchronously using AppConfig
    String fullPath = p.join(AppConfig.docsPath, folderName, path);
    
    // Fallback logic for legacy marketplace photos
    if (!File(fullPath).existsSync() && folderName == 'autoworld_photos') {
      final legacyPath = p.join(AppConfig.docsPath, 'autoworld_market_photos', path);
      if (File(legacyPath).existsSync()) {
        fullPath = legacyPath;
      }
    }

    return Image.file(
      File(fullPath),
      fit: fit,
      cacheWidth: 600,
      errorBuilder: (context, error, stackTrace) {
        debugPrint('CarPhoto error loading local file: $fullPath');
        return placeholder ?? const Icon(Icons.error);
      },
    );
  }
}

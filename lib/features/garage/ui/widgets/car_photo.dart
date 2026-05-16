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
    
    // Legacy support: Supabase storage paths contain '/'
    if (path.contains('/')) {
      final supabase = getIt<SupabaseClient>();
      final url = supabase.storage.from('autoworld_photos').getPublicUrl(path);
      return Image.network(
        url,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => placeholder ?? const Icon(Icons.error),
      );
    }

    // Local file: resolve synchronously using AppConfig
    final fullPath = p.join(AppConfig.docsPath, folderName, path);
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

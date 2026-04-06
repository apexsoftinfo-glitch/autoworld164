import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/di/injection.dart';

class CarPhoto extends StatelessWidget {
  final String path;
  final BoxFit fit;
  final Widget? placeholder;

  const CarPhoto({
    required this.path,
    this.fit = BoxFit.cover,
    this.placeholder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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

    // New format: Local filename relative to documents/autoworld_photos
    return FutureBuilder<String>(
      future: _getLocalPath(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final file = File(snapshot.data!);
          return Image.file(
            file,
            fit: fit,
            errorBuilder: (context, error, stackTrace) => placeholder ?? const Icon(Icons.error),
          );
        }
        return placeholder ?? const Center(child: CircularProgressIndicator(strokeWidth: 2));
      },
    );
  }

  Future<String> _getLocalPath() async {
    final docs = await getApplicationDocumentsDirectory();
    return p.join(docs.path, 'autoworld_photos', path);
  }
}

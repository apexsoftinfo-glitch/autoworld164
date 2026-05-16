import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/di/injection.dart';

class CarPhoto extends StatefulWidget {
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
  State<CarPhoto> createState() => _CarPhotoState();
}

class _CarPhotoState extends State<CarPhoto> {
  static String? _docsPath;
  String? _resolvedPath;

  @override
  void initState() {
    super.initState();
    _initPath();
  }

  @override
  void didUpdateWidget(CarPhoto oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path || oldWidget.folderName != widget.folderName) {
      _initPath();
    }
  }

  Future<void> _initPath() async {
    if (widget.path.startsWith('http') || widget.path.contains('/')) {
      if (mounted) setState(() => _resolvedPath = widget.path);
      return;
    }

    _docsPath ??= (await getApplicationDocumentsDirectory()).path;
    if (mounted) {
      setState(() {
        _resolvedPath = p.join(_docsPath!, widget.folderName, widget.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final path = _resolvedPath;
    if (path == null) {
      return widget.placeholder ?? const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    if (path.startsWith('http')) {
      return Image.network(
        path,
        fit: widget.fit,
        errorBuilder: (context, error, stackTrace) => widget.placeholder ?? const Icon(Icons.error),
      );
    }
    
    // Legacy support: Supabase storage paths contain '/'
    if (path.contains('/')) {
      final supabase = getIt<SupabaseClient>();
      final url = supabase.storage.from('autoworld_photos').getPublicUrl(path);
      return Image.network(
        url,
        fit: widget.fit,
        errorBuilder: (context, error, stackTrace) => widget.placeholder ?? const Icon(Icons.error),
      );
    }

    return Image.file(
      File(path),
      fit: widget.fit,
      // Optimize for list/grid thumbnails
      cacheWidth: 600,
      errorBuilder: (context, error, stackTrace) => widget.placeholder ?? const Icon(Icons.error),
    );
  }
}

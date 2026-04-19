import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class GarageBackground extends StatelessWidget {
  final String path;
  final Widget child;
  final double alpha;

  const GarageBackground({
    required this.path,
    required this.child,
    this.alpha = 0.4,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (path.startsWith('assets/')) {
      return _buildContainer(AssetImage(path));
    }

    // Local file
    return FutureBuilder<String>(
      future: _getLocalPath(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final file = File(snapshot.data!);
          if (file.existsSync()) {
            return _buildContainer(FileImage(file));
          }
        }
        // Fallback to default asset while loading or if file is missing
        return _buildContainer(const AssetImage('assets/images/warm_garage.png'));
      },
    );
  }

  Widget _buildContainer(ImageProvider image) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: image,
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            const Color(0xFF2D1B0D).withValues(alpha: alpha),
            BlendMode.darken,
          ),
        ),
      ),
      child: child,
    );
  }

  Future<String> _getLocalPath() async {
    // If it is already an absolute path
    if (path.startsWith('/') || path.contains(':\\')) {
      return path;
    }
    // Otherwise assume it's in autoworld_photos
    final docs = await getApplicationDocumentsDirectory();
    return p.join(docs.path, 'autoworld_photos', path);
  }
}

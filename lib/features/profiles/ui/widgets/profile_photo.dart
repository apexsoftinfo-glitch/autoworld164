import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class ProfilePhoto extends StatelessWidget {
  final String? url;
  final double radius;
  final Widget? placeholder;
  final ImageProvider? memoryImage;

  const ProfilePhoto({
    this.url,
    this.radius = 40,
    this.placeholder,
    this.memoryImage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (memoryImage != null) {
      return _buildCircle(backgroundImage: memoryImage);
    }

    if (url == null || url!.isEmpty) {
      return _buildCircle(child: placeholder);
    }

    if (url!.startsWith('http')) {
      return _buildCircle(backgroundImage: NetworkImage(url!));
    }

    // Local file
    return FutureBuilder<String>(
      future: _getLocalPath(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final file = File(snapshot.data!);
          if (file.existsSync()) {
            return _buildCircle(backgroundImage: FileImage(file));
          }
        }
        return _buildCircle(child: placeholder);
      },
    );
  }

  Widget _buildCircle({ImageProvider? backgroundImage, Widget? child}) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white10,
        image: backgroundImage != null
            ? DecorationImage(image: backgroundImage, fit: BoxFit.cover)
            : null,
      ),
      child: backgroundImage == null
          ? (child ?? Icon(Icons.person, size: radius, color: Colors.white38))
          : null,
    );
  }

  Future<String> _getLocalPath() async {
    if (url!.startsWith('/') || url!.contains(':\\')) {
      return url!;
    }
    final docs = await getApplicationDocumentsDirectory();
    return p.join(docs.path, 'autoworld_photos', url);
  }
}

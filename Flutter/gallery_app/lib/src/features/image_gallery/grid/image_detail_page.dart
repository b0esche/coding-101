import 'package:flutter/material.dart';
import 'package:gallery_app/src/data/gallery_data.dart';

class ImageDetailPage extends StatelessWidget {
  final GalleryItem item;

  const ImageDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          item.imageTitle,
          style: TextStyle(color: Colors.grey.shade500),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            InteractiveViewer(
              child: Image.asset(item.imagePath, fit: BoxFit.contain),
            ),
            const SizedBox(height: 16),
            Text(
              item.imageDescription,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 12),
            Text(
              item.imageDate,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

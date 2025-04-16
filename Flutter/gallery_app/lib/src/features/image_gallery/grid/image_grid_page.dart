import 'package:flutter/material.dart';
import 'package:gallery_app/src/data/gallery_data.dart';
import 'package:gallery_app/src/features/image_gallery/grid/image_detail_page.dart';

class ImageGridPage extends StatelessWidget {
  const ImageGridPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = screenWidth / 3;

    return GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 1,
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      children: List.generate(galleryData.length, (index) {
        final item = galleryData[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ImageDetailPage(item: item)),
            );
          },
          child: Image.asset(
            item.imagePath,
            fit: BoxFit.cover,
            width: itemWidth,
            height: itemWidth,
          ),
        );
      }),
    );
  }
}

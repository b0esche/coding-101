import 'package:flutter/material.dart';
import 'package:gallery_app/src/features/image_gallery/grid/image_grid_page.dart';
import 'package:gallery_app/src/features/image_gallery/list/image_list_page.dart';

class ImagePage extends StatelessWidget {
  final bool listOrGrid;
  const ImagePage({required this.listOrGrid, super.key});

  @override
  Widget build(BuildContext context) {
    return listOrGrid ? ImageGridPage() : ImageListPage();
  }
}

import 'package:flutter/material.dart';
import 'package:gallery_app/gallery_data.dart';

class ImagePage extends StatelessWidget {
  const ImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: galleryData.length,
      itemBuilder: (context, index) {
        final item = galleryData[index];
        return Column(
          children: [
            InkWell(
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Image.asset(
                    item.imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    color: Color.fromARGB(125, 0, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.imageTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          item.imageDate,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              onTap: () {
                showDialog(
                  context: context,
                  builder:
                      (_) => Dialog(
                        insetPadding: const EdgeInsets.all(16),
                        backgroundColor: Colors.transparent,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.8,
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.9,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InteractiveViewer(
                                      child: Image.asset(
                                        item.imagePath,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      item.imageDescription,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                );
              },
            ),
          ],
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 24);
      },
    );
  }
}

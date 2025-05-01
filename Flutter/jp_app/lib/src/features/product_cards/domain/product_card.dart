import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jp_app/src/data/product_data.dart';
import 'package:jp_app/src/features/product_cards/domain/product_detail_bottomsheet.dart';
import 'package:jp_app/src/theme/palette.dart';

class ProductCard extends StatelessWidget {
  final int index;
  const ProductCard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    if (index < 0 || index >= productData.length) {
      return const SizedBox.shrink();
    }

    final product = productData[index];
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return ProductDetailBottomSheet(index: index);
          },
        );
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.07, 0.61, 1],
            colors: const [
              Color.fromARGB(152, 255, 255, 255),
              Color.fromARGB(255, 143, 140, 238),
              Color.fromARGB(255, 113, 93, 226),
            ],
          ),
          borderRadius: BorderRadius.circular(32.0),
          border: Border.all(
            color: const Color.fromARGB(113, 153, 153, 153),
            width: 1.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  product["imageUrl"],
                  height: 140.8,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                product["title"],
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                  color: Palette.jpWhite,
                ),
              ),
              const SizedBox(height: 2.0),
              Text(
                product["description"],
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                  color: Palette.jpWhite,
                ),
              ),
              const SizedBox(height: 18.0),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/currency.svg',
                    height: 14,
                    color: Palette.jpWhite,
                  ),
                  Text(
                    " ${product["price"].toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Palette.jpWhite,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.favorite, color: Colors.red, size: 20.0),
                  const SizedBox(width: 2.0),
                  Text(
                    product["likes"].toString(),
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Palette.jpWhite,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

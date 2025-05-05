import 'package:flutter/material.dart';
import 'package:jp_app/src/features/product_cards/presentation/product_card.dart';

class ProductListView extends StatelessWidget {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return ProductCard(index: index);
        },
      ),
    );
  }
}

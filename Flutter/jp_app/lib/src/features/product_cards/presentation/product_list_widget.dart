import 'package:flutter/material.dart';
import 'package:jp_app/src/features/product_cards/presentation/product_list_view.dart';

class ProductListWidget extends StatelessWidget {
  final Animation<double> productListAnimation;

  const ProductListWidget({super.key, required this.productListAnimation});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: productListAnimation,
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.65,
          bottom: MediaQuery.of(context).size.height * 0.05,
        ),
        child: const ProductListView(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:responsive_layout/src/data/consts/consts_color.dart';
import 'package:responsive_layout/src/data/consts/consts_style.dart';
import 'package:responsive_layout/src/data/models/product.dart';
import 'package:shimmer/shimmer.dart';

class MobilePortraitBody extends StatelessWidget {
  final List<Product> products;

  const MobilePortraitBody({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Palette.companyBlue,
        width: 240,
        elevation: 2,
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: List.generate(products.length, (index) {
              final product = products[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                padding: AppPad.padding2,
                decoration: BoxDecoration(
                  color: Colors.white.opac(0.1),
                  borderRadius: AppRad.radius1,
                ),
                child: Text(
                  product.productName,
                  style: TextStyle(color: Palette.glazedWhite, fontSize: 18),
                ),
              );
            }),
          ),
        ),
      ),
      backgroundColor: Palette.shadowGrey,

      body: Padding(
        padding: AppPad.padding2,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Center(
              child: Shimmer.fromColors(
                baseColor: Palette.companyBlue,
                highlightColor: Palette.concreteGrey,
                period: Duration(seconds: 5),
                child: Text(
                  "Trending Products",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.68,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(product: product);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRad.radius2,
      child: Container(
        decoration: BoxDecoration(
          color: Palette.royalAzure,
          boxShadow: [
            BoxShadow(
              color: Palette.primalBlack,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
          borderRadius: AppRad.radius2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    product.productImages.isNotEmpty
                        ? product.productImages.first
                        : 'https://via.placeholder.com/150',
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Palette.graphiteGrey.opac(0.6),
                        borderRadius: AppRad.radius1,
                      ),
                      child: Text(
                        product.amountInStock.toString(),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Palette.mintBreeze,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: AppPad.padding1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "€${product.productPrice.toStringAsFixed(2)}",
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Palette.mintBreeze),
                  ),
                  const SizedBox(height: 6),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Palette.glazedWhite,
                      backgroundColor: Palette.graphiteGrey,
                      minimumSize: const Size.fromHeight(32),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRad.radius1,
                      ),
                    ),
                    onPressed: () {},
                    child: const Text("Add to Cart"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

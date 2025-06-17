import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:responsive_layout/src/data/consts/consts_color.dart';
import 'package:responsive_layout/src/data/consts/consts_style.dart';
import 'package:responsive_layout/src/data/models/product.dart';

class MobilePortraitBody extends StatefulWidget {
  const MobilePortraitBody({super.key});

  @override
  State<MobilePortraitBody> createState() => _MobilePortraitBodyState();
}

class _MobilePortraitBodyState extends State<MobilePortraitBody> {
  late Future<List<Product>> _cocktailsFuture;

  @override
  void initState() {
    super.initState();
    _cocktailsFuture = fetchCocktails();
  }

  Future<List<Product>> fetchCocktails() async {
    const url = 'https://www.thecocktaildb.com/api/json/v1/1/random.php';
    final List<Product> list = [];
    for (int i = 0; i < 10; i++) {
      final res = await http.get(Uri.parse(url));
      final json = jsonDecode(res.body);
      final drink = json['drinks'][0];
      list.add(
        Product(
          productName: drink['strDrink'] ?? 'Unknown',
          productPrice: (5 + i).toDouble(),
          amountInStock: 18,
          productImages: [drink['strDrinkThumb']],
          productCategories: [],
          productDescription: "",
          productId: "",
          productSize: ProductSize.large,
          productTags: [],
          releaseDate: DateTime.now(),
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: _cocktailsFuture,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(child: Text('Fehler: ${snap.error}'));
        }
        final products = snap.data!;
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
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    padding: AppPad.padding2,
                    decoration: BoxDecoration(
                      color: Palette.glazedWhite.opac(0.1),
                      borderRadius: AppRad.radius1,
                    ),
                    child: Text(
                      product.productName,
                      style: TextStyle(
                        color: Palette.glazedWhite,
                        fontSize: 18,
                      ),
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
                const SizedBox(height: 50),
                Center(
                  child: Shimmer.fromColors(
                    baseColor: Palette.companyBlue,
                    highlightColor: Palette.concreteGrey,
                    period: const Duration(seconds: 5),
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.68,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                        ),
                    itemBuilder: (ctx, i) => ProductCard(product: products[i]),
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed:
                        () => setState(() {
                          _cocktailsFuture = fetchCocktails();
                        }),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        "load new cocktails",
                        style: TextStyle(color: Palette.glazedWhite),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
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
          gradient: LinearGradient(
            colors: [Palette.royalAzure, Palette.companyBlue.opac(0.2)],
            stops: [0.3, 1],
          ),
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
                          color: Palette.crimsonAlert,
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
                      color: Palette.shadowGrey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "€${product.productPrice.toStringAsFixed(2)}",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Palette.mintBreeze,
                      fontSize: 12,
                    ),
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

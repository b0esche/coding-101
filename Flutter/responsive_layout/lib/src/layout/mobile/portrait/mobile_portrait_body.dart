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
          amountInStock: drink['strAlcoholic'] == 'Alcoholic' ? 18 : 0,
          productImages: [drink['strDrinkThumb']],
          productCategories: [],
          productDescription: drink["strInstructionsDE"] ?? '',
          productID: "",
          productSize: ProductSize.large,
          productTags:
              List.generate(
                15,
                (i) => drink['strIngredient${i + 1}'],
              ).whereType<String>().toList(),
          releaseDate: DateTime.now(),
        ),
      );
    }
    return list;
  }

  Future<void> detailDialog(BuildContext ctx, Product product) {
    return showDialog(
      context: ctx,
      builder:
          (context) => AlertDialog(
            content: Column(
              spacing: 16,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                Text(
                  product.productName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(height: 8),
                Text(product.productTags.join(', ')),
                const SizedBox(height: 8),
                Text(product.productDescription),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "pop",
                    style: TextStyle(color: Palette.glazedWhite),
                  ),
                ),
              ],
            ),
          ),
    );
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
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        decoration: TextDecoration.underline,
                      ),
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
                    itemBuilder:
                        (ctx, i) => GestureDetector(
                          onTap: () => detailDialog(ctx, products[i]),
                          child: ProductCard(
                            product: products[i],
                            onViewDetails:
                                () => detailDialog(context, products[i]),
                          ),
                        ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _cocktailsFuture = fetchCocktails();
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 2.0, right: 2.0),
                      child: Text(
                        "load new cocktails",
                        style: TextStyle(
                          color: Palette.glazedWhite,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
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
  final VoidCallback onViewDetails;

  const ProductCard({
    super.key,
    required this.product,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRad.radius2,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Palette.royalAzure, Palette.companyBlue.opac(0.2)],
            stops: const [0.3, 1],
          ),
          boxShadow: [
            BoxShadow(
              color: Palette.primalBlack,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
          borderRadius: AppRad.radius2,
          border: Border.all(width: 2, color: Palette.concreteGrey.opac(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(product.productImages.first, fit: BoxFit.cover),
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
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                          color:
                              product.amountInStock == 18
                                  ? Palette.crimsonAlert
                                  : Palette.mintBreeze,
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
                    onPressed: onViewDetails,
                    child: const Text("View Details"),
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

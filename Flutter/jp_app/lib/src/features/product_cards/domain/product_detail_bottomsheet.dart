import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jp_app/src/data/product_data.dart';
import 'package:jp_app/src/theme/palette.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailBottomSheet extends StatefulWidget {
  final int index;

  const ProductDetailBottomSheet({Key? key, required this.index})
    : super(key: key);

  @override
  _ProductDetailBottomSheetState createState() =>
      _ProductDetailBottomSheetState();
}

class _ProductDetailBottomSheetState extends State<ProductDetailBottomSheet> {
  int _quantity = 1;
  String _selectedSize = 'Large';

  void _incrementQuantity() {
    setState(() {
      if (_quantity < 10) {
        _quantity++;
      }
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  double _getAdjustedPrice(double basePrice) {
    if (basePrice == 8.99) {
      switch (_selectedSize) {
        case 'Medium':
          return basePrice - 2;
        case 'Small':
          return basePrice - 4;
        default:
          return basePrice;
      }
    } else if (basePrice == 3.99) {
      switch (_selectedSize) {
        case 'Medium':
          return basePrice = 2.99;
        case 'Small':
          return basePrice = 1.99;
        default:
          return basePrice;
      }
    }
    return basePrice;
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> product = productData[widget.index];

    double imageTop = -290;
    if (product["imageUrl"] == "assets/grafiken/icecream_stick.png") {
      imageTop = -278;
    } else if (product["imageUrl"] == "assets/grafiken/icecream_cone.png") {
      imageTop = -270;
    } else if (product["imageUrl"] == "assets/grafiken/icecream.png") {
      imageTop = -282;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(235, 0, 0, 0).withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(32),
              ),
              border: Border.all(
                color: const Color.fromARGB(112, 133, 133, 133),
              ),
            ),
            padding: const EdgeInsets.only(
              left: 26.0,
              right: 26.0,
              bottom: 24.0,
              top: 140.0,
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: imageTop,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SizedBox(
                      height: 400,
                      child: Image.asset(
                        product["imageUrl"],
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: -128,
                  right: -20,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 151, 151, 151),
                        ),
                        shape: BoxShape.circle,
                        color: const Color.fromARGB(106, 129, 129, 129),
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.close,
                          color: Palette.jpWhite,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(36),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(
                              255,
                              1,
                              1,
                              1,
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Palette.jpWhite.o(0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    product["likes"].toString(),
                                    style: TextStyle(
                                      color: Palette.jpWhite,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                product["title"],
                                style: GoogleFonts.lobster(
                                  textStyle: TextStyle(
                                    fontSize: 28.0,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1,
                                    color: Palette.jpWhite,
                                  ),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                product["info"],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Palette.jpWhite,
                                  height: 1.4,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/currency.svg',
                                    height: 16,
                                    color: Palette.jpWhite,
                                  ),
                                  Text(
                                    " ${(_getAdjustedPrice(product["price"]))}",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w700,
                                      color: Palette.jpWhite,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Divider(color: Colors.white30),
                              const SizedBox(height: 24),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 10),
                                  Column(
                                    spacing: 4,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Ingredients",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Palette.jpWhite,
                                        ),
                                      ),
                                      SizedBox(),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/gluten.svg',
                                            height: 20,
                                            color: Palette.jpWhite,
                                          ),
                                          const SizedBox(width: 8),
                                          SvgPicture.asset(
                                            'assets/icons/sugar.svg',
                                            height: 20,
                                            color: Palette.jpWhite,
                                          ),
                                          const SizedBox(width: 8),
                                          SvgPicture.asset(
                                            'assets/icons/lowfat.svg',
                                            height: 20,
                                            color: Color.fromARGB(
                                              255,
                                              238,
                                              238,
                                              238,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          SvgPicture.asset(
                                            'assets/icons/kcal.svg',
                                            height: 20,
                                            color: Palette.jpWhite,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 80),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Reviews",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Palette.jpWhite,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Row(
                                            children: List.generate(5, (index) {
                                              return Icon(
                                                index <
                                                        product["rating"]
                                                            .floor()
                                                    ? Icons.star
                                                    : Icons.star_border,
                                                color: Palette.jpWhite,
                                                size: 18,
                                              );
                                            }),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            "${product["rating"].toStringAsFixed(1)}",
                                            style: TextStyle(
                                              color: Palette.jpWhite,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 12),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 56),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSizeSelector(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          spacing: 6,
                          children: [
                            Container(
                              height: 30,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(77, 149, 149, 149),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color.fromARGB(
                                    121,
                                    255,
                                    255,
                                    255,
                                  ),
                                ),
                              ),
                              child: IconButton(
                                onPressed: _decrementQuantity,
                                icon: Icon(
                                  Icons.remove,
                                  color: Palette.jpWhite,
                                  size: 14,
                                ),
                              ),
                            ),
                            Text(
                              _quantity.toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Palette.jpWhite,
                              ),
                            ),
                            Container(
                              height: 30,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(77, 149, 149, 149),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color.fromARGB(
                                    121,
                                    255,
                                    255,
                                    255,
                                  ),
                                ),
                              ),
                              child: IconButton(
                                onPressed: _incrementQuantity,
                                icon: Icon(
                                  Icons.add,
                                  color: Palette.jpWhite,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: Stack(
                        children: [
                          Shimmer.fromColors(
                            baseColor: Palette.jpPink,
                            highlightColor: Palette.jpOrange,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Palette.jpWhite,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              print(
                                'Added to order: ${product["title"]} x $_quantity, Size: $_selectedSize',
                              );
                              Navigator.of(context).pop();
                            },

                            style: ElevatedButton.styleFrom(
                              elevation: 2,
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: Palette.jpPink),
                              ),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              height: 48,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Add to order for ",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: Palette.jpWhite,
                                    ),
                                  ),
                                  SvgPicture.asset(
                                    'assets/icons/currency.svg',
                                    height: 14,
                                    color: Palette.jpWhite,
                                  ),
                                  Text(
                                    " ${(_getAdjustedPrice(product["price"]) * _quantity).toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w800,
                                      color: Palette.jpWhite,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSizeSelector() {
    final sizes = ['Small', 'Medium', 'Large'];

    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: const Color.fromARGB(135, 113, 113, 113),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(sizes.length * 2 - 1, (index) {
          if (index.isOdd) {
            return Container(width: 1, height: 20, color: Colors.white24);
          } else {
            final size = sizes[index ~/ 2];
            final bool isSelected = _selectedSize == size;
            return Container(
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? Colors.white.withOpacity(0.2)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _selectedSize = size;
                  });
                },
                style: TextButton.styleFrom(
                  foregroundColor: Palette.jpWhite,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 4,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  size,
                  style: TextStyle(
                    color: Palette.jpWhite,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 11,
                  ),
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}

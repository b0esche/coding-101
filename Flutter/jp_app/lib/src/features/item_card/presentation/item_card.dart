import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jp_app/src/theme/palette.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({super.key});

  @override
  Widget build(BuildContext context) {
    final double cardWidth = MediaQuery.of(context).size.width * 0.9;
    const double cardHeight = 250.0;

    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            left: (MediaQuery.of(context).size.width - cardWidth) / 2,
            child: ClipPath(
              clipper: CardClipper(),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 36, sigmaY: 36),
                child: Container(
                  width: cardWidth,
                  height: cardHeight,
                  color: Palette.jpWhite.o(0.05),
                  child: SvgPicture.asset(
                    'assets/details/cut_card.svg',
                    width: cardWidth,
                    height: cardHeight,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 24,
            left: 36,
            child: SizedBox(
              width: cardWidth - 170 - 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Angi's Yummy Burger",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                      color: Palette.jpWhite,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Delish vegan burger that tastes like heaven",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Palette.jpWhite.o(0.92),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const SizedBox(width: 2),
                      SvgPicture.asset(
                        'assets/icons/currency.svg',
                        height: 14,
                        color: Palette.jpWhite,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "13.99",
                        style: TextStyle(
                          fontSize: 16,
                          color: Palette.jpWhite,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 418,
            left: 44,
            child: SizedBox(
              height: 40,
              width: 100,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromARGB(255, 210, 167, 255),
                      ),
                      boxShadow: [
                        const BoxShadow(
                          color: Color.fromARGB(255, 243, 176, 225),
                          blurRadius: 15,
                          blurStyle: BlurStyle.inner,
                        ),
                        const BoxShadow(
                          color: Color.fromARGB(255, 142, 118, 178),
                          offset: Offset(0, 3),
                          blurStyle: BlurStyle.inner,
                          blurRadius: 24,
                        ),
                        BoxShadow(
                          blurRadius: 65,
                          blurStyle: BlurStyle.normal,
                          offset: const Offset(0, 30),
                          color: Palette.jpPink,
                        ),
                      ],
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 180, 143, 220),
                          Color.fromARGB(255, 143, 140, 238),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: Text(
                        'Add to Order',
                        style: TextStyle(
                          letterSpacing: -0.5,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w700,
                          color: Palette.jpWhite,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 15,
            right: 42,
            child: Row(
              children: [
                Image.asset("assets/grafiken/star.png"),
                const SizedBox(width: 4),
                Text(
                  "4.8",
                  style: TextStyle(color: Palette.jpWhite, fontSize: 13),
                ),
              ],
            ),
          ),
          Positioned(
            top: 22,
            right: 5,
            child: IgnorePointer(
              child: SizedBox(
                width: 240,
                height: 240,
                child: Image.asset(
                  'assets/grafiken/burger.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double cornerRadius = 36;

    final path = Path();
    path.moveTo(0, cornerRadius);
    path.quadraticBezierTo(0, 0, cornerRadius, 0);
    path.lineTo(size.width - cornerRadius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);
    path.lineTo(size.width, size.height - 55 - cornerRadius);
    path.quadraticBezierTo(
      size.width,
      size.height - 55,
      size.width - cornerRadius,
      size.height - 55,
    );
    path.lineTo(cornerRadius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - cornerRadius);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

import 'package:flutter/material.dart';
import 'package:jp_app/src/theme/palette.dart';

class WeRecommendWidget extends StatelessWidget {
  final Animation<double> weRecommendAnimation;

  const WeRecommendWidget({super.key, required this.weRecommendAnimation});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: weRecommendAnimation,
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.60,
          left: 16.0,
        ),
        child: Text(
          "We Recommend",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Palette.jpWhite,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Rating extends StatefulWidget {
  const Rating({super.key});

  @override
  State<Rating> createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  int rating = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          RatingStar(),
          RatingStar(),
          RatingStar(),
          RatingStar(),
          RatingStar(),
        ],
      ),
    );
  }
}

class RatingStar extends StatelessWidget {
  const RatingStar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(decoration: ShapeDecoration(shape: StarBorder.polygon()));
  }
}

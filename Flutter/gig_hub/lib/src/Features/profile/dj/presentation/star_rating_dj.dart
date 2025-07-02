import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:gig_hub/src/Features/profile/dj/presentation/profile_screen_dj.dart';
import 'package:gig_hub/src/Theme/palette.dart';

class UserStarRating extends StatelessWidget {
  const UserStarRating({super.key, required this.widget});

  final ProfileScreenDJ widget;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 140,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(12),
            topLeft: Radius.circular(12),
          ),
          color: Palette.primalBlack.o(0.7),
          border: Border(
            left: BorderSide(width: 2, color: Palette.gigGrey.o(0.6)),
            top: BorderSide(width: 2, color: Palette.gigGrey.o(0.6)),
            bottom: BorderSide(width: 2, color: Palette.gigGrey.o(0.6)),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 2, top: 2, bottom: 2),
          child: RatingStars(
            value: widget.dj.rating ?? 0,
            starBuilder:
                (index, color) => Icon(Icons.star, color: color, size: 18),
            starCount: 5,
            maxValue: 5,
            axis: Axis.vertical,
            angle: 15,
            starSpacing: 0,
            starSize: 18,
            valueLabelVisibility: false,
            animationDuration: const Duration(milliseconds: 350),
            starOffColor: Palette.shadowGrey,
            starColor: Palette.forgedGold,
          ),
        ),
      ),
    );
  }
}

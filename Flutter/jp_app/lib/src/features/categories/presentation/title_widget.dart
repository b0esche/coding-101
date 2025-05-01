import 'package:flutter/material.dart';
import 'package:jp_app/src/theme/palette.dart';

class TitleWidget extends StatelessWidget {
  final Animation<Offset> titleAnimation;

  const TitleWidget({Key? key, required this.titleAnimation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: titleAnimation,
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 16.0,
          left: 16.0,
        ),
        child: Text(
          "Choose Your Favorite Snack",
          style: TextStyle(
            fontSize: 30,
            letterSpacing: -1,
            fontWeight: FontWeight.w900,
            color: Palette.jpWhite,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:responsive_layout/src/data/consts/screen_dimensions.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobilePortraitBody,
    required this.mobileLandscapeBody,
    required this.tabletBody,
    required this.desktopBody,
  });
  final Widget mobilePortraitBody;
  final Widget mobileLandscapeBody;
  final Widget tabletBody;
  final Widget desktopBody;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        switch (constraints.maxWidth) {
          case > mobilePortraitWidth:
            return mobileLandscapeBody;
          case > mobileLandscapeWidth:
            return tabletBody;
          case > tabletWidth:
            return desktopBody;
          default:
            return mobilePortraitBody;
        }
      },
    );
  }
}

// AspectRatio
// https://www.youtube.com/watch?v=MrPJBAOzKTQ&t=313s
// https://www.youtube.com/watch?v=9bo1V9STW2c&pp=0gcJCYUJAYcqIYzv

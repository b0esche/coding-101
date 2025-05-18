import 'package:flutter/material.dart';

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
          case > 400:
            return mobileLandscapeBody;
          case > 800:
            return tabletBody;
          case > 1200:
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

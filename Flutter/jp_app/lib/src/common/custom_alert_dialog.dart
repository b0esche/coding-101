import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:jp_app/src/common/main_screen.dart';
import 'package:jp_app/src/data/splash_screen_state.dart' as splash_state;
import 'package:jp_app/src/theme/palette.dart';

class CustomAlertDialog extends StatefulWidget {
  final AnimationController pngAnimationController;
  const CustomAlertDialog({super.key, required this.pngAnimationController});

  @override
  State<CustomAlertDialog> createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(32.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: .0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(44, 0, 0, 0),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: const Color.fromARGB(112, 133, 133, 133),
                  ),
                ),
                padding: const EdgeInsets.only(
                  left: 24.0,
                  right: 24.0,
                  top: 32.0,
                  bottom: 32.0 + 40 + 10,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Feeling Snackish Today?',
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                        color: Palette.jpWhite,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Explore Angi\'s most popular snack selection and get instantly happy.',
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 13,
                        color: Palette.jpWhite,
                        height: 1.4,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.85 / 2 - 90,
            bottom: 20,
            child: Container(
              height: 40,
              width: 180,
              decoration: BoxDecoration(
                border: Border.all(color: Palette.jpPink),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 243, 176, 225),
                    blurRadius: 15,
                    blurStyle: BlurStyle.inner,
                  ),
                  BoxShadow(
                    color: const Color.fromARGB(255, 142, 118, 178),
                    offset: Offset(0, 3),
                    blurStyle: BlurStyle.inner,
                    blurRadius: 24,
                  ),
                  BoxShadow(
                    blurRadius: 90,
                    offset: Offset(0, 30),
                    color: Palette.jpPink,
                    blurStyle: BlurStyle.normal,
                  ),
                ],
                gradient: LinearGradient(
                  colors: [Palette.jpPink, Palette.jpOrange],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    splash_state.shouldKeepSplashScreenElements = true;
                    splash_state.showPinkShapeOnMainScreenNotifier.value = true;
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder:
                            (context, animation, secondaryAnimation) =>
                                const MainScreen(),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(10.0),
                  child: Center(
                    child: Text(
                      'Order Now',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Palette.jpWhite,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

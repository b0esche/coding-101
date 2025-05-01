import 'package:flutter/material.dart';
import 'package:jp_app/src/common/custom_alert_dialog.dart';
import 'package:jp_app/src/theme/palette.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _pngAnimationController;
  late Animation<Offset> _pngAnimation;
  late AnimationController _shapeAnimationController;
  bool _showPng = false;
  bool _showDialog = false;
  bool _showShape = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTextScrolling();
    });

    _shapeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _pngAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2400),
      vsync: this,
    )..forward();

    _pngAnimation = Tween<Offset>(
      begin: const Offset(-0.1, 1.0),
      end: Offset(0.12, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _pngAnimationController,
        curve: Curves.bounceInOut,
      ),
    );

    Future.delayed(const Duration(milliseconds: 950), () {
      setState(() {
        _showPng = true;
      });
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        _showDialog = true;
        _showShape = true;
      });
      _shapeAnimationController.forward();
      _showMyDialog(context);
    });
  }

  void _startTextScrolling() {
    Future.delayed(const Duration(milliseconds: 500), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 12),
        curve: Curves.linear,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pngAnimationController.dispose();
    _shapeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    const int itemCount = 9;
    const double horizontalPaddingFactor = 0.0;
    const double verticalSpacing = 28.0;
    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0
          ..color = Colors.white.withOpacity(0.2);
    final TextStyle textStyle = TextStyle(
      fontSize: screenHeight / 7.8,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.0,
      height: 0.52,
      foreground: paint,
    );
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Palette.bgGrey, Palette.bgBlue],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.7, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: List.generate(
                itemCount * 3,
                (index) => Padding(
                  padding: EdgeInsets.only(
                    left: screenWidth * horizontalPaddingFactor,
                    right: screenWidth * horizontalPaddingFactor,
                    bottom: verticalSpacing,
                  ),
                  child: Text(
                    "SNACK",
                    style: textStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          if (_showShape)
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -1),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: _shapeAnimationController,
                  curve: Curves.decelerate,
                ),
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: screenWidth,
                  child: Image.asset(
                    'assets/grafiken/vector_409.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
          if (_showPng)
            SlideTransition(
              position: _pngAnimation,
              child: Center(
                child: Transform.scale(
                  scale: 1.35,
                  child: Image.asset(
                    'assets/grafiken/cupcake_chick.png',
                    height: 500,
                  ),
                ),
              ),
            ),
          if (_showDialog) Container(),
        ],
      ),
    );
  }

  Future<Object?> _showMyDialog(BuildContext context) async {
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 1000),
      pageBuilder: (
        BuildContext buildContext,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: CustomAlertDialog(
              pngAnimationController: _pngAnimationController,
            ),
          ),
        );
      },
      transitionBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}

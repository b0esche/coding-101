import 'package:flutter/material.dart';
import 'package:jp_app/src/data/splash_screen_state.dart' as splash_state;
import 'package:jp_app/src/features/categories/presentation/title_widget.dart';
import 'package:jp_app/src/features/categories/presentation/category_selector.dart';
import 'package:jp_app/src/features/item_card/presentation/item_card_widget.dart';
import 'package:jp_app/src/features/product_cards/presentation/we_recommend.dart';
import 'package:jp_app/src/features/product_cards/presentation/product_list_widget.dart';
import 'package:jp_app/src/theme/palette.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late AnimationController _titleAnimationController;
  late Animation<Offset> _titleAnimation;
  late AnimationController _categoriesAnimationController;
  late Animation<Offset> _categoriesAnimation;
  late AnimationController _itemCardAnimationController;
  late Animation<double> _itemCardAnimation;
  late AnimationController _productListAnimationController;
  late Animation<double> _productListAnimation;
  late AnimationController _weRecommendAnimationController;
  late Animation<double> _weRecommendAnimation;

  String _selectedCategory = "All categories";

  @override
  void initState() {
    super.initState();

    _titleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();
    _titleAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _titleAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _categoriesAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();
    _categoriesAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _categoriesAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _itemCardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _itemCardAnimation = Tween<double>(begin: 0.0, end: 1).animate(
      CurvedAnimation(
        parent: _itemCardAnimationController,
        curve: Curves.linear,
      ),
    );
    Future.delayed(const Duration(milliseconds: 350), () {
      _itemCardAnimationController.forward();
    });

    _productListAnimationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _productListAnimation = Tween<double>(begin: 0.0, end: 1).animate(
      CurvedAnimation(
        parent: _productListAnimationController,
        curve: Curves.linear,
      ),
    );

    Future.delayed(const Duration(milliseconds: 550), () {
      _productListAnimationController.forward();
    });

    _weRecommendAnimationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _weRecommendAnimation = Tween<double>(begin: 0.0, end: 1).animate(
      CurvedAnimation(
        parent: _weRecommendAnimationController,
        curve: Curves.linear,
      ),
    );
    Future.delayed(const Duration(milliseconds: 550), () {
      _weRecommendAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _titleAnimationController.dispose();
    _categoriesAnimationController.dispose();
    _itemCardAnimationController.dispose();
    _productListAnimationController.dispose();
    _weRecommendAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (splash_state.shouldKeepSplashScreenElements)
            ..._buildSplashScreenBackground(context),
          TitleWidget(titleAnimation: _titleAnimation),
          CategorySelector(
            categoriesAnimation: _categoriesAnimation,
            selectedCategory: _selectedCategory,
            onCategorySelected: (String category) {
              setState(() {
                _selectedCategory = category;
              });
            },
          ),
          ItemCardWidget(itemCardAnimation: _itemCardAnimation),
          WeRecommendWidget(weRecommendAnimation: _weRecommendAnimation),
          ProductListWidget(productListAnimation: _productListAnimation),
        ],
      ),
    );
  }

  List<Widget> _buildSplashScreenBackground(BuildContext context) {
    return [
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
      Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Image.asset(
            'assets/grafiken/vector_409.png',
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
      SingleChildScrollView(
        controller: ScrollController(initialScrollOffset: 9 * 3 * 28.0),
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: List.generate(9 * 3, (index) {
            final screenHeight = MediaQuery.of(context).size.height;
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
            const double horizontalPaddingFactor = 0.0;
            const double verticalSpacing = 28.0;
            return Padding(
              padding: EdgeInsets.only(
                left:
                    MediaQuery.of(context).size.width * horizontalPaddingFactor,
                right:
                    MediaQuery.of(context).size.width * horizontalPaddingFactor,
                bottom: verticalSpacing,
              ),
              child: Text(
                "SNACK",
                style: textStyle,
                textAlign: TextAlign.center,
              ),
            );
          }),
        ),
      ),
    ];
  }
}

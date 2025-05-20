import 'package:flutter/material.dart';
import 'package:responsive_layout/src/data/database/database_repository.dart';
import 'package:responsive_layout/src/data/database/mock_database_repository.dart';
import 'package:responsive_layout/src/data/models/product.dart';
import 'package:responsive_layout/src/layout/desktop/desktop_body.dart';
import 'package:responsive_layout/src/layout/mobile/landscape/mobile_landscape_body.dart';
import 'package:responsive_layout/src/layout/mobile/portrait/mobile_portrait_body.dart';
import 'package:responsive_layout/src/layout/responsive_layout.dart';
import 'package:responsive_layout/src/layout/tablet/tablet_body.dart';
import 'package:responsive_layout/src/layout/theme/light_theme.dart';
import 'package:responsive_layout/src/layout/theme/dark_theme.dart';

class App extends StatelessWidget {
  final List<Product> products;
  final DatabaseRepository repo = MockDatabaseRepository();
  App({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Responsive Layout Template",
      debugShowCheckedModeBanner: true,
      themeMode: ThemeMode.system,
      theme: lightTheme,
      darkTheme: darkTheme,
      // routes: ,
      home: ResponsiveLayout(
        mobilePortraitBody: MobilePortraitBody(products: products),
        mobileLandscapeBody: MobileLandscpaeBody(),
        tabletBody: TabletBody(),
        desktopBody: DesktopBody(),
      ),
    );
  }
}

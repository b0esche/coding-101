import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/navigation_provider.dart';
import '../pages/home_page.dart';
import '../pages/contribute_page.dart';
import '../pages/qa_page.dart';
import '../pages/portfolio_page.dart';
import '../pages/impressum_page.dart';
import '../widgets/custom_navigation_bar.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navigationProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(navigationProvider.currentPageTitle),
            elevation: 2,
          ),
          body: _getCurrentPage(navigationProvider.currentPage),
          bottomNavigationBar: const CustomNavigationBar(),
        );
      },
    );
  }

  Widget _getCurrentPage(AppPage currentPage) {
    switch (currentPage) {
      case AppPage.home:
        return const HomePage();
      case AppPage.contribute:
        return const ContributePage();
      case AppPage.qa:
        return const QAPage();
      case AppPage.portfolio:
        return const PortfolioPage();
      case AppPage.impressum:
        return const ImpressumPage();
    }
  }
}

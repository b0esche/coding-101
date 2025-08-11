import 'package:flutter/material.dart';

enum AppPage { home, contribute, qa, impressum, portfolio }

class NavigationProvider with ChangeNotifier {
  AppPage _currentPage = AppPage.home;

  AppPage get currentPage => _currentPage;

  void setPage(AppPage page) {
    _currentPage = page;
    notifyListeners();
  }

  String get currentPageTitle {
    switch (_currentPage) {
      case AppPage.home:
        return 'GigHub';
      case AppPage.contribute:
        return 'Contribute';
      case AppPage.qa:
        return 'Q&A';
      case AppPage.impressum:
        return 'Impressum';
      case AppPage.portfolio:
        return 'Portfolio';
    }
  }
}

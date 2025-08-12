import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:go_router/go_router.dart';
import 'theme/app_theme.dart';
import 'pages/home_page.dart';
import 'pages/contribute_page.dart';
import 'pages/qa_page.dart';
import 'pages/portfolio_page.dart';
import 'pages/impressum_page.dart';
import 'widgets/custom_navigation_bar.dart';

void main() {
  // Use hash-based URL strategy for web
  setUrlStrategy(const HashUrlStrategy());
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GigHub web',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}

// Router configuration with hash routing
final _router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/contribute',
          name: 'contribute',
          builder: (context, state) => const ContributePage(),
        ),
        GoRoute(
          path: '/qa',
          name: 'qa',
          builder: (context, state) => const QAPage(),
        ),
        GoRoute(
          path: '/portfolio',
          name: 'portfolio',
          builder: (context, state) => const PortfolioPage(),
        ),
        GoRoute(
          path: '/impressum',
          name: 'impressum',
          builder: (context, state) => const ImpressumPage(),
        ),
      ],
    ),
  ],
);

class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_getPageTitle(context)), elevation: 2),
      body: child,
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }

  String _getPageTitle(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    switch (location) {
      case '/':
        return 'GigHub';
      case '/contribute':
        return 'Contribute';
      case '/qa':
        return 'Q&A';
      case '/portfolio':
        return 'Portfolio';
      case '/impressum':
        return 'Impressum';
      default:
        return 'GigHub';
    }
  }
}

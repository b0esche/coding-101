import 'package:gig_hub/src/Data/app_imports.dart';

class RouteObserverProvider extends InheritedWidget {
  final RouteObserver<PageRoute> observer;
  const RouteObserverProvider({
    required this.observer,
    required super.child,
    super.key,
  });

  static RouteObserver<PageRoute> of(BuildContext context) {
    final RouteObserverProvider? provider =
        context.dependOnInheritedWidgetOfExactType<RouteObserverProvider>();
    assert(provider != null, 'No RouteObserverProvider found in context');
    return provider!.observer;
  }

  @override
  bool updateShouldNotify(RouteObserverProvider oldWidget) =>
      observer != oldWidget.observer;
}

class App extends StatelessWidget {
  final GlobalKey<NavigatorState>? navigatorKey;
  const App({super.key, this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthRepository>();
    final db = context.watch<DatabaseRepository>();
    final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
    return RouteObserverProvider(
      observer: routeObserver,
      child: MaterialApp(
        navigatorKey: navigatorKey,
        navigatorObservers: [routeObserver],
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: StreamBuilder(
          stream: auth.authStateChanges(),
          builder: (context, authSnap) {
            if (authSnap.connectionState == ConnectionState.waiting) {
              return Scaffold(
                backgroundColor: Palette.primalBlack,
                body: Center(
                  child: CircularProgressIndicator(
                    color: Palette.forgedGold,
                    strokeWidth: 1.65,
                  ),
                ),
              );
            }

            final fbUser = authSnap.data;
            if (fbUser == null) {
              return LoginScreen();
            }

            return FutureBuilder<AppUser>(
              future: db.getCurrentUser(),
              builder: (context, userSnap) {
                if (userSnap.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                    backgroundColor: Palette.primalBlack,
                    body: Center(
                      child: CircularProgressIndicator(
                        color: Palette.forgedGold,
                        strokeWidth: 1.65,
                      ),
                    ),
                  );
                }

                if (userSnap.hasError || userSnap.data == null) {
                  return LoginScreen();
                }
                if (authSnap.connectionState == ConnectionState.done) {
                  return MainScreen(initialUser: userSnap.data!);
                }
                return MainScreen(initialUser: userSnap.data!);
              },
            );
          },
        ),
      ),
    );
  }
}

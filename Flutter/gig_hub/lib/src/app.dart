import 'package:gig_hub/src/Data/app_imports.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthRepository>();
    final db = context.watch<DatabaseRepository>();
    return MaterialApp(
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
                child: CircularProgressIndicator(color: Palette.forgedGold),
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
                    child: CircularProgressIndicator(color: Palette.forgedGold),
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
    );
  }
}

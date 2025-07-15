import 'package:gig_hub/src/Common/main_screen.dart';
import 'package:gig_hub/src/Data/app_imports.dart';
import 'package:gig_hub/src/Data/auth_repository.dart';
import 'package:gig_hub/src/Features/auth/sign_in_screen.dart';
import 'package:gig_hub/src/Theme/app_theme.dart';

class App extends StatelessWidget {
  final DatabaseRepository db;
  final AuthRepository auth;

  const App({super.key, required this.db, required this.auth});

  @override
  Widget build(BuildContext context) {
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
            return LoginScreen(db: db, auth: auth);
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
                return LoginScreen(db: db, auth: auth);
              }
              if (authSnap.connectionState == ConnectionState.done) {
                return MainScreen(
                  db: db,
                  auth: auth,
                  initialUser: userSnap.data!,
                );
              }
              return MainScreen(
                db: db,
                auth: auth,
                initialUser: userSnap.data!,
              );
            },
          );
        },
      ),
    );
  }
}

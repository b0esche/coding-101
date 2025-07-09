import 'package:flutter/material.dart';
import 'package:gig_hub/src/Common/main_screen.dart';
import 'package:gig_hub/src/Common/settings_screen.dart';
import 'package:gig_hub/src/Data/app_imports.dart';
import 'package:gig_hub/src/Data/auth_repository.dart';
import 'package:gig_hub/src/Features/auth/sign_in_screen.dart';
import 'package:gig_hub/src/Features/profile/dj/presentation/profile_screen_dj.dart';
import 'package:gig_hub/src/Features/profile/booker/presentation/profile_screen_booker.dart';
import 'package:gig_hub/src/Features/chat/presentation/chat_list_screen.dart';
import 'package:gig_hub/src/Theme/app_theme.dart';

class App extends StatelessWidget {
  final DatabaseRepository repo;
  final AuthRepository auth;

  const App({super.key, required this.repo, required this.auth});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        return MaterialApp(
          key: Key(snapshot.data?.uid ?? 'no-user'),
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.light,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,

          home:
              snapshot.hasData
                  ? FutureBuilder<AppUser>(
                    future: repo.getCurrentUser(),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Scaffold(
                          backgroundColor: Palette.primalBlack,
                          body: Center(
                            child: CircularProgressIndicator(
                              color: Palette.forgedGold,
                            ),
                          ),
                        );
                      }

                      if (userSnapshot.hasError || userSnapshot.data == null) {
                        return Scaffold(
                          body: Center(
                            child: Text("Fehler beim Laden des Benutzers"),
                          ),
                        );
                      }

                      final user = userSnapshot.data!;
                      return MainScreen(
                        repo: repo,
                        auth: auth,
                        initialUser: user,
                      );
                    },
                  )
                  : LoginScreen(repo: repo, auth: auth),

          onGenerateRoute: (settings) {
            switch (settings.name) {
              case ProfileScreenDJ.routeName:
                final args = settings.arguments;
                if (args is ProfileScreenDJArgs) {
                  return MaterialPageRoute(
                    builder:
                        (context) => ProfileScreenDJ(
                          currentUser: args.currentUser,
                          dj: args.dj,
                          repo: args.repo,
                          showChatButton: args.showChatButton,
                          showEditButton: args.showEditButton,
                        ),
                  );
                }
                return _errorRoute("Couldn’t find DJ profile!");

              case ProfileScreenBooker.routeName:
                final args = settings.arguments;
                if (args is ProfileScreenBookerArgs) {
                  return MaterialPageRoute(
                    builder:
                        (context) => ProfileScreenBooker(
                          booker: args.booker,
                          repo: args.repo,
                          showEditButton: args.showEditButton,
                        ),
                  );
                }
                return _errorRoute("Couldn’t find booker profile!");

              case ChatScreen.routeName:
                final args = settings.arguments;
                if (args is ChatScreenArgs) {
                  return MaterialPageRoute(
                    builder:
                        (context) => ChatScreen(
                          chatPartner: args.chatPartner,
                          repo: args.repo,
                          currentUser: args.currentUser,
                        ),
                  );
                }
                return _errorRoute("Couldn’t load chat!");

              case ChatListScreen.routeName:
                final args = settings.arguments;
                if (args is ChatListScreenArgs) {
                  return MaterialPageRoute(
                    builder:
                        (context) => ChatListScreen(
                          repo: args.repo,
                          currentUser: args.currentUser,
                        ),
                  );
                }
                return _errorRoute("Couldn’t load chats!");

              default:
                return null;
            }
          },

          routes: {
            '/settings': (context) => SettingsScreen(repo: repo, auth: auth),
          },
        );
      },
    );
  }

  MaterialPageRoute _errorRoute(String message) {
    return MaterialPageRoute(
      builder:
          (context) => Scaffold(
            backgroundColor: Palette.primalBlack,
            body: Center(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ),
    );
  }
}

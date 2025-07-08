import 'package:flutter/material.dart';
import 'package:gig_hub/src/Common/main_screen.dart';
import 'package:gig_hub/src/Common/settings_screen.dart';
import 'package:gig_hub/src/Data/app_imports.dart';
import 'package:gig_hub/src/Data/auth_repository.dart';
import 'package:gig_hub/src/Features/auth/sign_in_screen.dart';
import 'package:gig_hub/src/Features/profile/dj/presentation/profile_screen_dj.dart';
import 'package:gig_hub/src/Features/profile/booker/presentation/profile_screen_booker.dart';
import 'package:gig_hub/src/Theme/app_theme.dart';
import 'package:gig_hub/src/Data/database_repository.dart';
import 'package:gig_hub/src/Features/chat/presentation/chat_screen.dart';
import 'package:gig_hub/src/Features/chat/presentation/chat_list_screen.dart';

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
          key: Key(snapshot.data?.uid ?? 'no user'),
          debugShowCheckedModeBanner: true,
          themeMode: ThemeMode.system,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home:
              snapshot.hasData
                  ? FutureBuilder<AppUser>(
                    future: repo.getCurrentUser(),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Scaffold(
                          body: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (userSnapshot.hasError) {
                        // Log den Fehler für Entwicklung
                        print(
                          "❌ Fehler beim Laden des Benutzers: ${userSnapshot.error}",
                        );

                        return const Scaffold(
                          body: Center(
                            child: Text(
                              '❌ Fehler: Benutzer konnte nicht geladen werden.\nBitte erneut versuchen.',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }

                      final user = userSnapshot.data;
                      if (user == null) {
                        print("❌ Benutzerobjekt ist null");
                        return const Scaffold(
                          body: Center(
                            child: Text("Benutzerdaten nicht gefunden."),
                          ),
                        );
                      }

                      // Wenn alles klappt, MainScreen starten
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
                    builder: (context) {
                      return ProfileScreenDJ(
                        dj: args.dj,
                        repo: args.repo,
                        showChatButton: args.showChatButton,
                        showEditButton: args.showEditButton,
                      );
                    },
                  );
                }
                return MaterialPageRoute(
                  builder:
                      (context) => const Text('Error: Couldn\'t find profile!'),
                );
              case ProfileScreenBooker.routeName:
                final args = settings.arguments;
                if (args is ProfileScreenBookerArgs) {
                  return MaterialPageRoute(
                    builder: (context) {
                      return ProfileScreenBooker(
                        booker: args.booker,
                        repo: args.repo,
                        showEditButton: args.showEditButton,
                      );
                    },
                  );
                }
                return MaterialPageRoute(
                  builder:
                      (context) => const Text('Error: Couldn\'t find profile!'),
                );

              case ChatScreen.routeName:
                final args = settings.arguments;
                if (args is ChatScreenArgs) {
                  return MaterialPageRoute(
                    builder: (context) {
                      return ChatScreen(
                        chatPartner: args.chatPartner,
                        repo: args.repo,
                        currentUser: args.currentUser,
                      );
                    },
                  );
                }
                return MaterialPageRoute(
                  builder:
                      (context) => const Text('Error: Couldn\'t load chat!'),
                );

              case ChatListScreen.routeName:
                final args = settings.arguments;
                if (args is ChatListScreenArgs) {
                  return MaterialPageRoute(
                    builder: (context) {
                      return ChatListScreen(
                        repo: args.repo,
                        currentUser: args.currentUser,
                      );
                    },
                  );
                }
                return MaterialPageRoute(
                  builder:
                      (context) => const Text('Error: Couldn\'t load chats!'),
                );

              default:
                return null;
            }
          },
          routes: {
            '/main':
                (context) => MainScreen(
                  repo: repo,
                  auth: auth,
                  initialUser: snapshot.data as AppUser,
                ),
            '/settings': (context) => SettingsScreen(repo: repo, auth: auth),
          },
        );
      },
    );
  }
}

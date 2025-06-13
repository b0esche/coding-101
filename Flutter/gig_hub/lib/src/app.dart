import 'package:flutter/material.dart';
import 'package:gig_hub/src/Features/auth/sign_in_screen.dart';
import 'package:gig_hub/src/Theme/app_theme.dart';
import 'package:gig_hub/src/Data/database_repository.dart';

class App extends StatelessWidget {
  final DatabaseRepository repo;
  const App({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: LoginScreen(repo: repo),
      // routes:, TODO: named routes für bessere navigation
    );
  }
}

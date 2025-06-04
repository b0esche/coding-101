import 'package:flutter/material.dart';
import 'package:gig_hub/src/Features/profile/dj/presentation/profile_screen_dj.dart';

abstract class AppUser {
  final String userId;
  final String name;
  String email;
  final String headUrl;
  final String avatarUrl;
  final String city;
  final String about;
  final String info;
  final double? rating;

  AppUser({
    required this.userId,
    required this.name,
    required this.email,
    required this.headUrl,
    required this.avatarUrl,
    required this.city,
    required this.about,
    required this.info,
    this.rating,
  });

  void showProfile(
    BuildContext context,
    dynamic repo,
    bool showChatButton, {
    AppUser? currentUser,
  });

  void updateEmail(AppUser? currentUser, String newEmail) {
    email = newEmail;
  }
}

class DJ extends AppUser {
  final List<String> genres;
  final int bpmMin;
  final int bpmMax;
  final String set1Url;
  final String set2Url;

  DJ({
    required this.genres,
    required super.headUrl,
    required super.avatarUrl,
    required this.bpmMin,
    required this.bpmMax,
    required super.about,
    required this.set1Url,
    required this.set2Url,
    required super.info,
    super.rating,
    required super.userId,
    required super.name,
    required super.email,
    required super.city,
  });

  @override
  void showProfile(
    BuildContext context,
    dynamic repo,
    showChatButton, {
    AppUser? currentUser,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => ProfileScreenDJ(
              dj: this,
              repo: repo,
              showChatButton: showChatButton,
            ),
      ),
    );
  }
}

class Booker extends AppUser {
  final List<String> mediaUrl;
  final String type;

  Booker({
    required super.headUrl,
    required super.avatarUrl,
    required super.city,
    required super.about,
    required super.info,
    super.rating,
    required this.type,
    required this.mediaUrl,
    required super.userId,
    required super.name,
    required super.email,
  });

  @override
  void showProfile(
    BuildContext context,
    dynamic repo,
    showChatButton, {
    AppUser? currentUser,
  }) {
    debugPrint('Profil für Booker $name anzeigen (noch nicht implementiert)');
  }
}

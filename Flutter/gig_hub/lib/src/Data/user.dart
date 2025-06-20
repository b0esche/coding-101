import 'package:flutter/material.dart';
import 'package:gig_hub/src/Features/profile/dj/presentation/profile_screen_dj.dart';

abstract class AppUser {
  final String userId, headUrl, avatarUrl;
  String name, email, about, info, city;
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

  Future<void> showProfile(
    BuildContext context,
    dynamic repo,
    bool showChatButton,
    bool showEditButton, {
    AppUser? currentUser,
  });

  void updateEmail(AppUser? currentUser, String newEmail) {
    email = newEmail;
  }
}

class DJ extends AppUser {
  final List<String> genres;
  int bpmMin, bpmMax;
  String set1Url, set2Url;
  final List<String>? mediaUrl;

  DJ({
    required this.genres,
    required super.headUrl,
    required super.avatarUrl,
    required this.bpmMin,
    required this.bpmMax,
    required super.about,
    required this.set1Url,
    required this.set2Url,
    required this.mediaUrl,
    required super.info,
    super.rating,
    required super.userId,
    required super.name,
    required super.email,
    required super.city,
  });
  @override
  Future<void> showProfile(
    BuildContext context,
    dynamic repo,
    bool showChatButton,
    bool showEditButton, {
    AppUser? currentUser,
    void Function(DJ updatedDj)? onProfileUpdated,
  }) async {
    final updatedDj = await Navigator.of(context).push<DJ>(
      MaterialPageRoute(
        builder:
            (context) => ProfileScreenDJ(
              dj: this,
              repo: repo,
              showChatButton: showChatButton,
              showEditButton: showEditButton,
            ),
      ),
    );

    if (updatedDj != null && onProfileUpdated != null) {
      onProfileUpdated(updatedDj);
    }
  }
}

class Booker extends AppUser {
  final List<String>? mediaUrl;
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
  Future<void> showProfile(
    BuildContext context,
    dynamic repo,
    showChatButton,
    showEditButton, {
    AppUser? currentUser,
  }) {
    debugPrint('Profil für Booker $name anzeigen (noch nicht implementiert)');
    throw ();
  }
}

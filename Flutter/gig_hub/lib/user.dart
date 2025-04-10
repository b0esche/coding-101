import 'package:gig_hub/genre_bubble.dart';

import 'database_repository.dart';

enum UserType { dj, booker }

abstract class User {
  final String userId;
  final String name;
  final String email;
  final UserType userType;
  final MockDatabaseRepository repo;

  User({
    required this.userId,
    required this.name,
    required this.email,
    required this.userType,
    required this.repo,
  }) {
    repo.addUser(this);
  }

  void showProfile();
  void editProfile();
}

class DJ extends User {
  final String headUrl;
  final String city;
  final String about;
  final String set1Url;
  final String set2Url;
  final String info;
  final List<GenreBubble> genres;
  final int bpmMin;
  final int bpmMax;
  final double? rating;

  DJ({
    required this.headUrl,
    required this.city,
    required this.about,
    required this.set1Url,
    required this.set2Url,
    required this.info,
    required this.genres,
    required this.bpmMin,
    required this.bpmMax,
    this.rating,
    required super.userId,
    required super.name,
    required super.email,
    required super.userType,
    required super.repo,
  });

  @override
  String toString() {
    return "User_DJ: $userId, $name, $city, $email";
  }

  @override
  void showProfile() {
    print(headUrl);
    print("${rating ?? ""}");
    print(name);
    print(city);
    print("$bpmMin - $bpmMax BPM");
    print(genres.join(", "));
    print("About: $about");
    print("Set 1: $set1Url");
    print("Set 2: $set2Url");
    print("Info: $info");
  }

  @override
  void editProfile() {}
}

class Booker extends User {
  final String headUrl;
  final String city;
  final String type;
  final String about;
  final String info;
  final List<String> mediaUrl;
  final double? rating;

  Booker({
    required this.headUrl,
    required this.city,
    required this.type,
    required this.about,
    required this.info,
    required this.mediaUrl,
    this.rating,
    required super.userId,
    required super.name,
    required super.email,
    required super.userType,
    required super.repo,
  });

  @override
  String toString() {
    return "User_Booker: $userId, $name, $city, $email";
  }

  @override
  void showProfile() {
    print(headUrl);
    print("${rating ?? ""}");
    print(name);
    print(city);
    print(type);
    print("About: $about");
    print(mediaUrl[0]);
    print("Info: $info");
  }

  @override
  void editProfile() {}
}

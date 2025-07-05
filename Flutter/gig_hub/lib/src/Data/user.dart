enum UserType { guest, dj, booker }

abstract class AppUser {
  final String id;
  final UserType type;

  AppUser({required this.id, required this.type});
}

class Guest extends AppUser {
  final List<String>? favoriteUIds;
  Guest({required super.id, required this.favoriteUIds})
    : super(type: UserType.guest);
}

class DJ extends AppUser {
  final List<String> genres, streamingUrls;
  final int bpmMin, bpmMax;
  final String name, city, about, info, headImageUrl, avatarImageUrl;
  List<String> mediaImageUrls, favoriteUIds;
  final double userRating;

  DJ({
    required super.id,
    required this.avatarImageUrl,
    required this.headImageUrl,
    required this.name,
    required this.city,
    required this.about,
    required this.info,
    required this.genres,
    required this.bpmMin,
    required this.bpmMax,
    required this.streamingUrls,
    this.userRating = 0.0,
    this.mediaImageUrls = const [],
    this.favoriteUIds = const [],
  }) : super(type: UserType.dj);
}

class Booker extends AppUser {
  final List<String> mediaImageUrls, favoriteUIds;
  final String name, city, about, info, headImageUrl, avatarImageUrl;
  final double userRating;

  Booker({
    required super.id,
    required this.avatarImageUrl,
    required this.headImageUrl,
    required this.name,
    required this.city,
    required this.about,
    required this.info,
    this.userRating = 0.0,
    this.mediaImageUrls = const [],
    this.favoriteUIds = const [],
  }) : super(type: UserType.booker);
}

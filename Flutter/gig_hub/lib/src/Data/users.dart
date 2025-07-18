enum UserType { guest, dj, booker }

abstract class AppUser {
  final String id;
  final UserType type;

  const AppUser({required this.id, required this.type});

  factory AppUser.fromJson(String id, Map<String, dynamic> json) {
    final typeString = json['type'] as String?;
    final type = UserType.values.firstWhere(
      (e) => e.name == typeString,
      orElse: () => throw Exception('unknown user type: $typeString'),
    );

    switch (type) {
      case UserType.guest:
        return Guest.fromJson(id, json);
      case UserType.dj:
        return DJ.fromJson(id, json);
      case UserType.booker:
        return Booker.fromJson(id, json);
    }
  }
}

class Guest extends AppUser {
  final List<String> favoriteUIds;

  const Guest({required super.id, this.favoriteUIds = const []})
    : super(type: UserType.guest);

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'favoriteUIds': favoriteUIds,
  };

  factory Guest.fromJson(String id, Map<String, dynamic> json) => Guest(
    id: id,
    favoriteUIds: List<String>.from(json['favoriteUIds'] ?? []),
  );
}

class DJ extends AppUser {
  String name, city, about, info, headImageUrl, avatarImageUrl;

  final double userRating;

  final List<String> mediaImageUrls,
      favoriteUIds,
      genres,
      streamingUrls,
      trackTitles;

  List<int> bpm;

  DJ({
    required super.id,
    required this.avatarImageUrl,
    required this.headImageUrl,
    required this.name,
    required this.city,
    required this.about,
    required this.info,
    required this.genres,
    required this.bpm,
    required this.streamingUrls,
    required this.trackTitles,
    this.userRating = 0.0,
    this.mediaImageUrls = const [],
    this.favoriteUIds = const [],
  }) : super(type: UserType.dj);

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'avatarImageUrl': avatarImageUrl,
    'headImageUrl': headImageUrl,
    'name': name,
    'city': city,
    'about': about,
    'info': info,
    'genres': genres,
    'bpm': bpm,
    'streamingUrls': streamingUrls,
    'trackTitles': trackTitles,
    'userRating': userRating,
    'mediaImageUrls': mediaImageUrls,
    'favoriteUIds': favoriteUIds,
  };

  factory DJ.fromJson(String id, Map<String, dynamic> json) => DJ(
    id: id,
    avatarImageUrl: json['avatarImageUrl'],
    headImageUrl: json['headImageUrl'],
    name: json['name'],
    city: json['city'],
    about: json['about'],
    info: json['info'],
    genres: List<String>.from(json['genres'] ?? []),
    bpm: List<int>.from(json['bpm'] ?? []),
    streamingUrls: List<String>.from(json['streamingUrls'] ?? []),
    trackTitles: List<String>.from(json['trackTitles'] ?? []),
    userRating: (json['userRating'] ?? 0.0).toDouble(),
    mediaImageUrls: List<String>.from(json['mediaImageUrls'] ?? []),
    favoriteUIds: List<String>.from(json['favoriteUIds'] ?? []),
  );
}

class Booker extends AppUser {
  String name, city, about, info, headImageUrl, avatarImageUrl;

  final double userRating;

  final List<String> mediaImageUrls, favoriteUIds;

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

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'avatarImageUrl': avatarImageUrl,
    'headImageUrl': headImageUrl,
    'name': name,
    'city': city,
    'about': about,
    'info': info,
    'userRating': userRating,
    'mediaImageUrls': mediaImageUrls,
    'favoriteUIds': favoriteUIds,
  };

  factory Booker.fromJson(String id, Map<String, dynamic> json) => Booker(
    id: id,
    avatarImageUrl: json['avatarImageUrl'],
    headImageUrl: json['headImageUrl'],
    name: json['name'],
    city: json['city'],
    about: json['about'],
    info: json['info'],
    userRating: (json['userRating'] ?? 0.0).toDouble(),
    mediaImageUrls: List<String>.from(json['mediaImageUrls'] ?? []),
    favoriteUIds: List<String>.from(json['favoriteUIds'] ?? []),
  );
}

extension AppUserView on AppUser {
  String get displayName {
    if (this is DJ) return (this as DJ).name;
    if (this is Booker) return (this as Booker).name;
    return 'unknown user';
  }

  String get avatarUrl {
    if (this is DJ) return (this as DJ).avatarImageUrl;
    if (this is Booker) return (this as Booker).avatarImageUrl;
    return 'https://picsum.photos/106';
  }
}

abstract class User {
  final String userId;
  final String name;
  final String email;
  final String userType;

  User(
      {required this.userId,
      required this.name,
      required this.email,
      required this.userType});

  void showProfile();
  void editProfile();
}

class DJ extends User {
  final List<String> genres;
  final String headUrl;
  final String city;
  final String bpm;
  final String about;
  final String set1Url;
  final String set2Url;
  final String info;
  final double? rating;

  DJ(
      {required this.genres,
      required this.headUrl,
      required this.city,
      required this.bpm,
      required this.about,
      required this.set1Url,
      required this.set2Url,
      required this.info,
      this.rating,
      required super.userId,
      required super.name,
      required super.email,
      required super.userType});

  @override
  void showProfile() {}

  @override
  void editProfile() {}
}

class Booker extends User {
  final String headUrl;
  final String city;
  final String type;
  final String about;
  final String info;
  final double? rating;
  final List<String> mediaUrl;

  Booker(
      {required this.headUrl,
      required this.city,
      required this.type,
      required this.about,
      required this.info,
      this.rating,
      required this.mediaUrl,
      required super.userId,
      required super.name,
      required super.email,
      required super.userType});

  @override
  void showProfile() {}

  @override
  void editProfile() {}
}

class UserProfileBooker {
  final String name;
  final String headUrl;
  final String city;
  final String type;
  final String about;
  final String info;
  final double? rating;
  final List<String> media;

  UserProfileBooker(
      {required this.name,
      required this.headUrl,
      required this.city,
      required this.type,
      required this.about,
      required this.info,
      this.rating,
      required this.media});
}

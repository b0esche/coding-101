class UserProfileDj {
  final String name;
  final String headUrl;
  final String city;
  final String bpm;
  final String about;
  final String set1Url;
  final String set2Url;
  final String info;
  final double? rating;
  final List<String> genres;

  UserProfileDj(
      {required this.name,
      required this.headUrl,
      required this.city,
      required this.bpm,
      required this.about,
      required this.set1Url,
      required this.set2Url,
      required this.info,
      this.rating,
      required this.genres});
}

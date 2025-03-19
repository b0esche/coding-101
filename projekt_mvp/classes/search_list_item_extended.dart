class SearchListItemExtended {
  final String name;
  final String avatarUrl;
  final String about;
  final String city;
  final String bpm;
  final double? rating;
  final List<String> genres;

  SearchListItemExtended(
      {required this.name,
      required this.avatarUrl,
      required this.about,
      required this.city,
      required this.bpm,
      this.rating,
      required this.genres});
}

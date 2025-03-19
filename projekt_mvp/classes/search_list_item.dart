class SearchListItem {
  final String name;
  final String avatarUrl;
  final double? rating;
  final List<String> genres;

  SearchListItem(
      {required this.name,
      required this.avatarUrl,
      this.rating,
      required this.genres});
}

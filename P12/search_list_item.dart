import "user.dart";

class SearchListItem {
  final DJ dj;
  bool isExpanded;

  SearchListItem({required this.dj, this.isExpanded = false});

  @override
  String toString() {
    return "${dj.rating}, ${dj.name}, ${dj.genres}, ${dj.about}";
  }
}

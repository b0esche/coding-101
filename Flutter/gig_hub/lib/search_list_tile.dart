import 'package:flutter/material.dart';

class SearchListTile extends StatelessWidget {
  final String name;
  final List<Text> genres;
  final NetworkImage image;
  const SearchListTile({
    required this.name,
    required this.genres,
    required this.image,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),

        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 8),
          visualDensity: VisualDensity(vertical: 1),
          minLeadingWidth: 64,
          isThreeLine: true,
          subtitle: Row(
            spacing: 8,
            children: genres, // Genre Bubbles impl.
          ),
          leading: CircleAvatar(backgroundImage: image, radius: 40),
          title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

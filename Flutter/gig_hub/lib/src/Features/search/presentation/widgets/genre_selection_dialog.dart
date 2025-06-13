import 'package:flutter/material.dart';
import 'package:gig_hub/src/Common/genre_bubble.dart';
import 'package:gig_hub/src/Theme/palette.dart';

class GenreSelectionDialog extends StatefulWidget {
  final List<String> initialSelectedGenres;

  const GenreSelectionDialog({super.key, required this.initialSelectedGenres});

  @override
  State<GenreSelectionDialog> createState() => _GenreSelectionDialogState();
}

class _GenreSelectionDialogState extends State<GenreSelectionDialog> {
  late List<String> selectedGenres;

  @override
  void initState() {
    super.initState();
    selectedGenres = List.from(widget.initialSelectedGenres);
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Center(
        child: Text(
          "select up to 5",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Palette.primalBlack,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
      backgroundColor: Palette.forgedGold.o(0.95),

      children: [
        SizedBox(
          height: 240,
          width: 300,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            color: Palette.shadowGrey.o(0.6),
            child: ListView.separated(
              itemCount: genres.length,
              itemBuilder: (context, index) {
                final genre = genres[index];
                final isSelected = selectedGenres.contains(genre);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedGenres.remove(genre);
                      } else if (selectedGenres.length < 5) {
                        selectedGenres.add(genre);
                      }
                    });
                  },
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          genre,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Palette.primalBlack,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (isSelected) {
                                selectedGenres.remove(genre);
                              } else if (selectedGenres.length < 5) {
                                selectedGenres.add(genre);
                              }
                            });
                          },
                          icon: Icon(
                            isSelected
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: Palette.primalBlack.o(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  endIndent: 16,
                  indent: 16,
                  thickness: 2,
                  color: Palette.primalBlack.o(0.3),
                );
              },
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 12, top: 12),
            child: Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                border: BoxBorder.all(
                  color: Palette.shadowGrey.o(0.7),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop(selectedGenres);
                  },
                  icon: Icon(
                    Icons.check_rounded,
                    color: Palette.primalBlack,
                    size: 19,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

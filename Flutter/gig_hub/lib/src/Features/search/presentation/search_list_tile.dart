import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:gig_hub/src/Data/user.dart';
import 'package:gig_hub/src/Common/genre_bubble.dart';
import 'package:gig_hub/src/Theme/palette.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchListTile extends StatefulWidget {
  final DJ user;
  final String name;
  final List<String> genres;
  final NetworkImage image;
  final String about;
  final String location;
  final int bpmMin;
  final int bpmMax;
  final double? rating;
  final dynamic repo;

  const SearchListTile({
    required this.user,
    required this.name,
    required this.genres,
    required this.image,
    required this.about,
    required this.location,
    required this.bpmMin,
    required this.bpmMax,
    super.key,
    required this.rating,
    required this.repo,
  });

  @override
  State<SearchListTile> createState() => _SearchListTileState();
}

class _SearchListTileState extends State<SearchListTile> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      padding: EdgeInsets.only(
        left: 8,
        top: 8,
        bottom: isExpanded ? 8 : 12,
        right: 6,
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      decoration: BoxDecoration(
        border: Border.all(color: Palette.glazedWhite, width: 2),
        borderRadius: BorderRadius.circular(16),
        color: Palette.glazedWhite.o(0.35),
        boxShadow: [
          BoxShadow(
            spreadRadius: 2,
            blurRadius: 12,
            offset: Offset(0.5, 0.5),
            color: Palette.glazedWhite.o(0.3),
            blurStyle: BlurStyle.inner,
          ),
        ],
      ),
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Palette.primalBlack.o(0.35),
                      width: 1.35,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundImage: widget.image,
                    radius: 32,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 190,
                            child: Hero(
                              tag: context,
                              child: Text(
                                widget.name,
                                style: GoogleFonts.sometypeMono(
                                  textStyle: TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationColor: Palette.primalBlack.o(0.2),
                                    wordSpacing: -4,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,

                                    overflow:
                                        isExpanded
                                            ? TextOverflow.fade
                                            : TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          RatingStars(
                            value: widget.rating ?? 0,
                            starBuilder:
                                (index, color) => Icon(
                                  Icons.star_border_rounded,
                                  color: color,
                                  size: 22,
                                ),
                            starCount: 5,
                            maxValue: 5,
                            axis: Axis.horizontal,
                            angle: 0,
                            starSpacing: 0,
                            valueLabelVisibility: false,
                            animationDuration: Duration(milliseconds: 350),
                            starOffColor: Palette.shadowGrey,
                            starColor: Palette.forgedGold,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children:
                            widget.genres
                                .map(
                                  (genreString) => GenreBubble(
                                    genre: genreString.toString(),
                                  ),
                                )
                                .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AnimatedOpacity(
              opacity: isExpanded ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 250),
              child:
                  isExpanded
                      ? Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Column(
                          children: [
                            const Divider(),
                            Column(
                              spacing: 16,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  spacing: 32,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 2,
                                          color: Palette.forgedGold.o(0.8),
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                        color: Palette.forgedGold.o(0.6),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Row(
                                          spacing: 4,
                                          children: [
                                            Icon(
                                              Icons.location_pin,
                                              size: 18,
                                              color: Palette.primalBlack,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                    0,
                                                    0,
                                                    4,
                                                    0,
                                                  ),
                                              child: Text(
                                                widget.location,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Palette.primalBlack,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 2,
                                          color: Palette.forgedGold.o(0.8),
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                        color: Palette.forgedGold.o(0.6),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Row(
                                          spacing: 4,
                                          children: [
                                            Icon(
                                              Icons.speed,
                                              size: 22,
                                              color: Palette.primalBlack,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                    0,
                                                    0,
                                                    4,
                                                    0,
                                                  ),
                                              child: Text(
                                                "${widget.bpmMin}-${widget.bpmMax} bpm",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Palette.primalBlack,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          widget.about,
                                          maxLines: 4,
                                          softWrap: true,
                                          overflow: TextOverflow.visible,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        widget.user.showProfile(
                                          context,
                                          widget.repo,
                                          true,
                                          true,
                                          currentUser: widget.user,
                                        );
                                      },
                                      icon: Icon(
                                        Icons.chevron_right_rounded,
                                        size: 28,
                                      ),
                                      style: const ButtonStyle(
                                        tapTargetSize:
                                            MaterialTapTargetSize.padded,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                      : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class SearchListTile extends StatefulWidget {
  final String name;
  final List<Text> genres;
  final NetworkImage image;
  final String about;
  final String location;
  final int bpmMin;
  final int bpmMax;

  const SearchListTile({
    required this.name,
    required this.genres,
    required this.image,
    required this.about,
    required this.location,
    required this.bpmMin,
    required this.bpmMax,
    super.key,
  });

  @override
  State<SearchListTile> createState() => _SearchListTileState();
}

class _SearchListTileState extends State<SearchListTile> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(16),
        color: const Color.fromARGB(255, 247, 247, 247),
      ),
      child: InkWell(
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
                CircleAvatar(backgroundImage: widget.image, radius: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Wrap(spacing: 8, runSpacing: 4, children: widget.genres),
                    ],
                  ),
                ),
              ],
            ),
            AnimatedOpacity(
              opacity: isExpanded ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 330),
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
                                          width: 1,
                                          color: Color.fromARGB(
                                            220,
                                            181,
                                            165,
                                            76,
                                          ),
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color.fromARGB(
                                          120,
                                          181,
                                          165,
                                          76,
                                        ),
                                      ),

                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Row(
                                          spacing: 4,
                                          children: [
                                            Icon(Icons.location_pin, size: 18),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                    0,
                                                    0,
                                                    4,
                                                    0,
                                                  ),
                                              child: Text(widget.location),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: Color.fromARGB(
                                            220,
                                            181,
                                            165,
                                            76,
                                          ),
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color.fromARGB(
                                          120,
                                          181,
                                          165,
                                          76,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Row(
                                          spacing: 4,
                                          children: [
                                            Icon(Icons.speed, size: 22),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                    0,
                                                    0,
                                                    4,
                                                    0,
                                                  ),
                                              child: Text(
                                                "${widget.bpmMin.toString()}-${widget.bpmMax.toString()} bpm",
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

                                    InkWell(
                                      onTap: () {
                                        print("Profil wird geladen...");
                                      },
                                      child: Icon(
                                        Icons.chevron_right_rounded,
                                        size: 28,
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

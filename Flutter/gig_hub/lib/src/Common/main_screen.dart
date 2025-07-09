import 'package:flutter/material.dart';
import 'package:gig_hub/src/Common/custom_nav_bar.dart';
import 'package:gig_hub/src/Common/settings_screen.dart';
import 'package:gig_hub/src/Data/auth_repository.dart';
import 'package:gig_hub/src/Features/search/presentation/search_function_card.dart';
import 'package:gig_hub/src/Features/search/presentation/search_list_tile.dart';
import 'package:gig_hub/src/Data/users.dart';
import 'package:gig_hub/src/Theme/palette.dart';
import 'package:gig_hub/src/Features/search/presentation/sort_button.dart';
import 'package:gig_hub/src/Data/database_repository.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
    required this.repo,
    required this.auth,
    required this.initialUser,
  });
  final DatabaseRepository repo;
  final AuthRepository auth;
  final AppUser initialUser;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isExpanded = false;
  bool _isLoading = false;
  String _selectedSortOption = '';
  List<DJ> _usersDJ = [];
  List<DJ> _sortedUsersDJ = [];
  AppUser? _loggedInUser;
  late DatabaseRepository _repo;

  List<int>? _currentSearchBpmRange;
  List<String>? _currentSearchGenres;

  @override
  void initState() {
    super.initState();
    _repo = widget.repo;
    _loggedInUser = widget.initialUser;
    _fetchDJs();
  }

  Future<void> _fetchDJs() async {
    final users = await _repo.getDJs();
    setState(() {
      _usersDJ = users;
      _sortedUsersDJ = List.from(_usersDJ);
    });
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _sortUsers(String option) {
    setState(() {
      if (_selectedSortOption == option) {
        _selectedSortOption = '';
        _sortedUsersDJ = List.from(_usersDJ);
        return;
      }

      _selectedSortOption = option;
      List<DJ> sortedList = List.from(_usersDJ);

      if (option.isEmpty) {
        _sortedUsersDJ = List.from(_usersDJ);
        return;
      }

      switch (option) {
        case 'genre':
          if (_currentSearchGenres != null &&
              _currentSearchGenres!.isNotEmpty) {
            sortedList.sort((a, b) {
              // Count how many selected genres DJ 'a' has
              int matchesA =
                  a.genres
                      .where((genre) => _currentSearchGenres!.contains(genre))
                      .length;
              // Count how many selected genres DJ 'b' has
              int matchesB =
                  b.genres
                      .where((genre) => _currentSearchGenres!.contains(genre))
                      .length;

              // Sort descending by number of matches (more matches come first)
              if (matchesA != matchesB) {
                return matchesB.compareTo(matchesA);
              }

              // If match counts are equal, use a secondary sort criterion.
              // For example, sort alphabetically by DJ name as a tie-breaker.
              return a.name.compareTo(b.name);
            });
          } else {
            // If no search genres are active, fall back to standard alphabetical by first genre,
            // or by name if preferred. Let's stick to name for consistency when no search filter is active.
            sortedList.sort((a, b) => a.name.compareTo(b.name));
          }
          break;
        case 'bpm':
          if (_currentSearchBpmRange != null) {
            final int searchMin = _currentSearchBpmRange![0];
            final int searchMax = _currentSearchBpmRange![1];

            sortedList.sort((a, b) {
              // Calculate overlap for DJ A
              int overlapA = 0;
              if (a.bpm.last >= searchMin && a.bpm.first <= searchMax) {
                overlapA =
                    (a.bpm.last < searchMax ? a.bpm.last : searchMax) -
                    (a.bpm.first > searchMin ? a.bpm.first : searchMin);
              }

              // Calculate overlap for DJ B
              int overlapB = 0;
              if (b.bpm.last >= searchMin && b.bpm.first <= searchMax) {
                overlapB =
                    (b.bpm.last < searchMax ? b.bpm.last : searchMax) -
                    (b.bpm.first > searchMin ? b.bpm.first : searchMin);
              }

              // Prioritize higher overlap
              if (overlapA != overlapB) {
                return overlapB.compareTo(overlapA); // Descending by overlap
              }

              // If overlaps are equal, prioritize exact match of min/max
              if (a.bpm.first == searchMin && a.bpm.last == searchMax) {
                return -1;
              }
              if (b.bpm.first == searchMin && b.bpm.last == searchMax) return 1;

              // Fallback: sort by how "centered" their range is to the search range,
              // or simply by min BPM, then max BPM for tie-breaking.
              // For a simple tie-breaker, let's use min BPM then max BPM.
              int compareMin = a.bpm.first.compareTo(b.bpm.first);
              return compareMin == 0
                  ? a.bpm.last.compareTo(b.bpm.last)
                  : compareMin;
            });
          } else {
            // If no search BPM range is active, fall back to standard min/max sort
            sortedList.sort((a, b) {
              int compareMin = a.bpm.first.compareTo(b.bpm.first);
              return compareMin == 0
                  ? a.bpm.last.compareTo(b.bpm.last)
                  : compareMin;
            });
          }
          break;
        case 'location':
          sortedList.sort((a, b) => a.city.compareTo(b.city));
          break;
        default:
          _sortedUsersDJ = List.from(_usersDJ);
          return;
      }

      _sortedUsersDJ = sortedList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Palette.primalBlack,
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: SizedBox(
                    height: 130,
                    child: Stack(
                      children: [
                        if (_loggedInUser is! Guest)
                          Positioned(
                            top: 8,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                if (_loggedInUser == null) return;
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder:
                                        (context) => SettingsScreen(
                                          repo: widget.repo,
                                          auth: widget.auth,
                                        ),
                                    fullscreenDialog: true,
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Palette.glazedWhite.o(0.5),
                                    width: 1.4,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 32,
                                  backgroundImage: NetworkImage(
                                    _loggedInUser?.avatarUrl ??
                                        "https://picsum.photos/100",
                                  ),
                                ),
                              ),
                            ),
                          ),
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            height: 130,
                            width: 130,
                            child: Hero(
                              tag: context,
                              child: Image.asset(
                                'assets/images/gighub_logo.png',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                RepaintBoundary(
                  child: SearchFunctionCard(
                    onSearchResults: (List<DJ> results) {
                      setState(() {
                        _usersDJ = results;
                        _sortedUsersDJ = List.from(results);
                        _selectedSortOption = '';
                      });
                    },
                    onSearchLoading: (bool isLoading) {
                      setState(() {
                        _isLoading = isLoading;
                      });
                    },
                    onBpmRangeChanged: (List<int>? bpmRange) {
                      setState(() {
                        _currentSearchBpmRange = bpmRange;
                      });
                    },
                    onGenresChanged: (List<String>? genres) {
                      setState(() {
                        _currentSearchGenres = genres;
                      });
                    },
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap:
                          () => setState(() {
                            _isExpanded = !_isExpanded;
                          }),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'sort by ',
                              style: TextStyle(
                                color: Palette.glazedWhite,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                wordSpacing: -1,
                              ),
                            ),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.top,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isExpanded = !_isExpanded;
                                  });
                                },
                                child: Icon(
                                  _isExpanded
                                      ? Icons.expand_less
                                      : Icons.expand_more,
                                  size: 20,
                                  color: Palette.glazedWhite,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 4),
                  ],
                ),
                if (_isExpanded)
                  Align(
                    alignment: Alignment.centerRight,
                    child: SortButtonsWidget(
                      selectedSortOption: _selectedSortOption,
                      onSortOptionChanged: _sortUsers,
                      onExpandedChanged: _toggleExpanded,
                    ),
                  ),
                SizedBox(height: 8),
                Expanded(
                  child:
                      _isLoading
                          ? Center(
                            child: CircularProgressIndicator(
                              color: Palette.forgedGold,
                            ),
                          )
                          : Stack(
                            children: [
                              ListView.builder(
                                padding: const EdgeInsets.only(
                                  top: 28,
                                  left: 4,
                                  right: 4,
                                  bottom: 164,
                                ),
                                itemCount: _sortedUsersDJ.length,
                                itemBuilder: (context, index) {
                                  final DJ currentUserDJ =
                                      _sortedUsersDJ[index];
                                  return LiquidGlass(
                                    shape: LiquidRoundedRectangle(
                                      borderRadius: Radius.circular(16),
                                    ),
                                    settings: LiquidGlassSettings(thickness: 2),
                                    child: SearchListTile(
                                      currentUser: widget.initialUser,
                                      repo: _repo,
                                      user: currentUserDJ,
                                      name: currentUserDJ.name,
                                      genres: currentUserDJ.genres,
                                      image: NetworkImage(
                                        currentUserDJ.avatarImageUrl,
                                      ),
                                      about: currentUserDJ.about,
                                      location: currentUserDJ.city,
                                      bpm: currentUserDJ.bpm,

                                      rating: currentUserDJ.userRating,
                                    ),
                                  );
                                },
                              ),
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                height: 20,
                                child: IgnorePointer(
                                  child: LiquidGlass(
                                    shape: LiquidRoundedRectangle(
                                      borderRadius: Radius.circular(0),
                                    ),
                                    glassContainsChild: false,
                                    settings: LiquidGlassSettings(
                                      thickness: 17,
                                      blur: 1.7,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Palette.primalBlack,
                                            Palette.primalBlack.o(0),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomNavBar(
          repo: widget.repo,
          auth: widget.auth,
          currentUser: _loggedInUser!,
        ),
      ),
    );
  }
}

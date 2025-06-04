import 'package:flutter/material.dart';
import 'package:gig_hub/src/Common/settings_screen.dart';
import 'package:gig_hub/src/Features/chat/presentation/chat_list_screen.dart';
import 'package:gig_hub/src/Features/search/presentation/search_function_card.dart';
import 'package:gig_hub/src/Features/search/presentation/search_list_tile.dart';
import 'package:gig_hub/src/Data/user.dart';
import 'package:gig_hub/src/Theme/palette.dart';
import 'package:gig_hub/src/Features/search/presentation/sort_button.dart';
import 'package:gig_hub/src/Data/database_repository.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.repo});
  final DatabaseRepository repo;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isExpanded = false;
  bool _isLoading = false;
  String _selectedSortOption = '';
  List<DJ> _usersDJ = [];
  List<DJ> _sortedUsersDJ = [];
  int _selectedIndex = 0;
  AppUser? _loggedInUser;
  late DatabaseRepository _repo;

  List<int>? _currentSearchBpmRange;
  List<String>? _currentSearchGenres;

  @override
  void initState() {
    super.initState();
    _repo = widget.repo;
    _fetchDJs();
  }

  Future<void> _fetchDJs() async {
    final users = await _repo.getDJs();
    setState(() {
      _usersDJ = users;
      _sortedUsersDJ = List.from(_usersDJ);
      if (_usersDJ.isNotEmpty) {
        _loggedInUser = _usersDJ.first;
      }
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
              if (a.bpmMax >= searchMin && a.bpmMin <= searchMax) {
                overlapA =
                    (a.bpmMax < searchMax ? a.bpmMax : searchMax) -
                    (a.bpmMin > searchMin ? a.bpmMin : searchMin);
              }

              // Calculate overlap for DJ B
              int overlapB = 0;
              if (b.bpmMax >= searchMin && b.bpmMin <= searchMax) {
                overlapB =
                    (b.bpmMax < searchMax ? b.bpmMax : searchMax) -
                    (b.bpmMin > searchMin ? b.bpmMin : searchMin);
              }

              // Prioritize higher overlap
              if (overlapA != overlapB) {
                return overlapB.compareTo(overlapA); // Descending by overlap
              }

              // If overlaps are equal, prioritize exact match of min/max
              if (a.bpmMin == searchMin && a.bpmMax == searchMax) return -1;
              if (b.bpmMin == searchMin && b.bpmMax == searchMax) return 1;

              // Fallback: sort by how "centered" their range is to the search range,
              // or simply by min BPM, then max BPM for tie-breaking.
              // For a simple tie-breaker, let's use min BPM then max BPM.
              int compareMin = a.bpmMin.compareTo(b.bpmMin);
              return compareMin == 0
                  ? a.bpmMax.compareTo(b.bpmMax)
                  : compareMin;
            });
          } else {
            // If no search BPM range is active, fall back to standard min/max sort
            sortedList.sort((a, b) {
              int compareMin = a.bpmMin.compareTo(b.bpmMin);
              return compareMin == 0
                  ? a.bpmMax.compareTo(b.bpmMax)
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0 && _loggedInUser != null) {
      _loggedInUser!.showProfile(
        context,
        _repo,
        false,
        currentUser: _loggedInUser,
      );
    } else if (index == 1) {
      if (_loggedInUser != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    ChatListScreen(repo: _repo, currentUser: _loggedInUser!),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Bitte zuerst einloggen, um Chats zu sehen."),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String loggedInUserAvatar =
        _loggedInUser?.avatarUrl ?? "https://picsum.photos/100";

    return Scaffold(
      backgroundColor: Palette.primalBlack,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: SizedBox(
                    height: 130,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 8,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const SettingsScreen(),
                                  fullscreenDialog: true,
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Palette.glazedWhite,
                                  width: 1.5,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 32,
                                backgroundImage: NetworkImage(
                                  loggedInUserAvatar,
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
                SearchFunctionCard(
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
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "sort by",
                          style: TextStyle(
                            color: Palette.glazedWhite,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        ExpandIcon(
                          isExpanded: _isExpanded,
                          onPressed: (bool isExpanded) {
                            setState(() {
                              _isExpanded = !isExpanded;
                            });
                          },
                          color: Palette.glazedWhite,
                        ),
                      ],
                    ),
                    if (_isExpanded)
                      SortButtonsWidget(
                        selectedSortOption: _selectedSortOption,
                        onSortOptionChanged: _sortUsers,
                        onExpandedChanged: _toggleExpanded,
                      ),
                  ],
                ),
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
                                  top: 8,
                                  left: 2,
                                  right: 2,
                                ),
                                itemCount: _sortedUsersDJ.length,
                                itemBuilder: (context, index) {
                                  final DJ currentUserDJ =
                                      _sortedUsersDJ[index];
                                  return SearchListTile(
                                    repo: _repo,
                                    user: currentUserDJ,
                                    name: currentUserDJ.name,
                                    genres: currentUserDJ.genres,
                                    image: NetworkImage(
                                      currentUserDJ.avatarUrl,
                                    ),
                                    about: currentUserDJ.about,
                                    location: currentUserDJ.city,
                                    bpmMin: currentUserDJ.bpmMin,
                                    bpmMax: currentUserDJ.bpmMax,
                                    rating: currentUserDJ.rating ?? 0.0,
                                  );
                                },
                              ),
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                height: 20,
                                child: IgnorePointer(
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
                            ],
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: BottomNavigationBar(
          elevation: 4,
          onTap: _onItemTapped,
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Palette.glazedWhite,
          selectedItemColor: Palette.primalBlack,
          unselectedItemColor: Palette.primalBlack,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "profile"),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: "chats"),
          ],
          selectedFontSize: 12,
          unselectedFontSize: 12,
          iconSize: 22,
        ),
      ),
    );
  }
}

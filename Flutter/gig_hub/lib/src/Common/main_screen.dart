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
  String _selectedSortOption = '';
  List<DJ> _usersDJ = [];
  List<DJ> _sortedUsersDJ = [];
  int _selectedIndex = 0;
  AppUser? _loggedInUser;
  late DatabaseRepository _repo;

  @override
  void initState() {
    super.initState();
    _repo = widget.repo;
    _usersDJ = _repo.getDJs();
    _sortedUsersDJ = List.from(_usersDJ);
    _loadLoggedInUser();
  }

  Future<void> _loadLoggedInUser() async {
    if (_usersDJ.isNotEmpty) {
      setState(() {
        _loggedInUser = _usersDJ.first;
      });
    }
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
          sortedList.sort(
            (a, b) => (a.genres.isNotEmpty ? a.genres.first : '').compareTo(
              b.genres.isNotEmpty ? b.genres.first : '',
            ),
          );
          break;
        case 'bpm':
          sortedList.sort((a, b) {
            int compareMin = a.bpmMin.compareTo(b.bpmMin);
            return compareMin == 0 ? a.bpmMax.compareTo(b.bpmMax) : compareMin;
          });
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
      _loggedInUser!.showProfile(context, _repo);
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
                                  builder: (context) => SettingsScreen(),
                                ),
                              );

                              debugPrint("hier gehts zu account settings");
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
                          alignment: Alignment.center, // Korrigiert
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
                const SearchFunctionCard(),
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
                  child: Stack(
                    children: [
                      ListView.builder(
                        padding: const EdgeInsets.only(
                          top: 8,
                          left: 2,
                          right: 2,
                        ),
                        itemCount: _sortedUsersDJ.length,
                        itemBuilder: (context, index) {
                          final DJ currentUserDJ = _sortedUsersDJ[index];
                          return SearchListTile(
                            repo: _repo, // Pass the repository here
                            user: currentUserDJ,
                            name: currentUserDJ.name,
                            genres: currentUserDJ.genres,
                            image: NetworkImage(currentUserDJ.avatarUrl),
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

import 'package:flutter/material.dart';
import 'package:gig_hub/database_repository.dart';
import 'package:gig_hub/genre_bubble.dart';
import 'package:gig_hub/search_function_card.dart';
import 'package:gig_hub/search_list_tile.dart';
import 'user.dart';

void main() {
  final repo = MockDatabaseRepository();
  runApp(MainApp(repo: repo));
}

class MainApp extends StatelessWidget {
  final MockDatabaseRepository repo;
  const MainApp({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    final List<DJ> _usersDJ = [
      DJ(
        headUrl: "https://picsum.photos/101",
        city: "Berlin",
        about:
            "Ich mache sehr tolle Musik und Ich mache sehr tolle Musik und Ich mache sehr tolle Musik und Ich mache sehr tolle Musik",
        set1Url: "set1Url",
        set2Url: "set2Url",
        info: "info",
        genres: [
          GenreBubble(genre: genres[1]),
          GenreBubble(genre: genres[17]),
          GenreBubble(genre: genres[23]),
          GenreBubble(genre: genres[49]),
        ],
        bpmMin: 130,
        bpmMax: 150,
        userId: "abcd",
        name: "DJ Lorem Ipsum",
        email: "loremipsum@email.com",
        userType: UserType.dj,
        repo: repo,
      ),
      DJ(
        headUrl: "https://picsum.photos/102",
        city: "Graz",
        about: "Ich bin der besteste sowieso",
        set1Url: "set1Url",
        set2Url: "set2Url",
        info: "info",
        genres: [
          GenreBubble(genre: genres[12]),
          GenreBubble(genre: genres[21]),
          GenreBubble(genre: genres[29]),
          GenreBubble(genre: genres[41]),
        ],
        bpmMin: 120,
        bpmMax: 135,
        userId: "abcd",
        name: "DJ Bobo",
        email: "loremipsum@email.com",
        userType: UserType.dj,
        repo: repo,
      ),
      DJ(
        headUrl: "https://picsum.photos/103",
        city: "Hamburg",
        about: "Diese Worte widme ich Ibrahim",
        set1Url: "set1Url",
        set2Url: "set2Url",
        info: "info",
        genres: [
          GenreBubble(genre: genres[11]),
          GenreBubble(genre: genres[0]),
          GenreBubble(genre: genres[37]),
          GenreBubble(genre: genres[46]),
          GenreBubble(genre: genres[6]),
        ],
        bpmMin: 130,
        bpmMax: 150,
        userId: "abcd",
        name: "Claudio Fahihi Montana",
        email: "loremipsum@email.com",
        userType: UserType.dj,
        repo: repo,
      ),
      DJ(
        headUrl: "https://picsum.photos/104",
        city: "Wuppertal",
        about: "Da wo ich lege wächst kein Grass mehr ich sach dir dat",
        set1Url: "set1Url",
        set2Url: "set2Url",
        info: "info",
        genres: [
          GenreBubble(genre: genres[15]),
          GenreBubble(genre: genres[32]),
          GenreBubble(genre: genres[33]),
        ],
        bpmMin: 140,
        bpmMax: 170,
        userId: "abcd",
        name: "DJ Kanonenkugel",
        email: "loremipsum@email.com",
        userType: UserType.dj,
        repo: repo,
      ),
      DJ(
        headUrl: "https://picsum.photos/105",
        city: "Wien",
        about: "Frag besser nicht...",
        set1Url: "set1Url",
        set2Url: "set2Url",
        info: "info",
        genres: [
          GenreBubble(genre: genres[14]),
          GenreBubble(genre: genres[24]),
          GenreBubble(genre: genres[34]),
        ],
        bpmMin: 130,
        bpmMax: 150,
        userId: "abcd",
        name: "Money Boy",
        email: "loremipsum@email.com",
        userType: UserType.dj,
        repo: repo,
      ),
    ];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
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
                            child: InkWell(
                              onTap: () {
                                print("dit läuft");
                              },
                              child: Container(
                                width: 54,
                                height: 54,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      "https://picsum.photos/100",
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Align(
                            alignment: Alignment(0, 0),
                            child: GestureDetector(
                              onLongPress: () {
                                print("Hier wächst ein Osterei...");
                              },
                              child: SizedBox(
                                height: 130,
                                width: 130,
                                child: Image.asset(
                                  'assets/images/gighub_logo.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SearchFunctionCard(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          print("Hier wird sortiert!");
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("sort", style: TextStyle(color: Colors.white)),
                            SizedBox(width: 4),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        ListView.builder(
                          padding: EdgeInsets.only(top: 24),

                          itemCount: _usersDJ.length,
                          itemBuilder: (context, index) {
                            DJ currentUser = _usersDJ[index];
                            return SearchListTile(
                              name: currentUser.name,
                              genres: currentUser.genres,
                              // .map((genre) => GenreBubble(genre)),
                              // .toList(),
                              image: NetworkImage(currentUser.headUrl),
                              about: currentUser.about,
                              location: currentUser.city,
                              bpmMin: currentUser.bpmMin,
                              bpmMax: currentUser.bpmMax,
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
                                    Colors.black,
                                    Colors.black.withAlpha(0),
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
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Color.fromARGB(241, 255, 255, 255),
            selectedItemColor: Color.fromARGB(255, 181, 165, 76),
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "profile",
              ),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: "chats"),
            ],
            selectedFontSize: 14,
            unselectedFontSize: 12,
            iconSize: 22,
          ),
        ),
      ),
    );
  }
}

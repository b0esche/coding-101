import 'package:flutter/material.dart';
import 'package:gig_hub/search_function_card.dart';
import 'package:gig_hub/search_list_tile.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 20),
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
                          child: Container(
                            //(User)-ImageButton impl.
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              image: DecorationImage(
                                image: NetworkImage(
                                  "https://picsum.photos/100",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),

                        Align(
                          alignment: Alignment(0, 0),
                          child: SizedBox(
                            height: 130,
                            width: 130,
                            child: Image.asset(
                              'assets/images/gighub_logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SearchFunctionCard(),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Spacer(),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.only(right: 2),
                        minimumSize: Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        "sort", // Text(Icon)Button mit rotierendem Chevron impl.
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Icon(Icons.arrow_drop_down, color: Colors.white),
                  ],
                ),

                Expanded(
                  child: Stack(
                    children: [
                      ListView(
                        padding: EdgeInsets.only(top: 24),
                        shrinkWrap: true,
                        children: [
                          SearchListTile(
                            name: "DJ Lorem Ipsum",
                            genres: [Text("Genre A"), Text("Genre B")],
                            image: NetworkImage("https://picsum.photos/105"),
                          ),
                          SearchListTile(
                            name: "DJ Lorem Ipsum",
                            genres: [Text("Genre C"), Text("Genre B")],
                            image: NetworkImage("https://picsum.photos/101"),
                          ),
                          SearchListTile(
                            name: "DJ Lorem Ipsum",
                            genres: [Text("Genre B"), Text("Genre A")],
                            image: NetworkImage("https://picsum.photos/102"),
                          ),
                          SearchListTile(
                            name: "DJ Lorem Ipsum",
                            genres: [Text("Genre C"), Text("Genre A")],
                            image: NetworkImage("https://picsum.photos/103"),
                          ),
                          SearchListTile(
                            name: "DJ Lorem Ipsum",
                            genres: [Text("Genre C"), Text("Genre A")],
                            image: NetworkImage("https://picsum.photos/104"),
                          ),
                        ],
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
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "profile"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "chats"),
          ],
          selectedFontSize: 14,
          unselectedFontSize: 10,
          iconSize: 22,
        ),
      ),
    );
  }
}

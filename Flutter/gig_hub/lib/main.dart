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
                SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 50,
                    ), // AB HIER NICHT MEHR SCALABLE... Stack vielleicht
                    SizedBox(
                      height: 120,
                      width: 120,
                      child: Image(
                        image: AssetImage('assets/images/gighub_logo.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          image: DecorationImage(
                            image: NetworkImage(
                              "https://picsum.photos/100",
                            ), // Hier (User-)Image Button zu Account Settings impl.
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
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
                        padding: EdgeInsets.only(right: 4),
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
                SizedBox(height: 8),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      SearchListTile(
                        name: "DJ Lorem Ipsum",
                        genres: [Text("Genre A"), Text("Genre B")],
                        image: NetworkImage("https://picsum.photos/100"),
                      ),
                      SearchListTile(
                        name: "DJ Lorem Ipsum",
                        genres: [Text("Genre C"), Text("Genre B")],
                        image: NetworkImage("https://picsum.photos/100"),
                      ),
                      SearchListTile(
                        name: "DJ Lorem Ipsum",
                        genres: [Text("Genre B"), Text("Genre A")],
                        image: NetworkImage("https://picsum.photos/100"),
                      ),
                      SearchListTile(
                        name: "DJ Lorem Ipsum",
                        genres: [Text("Genre C"), Text("Genre A")],
                        image: NetworkImage("https://picsum.photos/100"),
                      ),
                      SearchListTile(
                        name: "DJ Lorem Ipsum",
                        genres: [Text("Genre C"), Text("Genre A")],
                        image: NetworkImage("https://picsum.photos/100"),
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

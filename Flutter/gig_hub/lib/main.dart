import 'package:flutter/material.dart';
import 'package:gig_hub/search_function_card.dart';

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
                    SizedBox(width: 50), // AB HIER NICHT MEHR SCALABLE...
                    SizedBox(
                      height: 120,
                      width: 120,
                      child: Image(
                        // Hier Image Button zu Account Settings impl.
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
                          image: DecorationImage(
                            image: NetworkImage("https://picsum.photos/100"),
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
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "sort v", // TextButton mit rotierendem Chevron impl.
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                // SingleChildScrollView(
                //   child: ListView(children: []),
                // ), // upNext: ListTiles impl.
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

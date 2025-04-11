import 'package:flutter/material.dart';

void main() {
  runApp(MainApp444());
}

class MainApp444 extends StatefulWidget {
  MainApp444({super.key});

  @override
  State<MainApp444> createState() => _MainApp444State();
}

class _MainApp444State extends State<MainApp444> {
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            pageIndex == 0
                ? Column(
                  children: [
                    Center(
                      child: Image.network(
                        "https://img.freepik.com/freie-psd/koestliche-vegetarische-pizza-frisch-gebackene-toppings-kaese-pilze-pfeffer-oliven_84443-37364.jpg?semt=ais_hybrid&w=740",
                      ),
                    ),
                  ],
                )
                : Column(
                  children: [
                    Center(
                      child: Image.network(
                        "https://img.freepik.com/psd-premium/leckerer-doener-mit-fleisch-und-gemuese-isoliert-auf-transparentem-hintergrund_812337-375.jpg",
                      ),
                    ),
                  ],
                ),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: pageIndex,
          onDestinationSelected: (value) {
            setState(() {
              pageIndex = value;
            });
          },
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.local_pizza_sharp),
              label: "Pizza",
            ),
            NavigationDestination(
              icon: Icon(Icons.kebab_dining_sharp),
              label: "Kebab",
            ),
          ],
        ),
      ),
    );
  }
}

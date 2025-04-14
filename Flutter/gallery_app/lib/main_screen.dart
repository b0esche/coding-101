import 'package:flutter/material.dart';
import 'pages/image_page.dart';
import 'pages/about_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int pageIndex = 0;

  List<Widget> pages = [ImagePage(), AboutPage()];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          centerTitle: true,
          title: Text("Gallery"),
          backgroundColor: Colors.blueGrey,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: pages[pageIndex]),
        ),
        bottomNavigationBar: NavigationBar(
          backgroundColor: Colors.blueGrey,
          selectedIndex: pageIndex,
          onDestinationSelected: (value) {
            setState(() {
              pageIndex = value;
            });
          },
          destinations: [
            NavigationDestination(icon: Icon(Icons.home), label: "Home"),
            NavigationDestination(icon: Icon(Icons.info), label: "About"),
          ],
        ),
      ),
    );
  }
}

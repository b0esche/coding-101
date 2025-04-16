import 'package:flutter/material.dart';
import '../features/image_gallery/image_page.dart';
import 'about_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int pageIndex = 0;
  bool listOrGrid = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [ImagePage(listOrGrid: listOrGrid), AboutPage()];
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          centerTitle: true,
          title: pageIndex == 0 ? Text("Gallery") : Text("About me"),
          actions: [
            pageIndex == 0
                ? Switch(
                  activeTrackColor: Colors.grey.shade800,
                  activeColor: Colors.indigoAccent.shade200,
                  value: listOrGrid,
                  onChanged: (value) {
                    setState(() {
                      listOrGrid = value;
                    });
                  },
                )
                : SizedBox(),
          ], // impl. GridView on Switch
          actionsPadding: EdgeInsets.fromLTRB(0, 0, 12, 0),
          backgroundColor: Colors.blueGrey,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: pages[pageIndex]),
        ),
        bottomNavigationBar: NavigationBar(
          indicatorColor: Colors.indigoAccent.shade200,
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

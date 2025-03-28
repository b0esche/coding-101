class Text extends Widget {
  final String data;
  Text(this.data);
}

class Column extends Widget {
  final List<Widget> children;
  Column({required this.children});
}

class Center extends Widget {
  final Widget child;
  Center({required this.child});
}

class Scaffold extends Widget {
  final Widget body;
  Scaffold({required this.body});
}

class MaterialApp extends Widget {
  final Widget home;
  MaterialApp({required this.home});
}

class Widget {}

void main() {
  var myApp = MaterialApp(
    home: Scaffold(
      body: Center(child: Column(children: [Text("Hallo"), Text("Welt!")])),
    ),
  );
}

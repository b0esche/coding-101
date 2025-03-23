abstract class Shape {
  final String id;
  Shape({required this.id});
  void getDimensions();
  // String toString();
}

class Rectangle extends Shape {
  double length;
  double width;
  Rectangle({required super.id, required this.length, required this.width});

  @override
  void getDimensions() {
    print("Länge: $length, Weite: $width");
  }

  @override // das Überschreiben der toString Methode
  String toString() {
    // ändert automatisch den print-output der Instanz
    return "Rectangle(Länge: $length, Weite: $width)"; // siehe Zeile 53, 58
  }
}

class Circle extends Shape {
  double length;
  double width;

  Circle({required super.id, required this.length, required this.width});

  @override
  void getDimensions() {
    print("Länge: $length, Weite: $width");
  }

  @override
  String toString() {
    return "Circle(Länge: $length, Weite: $width)";
  }
}

List<Shape> myList = [];
void main() {
  Rectangle a = Rectangle(id: "222", length: 8, width: 12);
  a.getDimensions();

  Circle o = Circle(id: "333", length: 6, width: 10);
  o.getDimensions();

  myList.add(a);
  myList.add(o);

  print(myList[0]); // = print(a);
  print("ID: ${myList[0].id}"); // da id in der Superklasse angelegt ist,
  // können wir hier über .id darauf zugreifen;
  // (Die Liste ist vom Typ 'Shape' -> Superklasse)

  print(myList[1]);
  print("ID: ${myList[1].id}");
}

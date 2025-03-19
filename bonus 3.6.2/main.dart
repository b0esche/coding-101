// Bonus 2

void main() {
  Button b = Button(
    "In den Warenkorb",
    width: 96,
    height: 32,
    radius: 4,
    fontSize: 14,
    padding: 8,
  );
}

class Button {
  final String text;
  final int width;
  final int height;
  final int radius;
  final int fontSize;
  final int padding;

  Button(this.text,
      {required this.width,
      required this.height,
      required this.radius,
      required this.fontSize,
      required this.padding});
}
//##########################################################
// Bonus 3

class Rectangle {
  // Attribute
  double length;
  double width;

// Constructor
  Rectangle({required this.length, required this.width});

// Methoda a)
  double calcCirc() {
    return 2 * (length + width);
  }

// Methode b)
  double calcArea() {
    return length * width;
  }

// Bonus 5
  void scale(double factor) {
    length *= factor;
    width *= factor;
  }
}

//#########################################################
// Bonus 4
void main1() {
  Rectangle a = Rectangle(length: 32, width: 64);
  print(a.calcArea());
  print(a.calcCirc());
  a = Rectangle(length: 36, width: a.width);
  print("Neue Fläche: ${a.calcArea()}");
  print("Neuer Umfang: ${a.calcCirc()}");
}

//#########################################################
// Bonus 5
void main2() {
  Rectangle a = Rectangle(length: 32, width: 64);

  print("Flache: ${a.calcArea()}");
  print("Umfang: ${a.calcCirc()}");

  a.scale(0.5);

  print("Neue Fläche: ${a.calcArea()}");
  print("Neuer Umfang: ${a.calcCirc()}");

  a.scale(2);

  print("Neue Fläche: ${a.calcArea()}");
  print("Neuer Umfang: ${a.calcCirc()}");
}

//##########################################################
//Bonus 6
class Autor {
  final String name;
  final int birthYear;

  Autor({required this.name, required this.birthYear});
}

class Buch {
  final String title;
  final int pages;
  final Autor autor;

  Buch({required this.title, required this.pages, required this.autor});
}

Autor db = Autor(name: "Dieter Bohlen", birthYear: 1954);
Buch a = Buch(title: "Grüß Gott", pages: 323, autor: db);

void main3() {
  print(
      "Das Buch ${a.title} fasst auf ${a.pages} Seiten die aufregende Geschichte des wahrhaftigen ${a.autor.name} zusammen.");
}

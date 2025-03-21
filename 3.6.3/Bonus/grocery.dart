class Grocery {
  final String name;
  final String brand;
  final double weight;
  final double price;

  Grocery(
      {required this.name,
      required this.brand,
      required this.weight,
      required this.price});

  void addToShoppingCart(Grocery x) {
    List<Grocery> shoppingList = [];
    shoppingList.add(x);
  }

  void getDetails() {
    print(
        "Produkt: $name, Marke: $brand, Gewicht: $weight kg, Preis: $price €");
  }
}

class Milk extends Grocery {
  final DateTime exp;
  Milk(
      {required super.name,
      required super.brand,
      required super.weight,
      required super.price,
      required this.exp});

  @override
  void getDetails() {
    print(
        "Milch: $name, Marke: $brand, Gewicht: $weight kg, Preis: $price €, Haltbar bis: $exp");
  }
}

class Butter extends Grocery {
  final bool isStreichzart;

  Butter(
      {required super.name,
      required super.brand,
      required super.weight,
      required super.price,
      required this.isStreichzart});

  @override
  void getDetails() {
    String streichInfo = isStreichzart ? "streichzart" : "nicht streichzart";
    print(
        "Butter: $name, Marke: $brand, Gewicht: $weight kg, Preis: $price €, Eigenschaft: $streichInfo");
  }
}

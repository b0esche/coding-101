import "main.dart";

class Tool {
  final String brand;
  final double weight;
  final double price;
  final bool isUsed;

  Tool(
      {required this.brand,
      required this.weight,
      required this.price,
      required this.isUsed});
}

class Hammer extends Tool {
  bool isHardened;

  Hammer(
      {required super.brand,
      required super.weight,
      required super.price,
      required super.isUsed,
      required this.isHardened});

  void nailedIt() {
    print("Sitzt, passt, wackelt und hat Luft!");
  }
}

class Saw extends Tool {
  final int numberOfTeeth;
  final bool hasMotor;

  Saw(
      {required super.brand,
      required super.weight,
      required super.price,
      required super.isUsed,
      required this.numberOfTeeth,
      required this.hasMotor});

  void countTeeth() {
    print("Diese Säge hat $numberOfTeeth Zähne.");
  }
}

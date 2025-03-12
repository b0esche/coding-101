void printNumber(int num) {
  print("Die eingegebene Zahl lautet $num");
}

void triplePrint(String txt) {
  for (int i = 0; i < 3; i++) {
    print(txt);
  }
}

void reverseInitials(String? vor, String? nach) {
  print("${vor![vor.length - 1].toUpperCase()}."
      "${nach![nach.length - 1].toUpperCase()}.");
}

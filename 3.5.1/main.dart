void main() {
  for (int i = 1; i <= 100; i++) {
    if (i < 10) {
      print("Kleine Zahl: $i");
    }
    if (i < 60 && i >= 10) {
      print("Mittlere Zahl: $i");
    }
    if (i >= 60) {
      print("Große Zahl: $i");
    }
  }
}

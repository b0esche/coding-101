// Aufgabe 1
int tripleSum(int a, int b, int c) {
  int sum = a + b + c;
  return sum;
}

// Aufgabe 2
int inputLength(String text) {
  int length = text.length;
  return length;
}

// Aufgabe 3
int vowelCount(String word) {
  int vowels = 0;
  String vowellist = "aeiouAEIOU";
  for (int i = 0; i < word.length; i++)
    if (vowellist.contains(word[i])) {
      vowels++;
    }
  return vowels;
}

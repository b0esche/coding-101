int largerNum(int num1, int num2) {
  return num1 > num2 ? num1 : num2;
}

//##########################################################
bool evenNum(int num) {
  bool result = num % 2 == 0;
  return result;
}

//##########################################################
int listSum(List<int> numbers) {
  int result = 0;
  for (int num in numbers) {
    result += num;
  }
  return result;
}

//##########################################################
double listAvg(List<int> numbers) {
  double result = 0;
  for (int num in numbers) {
    result += num;
  }
  return result / numbers.length;
}

//##########################################################

int letterCount(String text, String letter) {
  int count = 0;
  for (int i = 0; i < text.length; i++) {
    if (text[i].toLowerCase() == letter.toLowerCase()) {
      count++;
    }
  }
  return count;
}

//##########################################################
bool letterUsed(String word, String letter) {
  return word.toLowerCase().contains(letter.toLowerCase());
}

//##########################################################
String sigCheck(int x) {
  String sig = "";
  switch (x) {
    case < 0:
      sig = "-";
    case == 0:
      sig = "0";
    case > 0:
      sig = "+";
  }
  return sig;
}
//##########################################################

List<String> spellOut(String word) {
  List<String> letters = [];
  for (int i = 0; i < word.length; i++) {
    letters.add(word[i]);
  }
  return letters;
}

//##########################################################
List<String> multiLetterCount(List<String> words) {
  List<String> letters = [];
  for (String word in words) {
    letters.add("$word: ${word.length}");
  }
  return letters;
}

//##########################################################
int multiply(int x, int y) {
  return x * y;
}
//##########################################################

int negativeOf(int z) {
  return -z;
}

//##########################################################
int smallestNumber(List<int> numbers) {
  int result = numbers.first;
  for (int i = 0; i < numbers.length; i++) {
    if (numbers[i] < result) {
      result = numbers[i];
    }
  }
  return result;
}

// hier reicht auch eine for-in-Schleife
int smallestNumber2(List<int> numbers) {
  int result = numbers.first;
  for (int num in numbers) {
    if (num < result) {
      result = num;
    }
  }
  return result;
}
//##########################################################

Map<String, int> mapLetterCount(List<String> words) {
  Map<String, int> output = {};
  for (String word in words) {
    output[word] = word.length;
  }
  return output;
}

//##########################################################
// hier ohne boolschen Wert
void tempConvert(int mode, double inputTemp) {
  if (mode == 1) {
    double newTemp = (inputTemp * 1.8 + 32);
    print(
        "$inputTemp Grad Celsius sind ${newTemp.toStringAsFixed(1)} Grad Fahrenheit");
  } else if (mode == 2) {
    double newTemp = (inputTemp - 32) / 1.8;
    print(
        "$inputTemp Grad Fahrenheit sind ${newTemp.toStringAsFixed(1)} Grad Celsius");
  } else {
    print("Bitte gültigen Umrechnungsmodus wählen!");
  }
}

//##########################################################
String compile(List<String> words) {
  String result = "";
  for (String word in words) {
    result += word;
  }
  return result;
}

//##########################################################
bool isPrime(int input) {
  if (input < 2) return false;
  if (input == 2) return true;
  if (input % 2 == 0) return false;

  for (int i = 3; i * i <= input; i += 2) {
    if (input % i == 0) {
      return false;
    }
  }
  return true;
}

//##########################################################
int digitReverse(int number) {
  int rev = 0;
  while (number > 0) {
    int digit = number % 10;
    rev = rev * 10 + digit;
    number ~/= 10;
  }
  return rev;
}
//##########################################################

// Aufgabe 1
void main() {
  int age = 26;
  bool hasParentalConsent = true;
  int movieAgeRating = 18;

  if (age >= 18 || (hasParentalConsent && age >= movieAgeRating - 2)) {
    print("Erlaubnis erteilt!");
  } else {
    print("Erlaubnis verweigert!");
  }
}

// Aufgabe 2
void main2() {
  bool isLoggedIn = true;
  bool isBanned = false;
  bool isSubscribed = true;
  int age = 26;

  if (!isLoggedIn) {
    print("Bitte einloggen!");
  } else if (isBanned) {
    print("Account gesperrt!");
  } else if (!isSubscribed) {
    print("Bitte abonnieren!");
  } else if (age < 18) {
    print("Mindestalter nicht erreicht!");
  } else {
    print("Viel Spaß beim Streamen!");
  }
}

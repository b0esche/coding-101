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

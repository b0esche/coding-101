enum Sex { male, female }

void main() {
  int? age;
  Sex? sex;

  sex = Sex.male;
  age = 31;

  switch (sex) {
    case Sex.male:
      switch (age) {
        case >= 20 && < 25:
          print("Im Schnitt 181,4m");
        case >= 25 && < 30:
          print("Im Schnitt 181,3m");
        case >= 30 && < 35:
          print("Im Schnitt 180,4m");
      }
    case Sex.female:
      switch (age) {
        case >= 20 && < 25:
          print("Im Schnitt 167,5m");
        case >= 25 && < 30:
          print("Im Schnitt 167,3 m");
        case >= 30 && < 35:
          print("Im Schnitt 167,2");
      }
    //case null:
    //print("Keine Daten für diese Altersklasse");
  }
}

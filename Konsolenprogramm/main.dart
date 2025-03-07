// Der Steakgrillzeitberechner

import "dart:io";

List<Map<int, int>> times = [
  {1: 1, 2: 2, 3: 4, 4: 6},
  {1: 1, 2: 3, 3: 5, 4: 7},
  {1: 1, 2: 4, 3: 8, 4: 10},
  {1: 1, 2: 5, 3: 10, 4: 12}
];

void main() {
  print("Wie dick ist dein Steak? (in cm)");
  String? steakdimension = stdin.readLineSync();
  double? dim = double.tryParse(steakdimension ?? "");
  if (dim == null || dim > 5) {
    print("Dein Steak ist viel zu dick!");
    return;
  }
  if (dim < 1) {
    print("Aufschnitt!");
    return;
  }
  print("Sehr schön!");
  print("Wähle deine Garstufe! (1-4)");
  String? gradeInput = stdin.readLineSync();
  int? grade = int.tryParse(gradeInput ?? "");
  if (grade == null || grade < 1 || grade > 4) {
    print("Keine gültige Garstufe!");
    return;
  }
  int time = 0;
  switch (dim) {
    case <= 2:
      switch (grade) {
        case 1:
          time = times[0][1]!;
        case 2:
          time = times[0][2]!;
        case 3:
          time = times[0][3]!;
        case 4:
          time = times[0][4]!;
      }
    case <= 2.5:
      switch (grade) {
        case 1:
          time = times[1][1]!;
        case 2:
          time = times[1][2]!;
        case 3:
          time = times[1][3]!;
        case 4:
          time = times[1][4]!;
      }
    case <= 3:
      switch (grade) {
        case 1:
          time = times[2][1]!;
        case 2:
          time = times[2][2]!;
        case 3:
          time = times[2][3]!;
        case 4:
          time = times[2][4]!;
      }
    case > 3 && <= 5:
      switch (grade) {
        case 1:
          time = times[3][1]!;
        case 2:
          time = times[3][2]!;
        case 3:
          time = times[3][3]!;
        case 4:
          time = times[3][4]!;
      }
  }

  print("Grille dein Steak ${time / 2} min von jeder Seite!");
}

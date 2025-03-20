import "func.dart";

void main() {
  print(largerNum(5, 8));
  print(largerNum(12, 33));
  print(largerNum(12053, 12058));
//##########################################################
  print(evenNum(3));
  print(evenNum(457));
  print(evenNum(23518));
//##########################################################
  print(listSum([5, 12, 8]));
  print(listSum([22, 42, 62]));
  print(listSum([100, 200, 300]));
//##########################################################
  print(listAvg([5, 10, 15]));
  print(listAvg([10, 10, 11]));
  print(listAvg([11, 22, 33]));
//##########################################################
  print(letterCount("Habicht", "h"));
  print(letterCount("Meerschweinchen", "H"));
  print(letterCount("Affe", "F"));
//##########################################################
  print(letterUsed("Banane", "a"));
  print(letterUsed("Banane", "A"));
  print(letterUsed("Zeppelin", "o"));
//##########################################################
  print(sigCheck(12));
  print(sigCheck(-24));
  print(sigCheck(0));
//##########################################################
  print(spellOut("Hafensänger"));
  print(spellOut("Pommesbude"));
  print(spellOut("oderwatt"));
//##########################################################
  print(
      multiLetterCount(["words", "are", "used", "to", "communiacte", "here"]));
  print(multiLetterCount(["Danke ", "Gott", "es", "ist", "Freitag"]));
  print(multiLetterCount(
      ["Miezekatze", "Mietzemietz", "Vermietzer", "Katerkonferenz"]));
//##########################################################
  print(multiply(3, multiply(6, 9)));
  print(multiply(4, multiply(5, 10)));
  print(multiply(3, 4));
//##########################################################
  print(negativeOf(5));
  print(negativeOf(0));
  print(negativeOf(-120));
//##########################################################
  print(smallestNumber([7, 3, 7, 12, 5, 23]));
  print(smallestNumber([
    27,
    33,
    72,
    11,
    98,
    45,
    23,
    76,
  ]));
  print(smallestNumber2([500, 600, 700, 100, 800, 900, 350]));
//##########################################################
  print(mapLetterCount(["Baum", "Computer", "Wasserfall"]));
  print(mapLetterCount(["Affen", "Gehege"]));
  print(mapLetterCount(
      ["Fahrstuhl", "Fachhandel", "Milchbauer", "Loveparade", "AppAkademie"]));
//##########################################################
  temp(1, 36.3);
  temp(2, 89.2);
  temp(3, 33);
//##########################################################
}

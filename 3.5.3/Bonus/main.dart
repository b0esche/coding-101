import "func.dart";

void main() {
  print(largerNum(5, 8));
  print(largerNum(12, 33));
  print(largerNum(12053, 12058));
//-----------------------------------
  print(evenNum(3));
  print(evenNum(457));
  print(evenNum(23518));

//-----------------------------------
  print(listSum([5, 12, 8]));
  print(listSum([22, 42, 62]));
  print(listSum([100, 200, 300]));
//-----------------------------------
  print(listAvg([5, 10, 15]));
  print(listAvg([10, 10, 11]));
  print(listAvg([11, 22, 33]));
//-----------------------------------
  print(letterCount("Habicht", "h"));
  print(letterCount("Meerschweinchen", "H"));
  print(letterCount("Affe", "F"));
//-----------------------------------

  print(letterUsed("Banane", "a"));
  print(letterUsed("Banane", "A"));
  print(letterUsed("Zeppelin", "o"));
//-----------------------------------
  print(sigCheck(12));
  print(sigCheck(-24));
  print(sigCheck(0));
//-----------------------------------
  print(spellOut("Hafensänger"));
  print(spellOut("Pommesbude"));
  print(spellOut("oderwatt"));
//-----------------------------------
  print(
      multiLetterCount(["words", "are", "used", "to", "communiacte", "here"]));
  print(multiLetterCount(["Danke ", "Gott", "es", "ist", "Freitag"]));
  print(multiLetterCount(
      ["Miezekatze", "Mietzemietz", "Vermietzer", "Katerkonferenz"]));
//-----------------------------------
  print(multiply(3, multiply(6, 9)));
  print(multiply(4, multiply(5, 10)));
  print(multiply(3, 4));
//-----------------------------------
  print(negativeOf(5));
  print(negativeOf(-5));
  print(negativeOf(-120));
//-----------------------------------
}

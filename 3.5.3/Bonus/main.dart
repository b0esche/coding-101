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

  print(letterCount("Affe", "F"));
//-----------------------------------
  print(negativizer(5));
  print(negativizer(-5));
//-----------------------------------
}

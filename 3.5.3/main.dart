import 'func.dart';

void main() {
  int sum = tripleSum(3, 6, 9);
  print(sum);

  int sum1 = tripleSum(5, 10, 15);
  print(sum1);

  //int sum2 = tripleSum(10, 11, 12);
  //print(sum2);
  print(tripleSum(10, 11, 12));

//-------------------------------------------

  int l = inputLength("Baum");
  print(l);

  int l1 = inputLength("Rosenmontag");
  print(l1);

  //int l2 = inputLength("Macintosh");
  //print(l2);
  print(inputLength("Macintosh"));

  //-------------------------------------------

  // int v = vowelCount("Baumkuchen");
  // print(v);

  print(vowelCount("Baumkuchen"));

  int v1 = vowelCount("Autobahn");
  print(v1);

  int v2 = vowelCount("Kaffeevollautomat");
  print(v2);
}

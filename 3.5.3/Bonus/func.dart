int largerNum(int num1, int num2) {
  int result = num1 > num2 ? num1 : num2;
  return result;
}

//------------------------------------------
bool evenNum(int num) {
  bool result = num % 2 == 0;
  return result;
}

//------------------------------------------
int listSum(List<int> numbers) {
  int result = 0;
  for (int num in numbers) {
    result += num;
  }
  return result;
}

//------------------------------------------
double listAvg(List<int> numbers) {
  double result = 0;
  for (int num in numbers) {
    result += num;
  }
  return result / numbers.length;
}

//------------------------------------------

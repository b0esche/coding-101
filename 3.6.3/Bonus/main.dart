import "tool.dart";
import "grocery.dart";

void main() {
  Saw stihl = Saw(
      brand: "Stihl",
      weight: 12,
      price: 109.99,
      isUsed: true,
      numberOfTeeth: 133,
      hasMotor: true);

  Hammer x = Hammer(
      brand: "Knipex",
      weight: 2.5,
      price: 9.99,
      isUsed: false,
      isHardened: true);

  stihl.countTeeth();
  x.nailedIt();

//######################################################################

  Milk baerenmarke = Milk(
      name: "Vollmilch",
      brand: "Bärenmarke",
      weight: 1,
      price: 1.29,
      exp: DateTime(2025, 4, 15));

  Butter kerrygold = Butter(
      name: "Weiche Butter",
      brand: "Kerrygold",
      weight: 0.25,
      price: 2.99,
      isStreichzart: true);

  baerenmarke.getDetails();
  kerrygold.getDetails();
}

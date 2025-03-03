import 'dart:math';
import 'dart:io';

void main() {
  final random = Random();
  final words = {
    'a': ['apple', 'ant', 'avocado'],
    'b': ['banana', 'boat', 'bottle'],
    'c': ['cat', 'car', 'cup'],
    'd': ['dog', 'door', 'doll'],
    'e': ['elephant', 'egg', 'ear'],
    'f': ['fish', 'fan', 'fork'],
    'g': ['goat', 'guitar', 'glass'],
    'h': ['hat', 'house', 'hand'],
    'i': ['igloo', 'ice', 'island'],
    'j': ['jacket', 'jelly', 'jungle'],
    'k': ['kite', 'key', 'kangaroo'],
    'l': ['lion', 'lamp', 'leaf'],
    'm': ['monkey', 'moon', 'mug'],
    'n': ['nose', 'net', 'notebook'],
    'o': ['orange', 'owl', 'ocean'],
    'p': ['penguin', 'pencil', 'plate'],
    'q': ['queen', 'quantum', 'quokka'],
    'r': ['rabbit', 'ring', 'road'],
    's': ['snake', 'star', 'spoon'],
    't': ['tiger', 'table', 'turtle'],
    'u': ['umbrella', 'unicorn', 'utensil'],
    'v': ['vase', 'violin', 'van'],
    'w': ['whale', 'window', 'watch'],
    'x': ['xylophone', 'x-ray', 'xenon'],
    'y': ['yacht', 'yarn', 'yak'],
    'z': ['zebra', 'zoo', 'zipper'],
  };

  stdout.write('wie heist du?: ');
  String? name = stdin.readLineSync();

  if (name != null && name.isNotEmpty) {
    for (var letter in name.toLowerCase().split('')) {
      if (words.containsKey(letter)) {
        var randomWord = words[letter]![random.nextInt(words[letter]!.length)];
        print('"$letter" wie: $randomWord');
      } else {
        print('blanks stanks');
      }
    }
  } else {
    print('Please enter a valid name.');
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';

void main() {
  runApp(const CocktailApp());
}

class CocktailApp extends StatelessWidget {
  const CocktailApp({super.key});

  static final Map<String, dynamic> cocktailApiMap = jsonDecode('''{
    "drinks": [
      {
        "idDrink": "11119",
        "strDrink": "Blue Mountain",
        "strCategory": "Ordinary Drink"
      }
    ]
  }''');

  void _onPressed() {
    final drinks = cocktailApiMap['drinks'] as List<dynamic>;
    final drink = drinks.first as Map<String, dynamic>;
    final name = drink['strDrink'];
    final category = drink['strCategory'];
    final id = drink['idDrink'];
    debugPrint('Name: $name');
    debugPrint('Kategorie: $category');
    debugPrint('ID: $id');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Cocktail JSON Test')),
        body: Center(
          child: ElevatedButton(
            onPressed: _onPressed,
            child: const Text('Drinks abrufen'),
          ),
        ),
      ),
    );
  }
}

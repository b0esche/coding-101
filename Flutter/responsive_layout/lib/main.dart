import 'package:flutter/material.dart';
import 'package:responsive_layout/src/app.dart';
import 'package:responsive_layout/src/data/database/mock_database_repository.dart';

void main() {
  runApp(App(products: MockDatabaseRepository().mockProducts));
}

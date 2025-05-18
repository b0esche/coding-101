import 'package:flutter/material.dart';
import 'package:gig_hub/src/Data/database_repository.dart';
import 'package:gig_hub/src/app.dart';

void main() {
  final DatabaseRepository repo = MockDatabaseRepository();
  runApp(App(repo: repo));
}

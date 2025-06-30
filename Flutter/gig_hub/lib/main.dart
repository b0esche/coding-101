import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gig_hub/firebase_options.dart';
import 'package:gig_hub/src/Data/database_repository.dart';
import 'package:gig_hub/src/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");
  final DatabaseRepository repo = MockDatabaseRepository();
  runApp(App(repo: repo));
}

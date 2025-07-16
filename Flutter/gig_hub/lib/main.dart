import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gig_hub/firebase_options.dart';
import 'package:gig_hub/src/Data/auth_repository.dart';
import 'package:gig_hub/src/Data/database_repository.dart';
import 'package:gig_hub/src/Data/firebase_auth_repository.dart';
import 'package:gig_hub/src/Data/firestore_repository.dart';

import 'package:gig_hub/src/app.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.openBox('favoritesBox');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");
  final DatabaseRepository db = FirestoreDatabaseRepository();
  final AuthRepository auth = FirebaseAuthRepository();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<DatabaseRepository>(create: (_) => db),
        Provider(create: (context) => auth),
      ],
      child: App(),
    ),
  );
}

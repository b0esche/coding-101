import 'package:gig_hub/src/Data/app_imports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.openBox('favoritesBox');
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final AuthRepository auth = FirebaseAuthRepository();
  final DatabaseRepository db = FirestoreDatabaseRepository();
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => auth),
        ChangeNotifierProvider<DatabaseRepository>(create: (_) => db),
      ],
      child: App(),
    ),
  );
}

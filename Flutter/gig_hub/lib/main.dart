import 'package:gig_hub/src/Data/app_imports.dart';

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

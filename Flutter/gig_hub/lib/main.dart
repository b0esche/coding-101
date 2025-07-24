import 'package:device_preview/device_preview.dart';
import 'package:gig_hub/src/Data/app_imports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final AuthRepository auth = FirebaseAuthRepository();
  final DatabaseRepository db = FirestoreDatabaseRepository();
  runApp(
    DevicePreview(
      enabled: false,
      builder:
          (context) => MultiProvider(
            providers: [
              Provider(create: (context) => auth),
              ChangeNotifierProvider<DatabaseRepository>(create: (_) => db),
            ],
            child: App(),
          ),
    ),
  );
}

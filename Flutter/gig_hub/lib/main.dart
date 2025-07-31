import 'package:gig_hub/src/Data/app_imports.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final notification = message.notification;
  if (notification != null) {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'chat_channel',
          'chat messages',
          channelDescription: 'get notified when receiving new messages',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
        );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      platformChannelSpecifics,
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final AuthRepository auth = FirebaseAuthRepository();
  final DatabaseRepository db = FirestoreDatabaseRepository();

  await FirebaseMessaging.instance.requestPermission();
  await db.initFirebaseMessaging();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => auth),
        ChangeNotifierProvider<DatabaseRepository>(create: (_) => db),
      ],
      child: NotificationHandlerApp(auth: auth, db: db),
    ),
  );
}

class NotificationHandlerApp extends StatefulWidget {
  final AuthRepository auth;
  final DatabaseRepository db;
  const NotificationHandlerApp({
    super.key,
    required this.auth,
    required this.db,
  });

  @override
  State<NotificationHandlerApp> createState() => _NotificationHandlerAppState();
}

class _NotificationHandlerAppState extends State<NotificationHandlerApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationNav);
    _checkInitialMessage();
  }

  Future<void> _checkInitialMessage() async {
    final initialMsg = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMsg != null) {
      _handleNotificationNav(initialMsg);
    }
  }

  void _handleNotificationNav(RemoteMessage message) async {
    debugPrint('Notification data: \\${message.data}');
    final screen = message.data['screen'];
    if (screen == 'chat_list_screen') {
      final user = await widget.db.getCurrentUser();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (_) => ChatListScreen(currentUser: user)),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return App(navigatorKey: _navigatorKey);
  }
}

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gig_hub/src/Data/app_imports.dart';

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

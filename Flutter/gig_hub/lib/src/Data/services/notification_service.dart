import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gig_hub/src/Data/app_imports.dart';

/// Notification handler service that manages push notification interactions
///
/// Features:
/// - Handles notification taps when app is running or terminated
/// - Deep linking to specific chat screens based on notification data
/// - Integration with Firebase Cloud Messaging
/// - Navigation management for notification-triggered actions
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
    // Listen for notification taps when app is running
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationNav);
    // Check if app was opened via notification when terminated
    _checkInitialMessage();
  }

  /// Checks if the app was opened via a notification when it was terminated
  /// Handles the initial navigation if a notification was the trigger
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

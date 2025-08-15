import 'dart:async';
import '../firebase/firestore_repository.dart';

class GroupChatCleanupService {
  static const Duration _cleanupInterval = Duration(
    hours: 1,
  ); // Check every hour
  Timer? _cleanupTimer;
  final FirestoreDatabaseRepository _db = FirestoreDatabaseRepository();

  static final GroupChatCleanupService _instance =
      GroupChatCleanupService._internal();
  factory GroupChatCleanupService() => _instance;
  GroupChatCleanupService._internal();

  /// Start the automatic cleanup service
  void startCleanupService() {
    if (_cleanupTimer?.isActive == true) return; // Already running

    // Run initial cleanup
    _performCleanup();

    // Schedule periodic cleanup
    _cleanupTimer = Timer.periodic(_cleanupInterval, (_) {
      _performCleanup();
    });
  }

  /// Stop the automatic cleanup service
  void stopCleanupService() {
    _cleanupTimer?.cancel();
    _cleanupTimer = null;
  }

  /// Perform the cleanup operation
  Future<void> _performCleanup() async {
    try {
      await _db.deleteExpiredGroupChats();
    } catch (_) {}
  }

  /// Manually trigger cleanup (useful for testing or immediate cleanup)
  Future<void> triggerCleanup() async {
    await _performCleanup();
  }

  /// Check if cleanup service is running
  bool get isRunning => _cleanupTimer?.isActive == true;
}

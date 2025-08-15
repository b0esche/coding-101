import '../app_imports.dart';

/// Firebase Cost Optimization Manager
///
/// Centralized service to monitor and optimize Firebase usage costs
/// Provides real-time cost tracking, usage analytics, and optimization recommendations
class FirebaseCostManager {
  static final FirebaseCostManager _instance = FirebaseCostManager._internal();
  factory FirebaseCostManager() => _instance;
  FirebaseCostManager._internal();

  final FirebaseQueryOptimizer _optimizer = FirebaseQueryOptimizer();
  final CacheService _cache = CacheService();

  // Global settings for cost optimization
  bool _aggressiveCachingEnabled = true;
  bool _offlineModeEnabled = true;
  bool _costMonitoringEnabled = true;
  int _maxDailyReads = 10000; // Alert threshold

  /// Initialize cost optimization settings
  void initialize({
    bool aggressiveCaching = true,
    bool offlineMode = true,
    bool costMonitoring = true,
    int maxDailyReads = 10000,
  }) {
    _aggressiveCachingEnabled = aggressiveCaching;
    _offlineModeEnabled = offlineMode;
    _costMonitoringEnabled = costMonitoring;
    _maxDailyReads = maxDailyReads;

    // Configure Firebase for optimal performance
    if (_offlineModeEnabled) {
      _optimizer.enablePersistence();
    }

    _optimizer.optimizeForMobile();
  }

  /// Get comprehensive cost and usage statistics
  Map<String, dynamic> getUsageStats() {
    final optimizerStats = _optimizer.stats;
    final cacheStats = _cache.stats;

    return {
      'firebase': optimizerStats,
      'cache': cacheStats,
      'optimization': {
        'aggressiveCaching': _aggressiveCachingEnabled,
        'offlineMode': _offlineModeEnabled,
        'costMonitoring': _costMonitoringEnabled,
        'maxDailyReads': _maxDailyReads,
      },
      'recommendations': getCostOptimizationRecommendations(),
    };
  }

  /// Get personalized cost optimization recommendations
  List<String> getCostOptimizationRecommendations() {
    final recommendations = <String>[];
    final stats = _optimizer.stats;
    final cacheStats = _cache.stats;

    // Firebase-specific recommendations
    recommendations.addAll(_optimizer.getCostOptimizationRecommendations());

    // Cache-specific recommendations
    final hitRate = cacheStats['hitRate'] as double;
    if (hitRate < 0.5) {
      recommendations.add(
        'Cache hit rate is low (${(hitRate * 100).toStringAsFixed(1)}%) - consider longer TTL values',
      );
    }

    // Memory usage recommendations
    final totalCacheSize =
        (cacheStats['chatMessagesCacheSize'] as int) +
        (cacheStats['groupMessagesCacheSize'] as int) +
        (cacheStats['usersCacheSize'] as int);

    if (totalCacheSize > 80) {
      recommendations.add(
        'Cache size is large ($totalCacheSize entries) - consider cache cleanup',
      );
    }

    // Daily usage alerts
    final dailyReads = stats['totalReads'] as int;
    if (dailyReads > _maxDailyReads) {
      recommendations.add(
        'Daily read quota exceeded ($dailyReads/$_maxDailyReads) - review query patterns',
      );
    }

    return recommendations;
  }

  /// Smart preloading strategy for chat data
  Future<void> preloadEssentialChatData(String userId) async {
    if (!_aggressiveCachingEnabled) return;

    try {
      // Preload only the most essential data
      await _optimizer.preloadFrequentData(userId);

      // Preload recent chat list
      final recentChats = await _optimizer.getOptimizedChatList(
        userId: userId,
        limit: 10, // Only most recent chats
      );

      // Cache the essential user data for chat partners
      final partnerIds = <String>{};
      for (final chat in recentChats) {
        final data = chat.data() as Map<String, dynamic>;
        final participants = List<String>.from(data['participants'] ?? []);
        partnerIds.addAll(participants.where((id) => id != userId));
      }

      if (partnerIds.isNotEmpty) {
        await _optimizer.batchGetUsers(
          partnerIds.take(5).toList(),
        ); // Limit batch size
      }
    } catch (e) {
      // Silent fail - preloading is optional
    }
  }

  /// Optimize real-time listeners to reduce costs
  StreamSubscription<T>? createOptimizedListener<T>({
    required Stream<T> stream,
    required void Function(T) onData,
    String? identifier,
    Duration throttle = const Duration(seconds: 2),
  }) {
    if (!_costMonitoringEnabled) {
      return stream.listen(onData);
    }

    // Throttle updates to reduce Firebase read operations
    Stream<T> throttledStream = stream;

    if (throttle.inMilliseconds > 0) {
      DateTime? lastUpdate;
      throttledStream = stream.where((data) {
        final now = DateTime.now();
        if (lastUpdate == null || now.difference(lastUpdate!) >= throttle) {
          lastUpdate = now;
          return true;
        }
        return false;
      });
    }

    return throttledStream.listen((data) {
      if (_costMonitoringEnabled && identifier != null) {
        _logListenerActivity(identifier);
      }
      onData(data);
    });
  }

  void _logListenerActivity(String identifier) {
    // Log listener activity for cost analysis
    debugPrint('Firebase Listener Activity: $identifier at ${DateTime.now()}');
  }

  /// Clean up resources and optimize memory usage
  Future<void> cleanup() async {
    // Clear expired cache entries
    _cache.clearExpiredEntries();

    // Reset daily statistics if needed
    if (_shouldResetDailyStats()) {
      _optimizer.resetStats();
    }
  }

  bool _shouldResetDailyStats() {
    // Implement daily reset logic based on last reset timestamp
    // For simplicity, this is a placeholder
    return false;
  }

  /// Show cost optimization dialog to user
  void showCostOptimizationDialog(BuildContext context) {
    final stats = getUsageStats();
    final recommendations = getCostOptimizationRecommendations();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Palette.primalBlack,
            title: Text(
              'Firebase Usage & Costs',
              style: TextStyle(color: Palette.glazedWhite),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildStatSection('Firebase Operations', stats['firebase']),
                  const SizedBox(height: 16),
                  _buildStatSection('Cache Performance', stats['cache']),
                  const SizedBox(height: 16),
                  if (recommendations.isNotEmpty) ...[
                    Text(
                      'Recommendations:',
                      style: TextStyle(
                        color: Palette.forgedGold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...recommendations.map(
                      (rec) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          '• $rec',
                          style: TextStyle(
                            color: Palette.glazedWhite.o(0.8),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Close',
                  style: TextStyle(color: Palette.forgedGold),
                ),
              ),
              TextButton(
                onPressed: () {
                  cleanup();
                  Navigator.pop(context);
                },
                child: Text(
                  'Optimize Now',
                  style: TextStyle(color: Palette.forgedGold),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildStatSection(String title, Map<String, dynamic> stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Palette.forgedGold,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        ...stats.entries.map(
          (entry) => Text(
            '${entry.key}: ${entry.value}',
            style: TextStyle(color: Palette.glazedWhite.o(0.8), fontSize: 12),
          ),
        ),
      ],
    );
  }

  /// Export usage data for external analysis
  Map<String, dynamic> exportUsageData() {
    return {
      'timestamp': DateTime.now().toIso8601String(),
      'stats': getUsageStats(),
      'settings': {
        'aggressiveCaching': _aggressiveCachingEnabled,
        'offlineMode': _offlineModeEnabled,
        'costMonitoring': _costMonitoringEnabled,
        'maxDailyReads': _maxDailyReads,
      },
    };
  }
}

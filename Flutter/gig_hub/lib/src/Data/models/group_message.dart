import 'package:cloud_firestore/cloud_firestore.dart';

class GroupMessage {
  final String id;
  final String groupChatId;
  final String senderId;
  final String senderName;
  final String? senderAvatarUrl;
  final String message;
  final DateTime timestamp;
  final Map<String, bool> readBy; // userId -> isRead

  GroupMessage({
    required this.id,
    required this.groupChatId,
    required this.senderId,
    required this.senderName,
    this.senderAvatarUrl,
    required this.message,
    required this.timestamp,
    this.readBy = const {},
  });

  factory GroupMessage.fromJson(String id, Map<String, dynamic> json) {
    final Timestamp? ts =
        json['timestamp'] is Timestamp ? json['timestamp'] : null;

    return GroupMessage(
      id: id,
      groupChatId: json['groupChatId'] ?? '',
      senderId: json['senderId'] ?? '',
      senderName: json['senderName'] ?? 'Unknown',
      senderAvatarUrl: json['senderAvatarUrl'],
      message: json['message'] ?? '',
      timestamp: ts?.toDate() ?? DateTime.now(),
      readBy: Map<String, bool>.from(json['readBy'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupChatId': groupChatId,
      'senderId': senderId,
      'senderName': senderName,
      'senderAvatarUrl': senderAvatarUrl,
      'message': message,
      'timestamp': Timestamp.fromDate(timestamp),
      'readBy': readBy,
    };
  }

  bool isReadBy(String userId) {
    return readBy[userId] ?? false;
  }

  GroupMessage markAsReadBy(String userId) {
    final newReadBy = Map<String, bool>.from(readBy);
    newReadBy[userId] = true;

    return GroupMessage(
      id: id,
      groupChatId: groupChatId,
      senderId: senderId,
      senderName: senderName,
      senderAvatarUrl: senderAvatarUrl,
      message: message,
      timestamp: timestamp,
      readBy: newReadBy,
    );
  }

  int get unreadCount {
    return readBy.values.where((isRead) => !isRead).length;
  }
}

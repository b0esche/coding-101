import 'package:cloud_firestore/cloud_firestore.dart';

class GroupChat {
  final String id;
  final String raveId;
  final String name;
  final List<String> memberIds;
  final String? lastMessage;
  final String? lastMessageSenderId;
  final DateTime? lastMessageTimestamp;
  final DateTime createdAt;
  final DateTime? autoDeleteAt; // 48 hours after rave end
  final bool isActive;
  final String? imageUrl;

  GroupChat({
    required this.id,
    required this.raveId,
    required this.name,
    required this.memberIds,
    this.lastMessage,
    this.lastMessageSenderId,
    this.lastMessageTimestamp,
    required this.createdAt,
    this.autoDeleteAt,
    this.isActive = true,
    this.imageUrl,
  });

  factory GroupChat.fromJson(String id, Map<String, dynamic> json) {
    return GroupChat(
      id: id,
      raveId: json['raveId'] ?? '',
      name: json['name'] ?? '',
      memberIds: List<String>.from(json['memberIds'] ?? []),
      lastMessage: json['lastMessage'],
      lastMessageSenderId: json['lastMessageSenderId'],
      lastMessageTimestamp:
          json['lastMessageTimestamp'] != null
              ? (json['lastMessageTimestamp'] as Timestamp).toDate()
              : null,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      autoDeleteAt:
          json['autoDeleteAt'] != null
              ? (json['autoDeleteAt'] as Timestamp).toDate()
              : null,
      isActive: json['isActive'] ?? true,
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'raveId': raveId,
      'name': name,
      'memberIds': memberIds,
      'lastMessage': lastMessage,
      'lastMessageSenderId': lastMessageSenderId,
      'lastMessageTimestamp':
          lastMessageTimestamp != null
              ? Timestamp.fromDate(lastMessageTimestamp!)
              : null,
      'createdAt': Timestamp.fromDate(createdAt),
      'autoDeleteAt':
          autoDeleteAt != null ? Timestamp.fromDate(autoDeleteAt!) : null,
      'isActive': isActive,
      'imageUrl': imageUrl,
    };
  }

  GroupChat copyWith({
    String? id,
    String? raveId,
    String? name,
    List<String>? memberIds,
    String? lastMessage,
    String? lastMessageSenderId,
    DateTime? lastMessageTimestamp,
    DateTime? createdAt,
    DateTime? autoDeleteAt,
    bool? isActive,
    String? imageUrl,
  }) {
    return GroupChat(
      id: id ?? this.id,
      raveId: raveId ?? this.raveId,
      name: name ?? this.name,
      memberIds: memberIds ?? this.memberIds,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageSenderId: lastMessageSenderId ?? this.lastMessageSenderId,
      lastMessageTimestamp: lastMessageTimestamp ?? this.lastMessageTimestamp,
      createdAt: createdAt ?? this.createdAt,
      autoDeleteAt: autoDeleteAt ?? this.autoDeleteAt,
      isActive: isActive ?? this.isActive,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

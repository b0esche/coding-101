class Rave {
  final String id;
  final String name;
  final String organizerId; // The booker who created it
  final DateTime startDate;
  final DateTime? endDate; // For festivals
  final String startTime; // 'doors' time
  final String location;
  final String description;
  final String? ticketShopLink;
  final String? additionalLink;
  final List<String> djIds;
  final List<String> collaboratorIds; // Other bookers
  final List<String> attendingUserIds;
  final bool hasGroupChat;
  final String? groupChatId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Rave({
    required this.id,
    required this.name,
    required this.organizerId,
    required this.startDate,
    this.endDate,
    required this.startTime,
    required this.location,
    required this.description,
    this.ticketShopLink,
    this.additionalLink,
    required this.djIds,
    required this.collaboratorIds,
    required this.attendingUserIds,
    required this.hasGroupChat,
    this.groupChatId,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isMultiDay => endDate != null;

  bool get isUpcoming => startDate.isAfter(DateTime.now());

  bool get isFinished {
    final endDateTime = endDate ?? startDate;
    return endDateTime.add(Duration(days: 1)).isBefore(DateTime.now());
  }

  int get attendingCount => attendingUserIds.length;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'organizerId': organizerId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'startTime': startTime,
      'location': location,
      'description': description,
      'ticketShopLink': ticketShopLink,
      'additionalLink': additionalLink,
      'djIds': djIds,
      'collaboratorIds': collaboratorIds,
      'attendingUserIds': attendingUserIds,
      'hasGroupChat': hasGroupChat,
      'groupChatId': groupChatId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Rave.fromJson(Map<String, dynamic> json) {
    return Rave(
      id: json['id'],
      name: json['name'],
      organizerId: json['organizerId'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      startTime: json['startTime'],
      location: json['location'],
      description: json['description'],
      ticketShopLink: json['ticketShopLink'],
      additionalLink: json['additionalLink'],
      djIds: List<String>.from(json['djIds'] ?? []),
      collaboratorIds: List<String>.from(json['collaboratorIds'] ?? []),
      attendingUserIds: List<String>.from(json['attendingUserIds'] ?? []),
      hasGroupChat: json['hasGroupChat'] ?? false,
      groupChatId: json['groupChatId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Rave copyWith({
    String? id,
    String? name,
    String? organizerId,
    DateTime? startDate,
    DateTime? endDate,
    String? startTime,
    String? location,
    String? description,
    String? ticketShopLink,
    String? additionalLink,
    List<String>? djIds,
    List<String>? collaboratorIds,
    List<String>? attendingUserIds,
    bool? hasGroupChat,
    String? groupChatId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Rave(
      id: id ?? this.id,
      name: name ?? this.name,
      organizerId: organizerId ?? this.organizerId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTime: startTime ?? this.startTime,
      location: location ?? this.location,
      description: description ?? this.description,
      ticketShopLink: ticketShopLink ?? this.ticketShopLink,
      additionalLink: additionalLink ?? this.additionalLink,
      djIds: djIds ?? this.djIds,
      collaboratorIds: collaboratorIds ?? this.collaboratorIds,
      attendingUserIds: attendingUserIds ?? this.attendingUserIds,
      hasGroupChat: hasGroupChat ?? this.hasGroupChat,
      groupChatId: groupChatId ?? this.groupChatId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

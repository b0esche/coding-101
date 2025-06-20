import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String customerId,
      username,
      deliveryStreet,
      deliveryHouseNumber,
      deliveryZipCode,
      deliveryCity,
      userEmail;
  final String? phoneNumber, avatarUrl;
  final bool isVerified;
  final List<String>? wishlist, orderHistoryIds;
  final DateTime? lastLogin;
  final DateTime createdAt;

  AppUser({
    required this.customerId,
    required this.username,
    required this.deliveryStreet,
    required this.deliveryHouseNumber,
    required this.deliveryZipCode,
    required this.deliveryCity,
    required this.userEmail,
    this.phoneNumber,
    this.avatarUrl,
    this.isVerified = false,
    this.wishlist = const [],
    this.orderHistoryIds = const [],
    this.lastLogin,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory AppUser.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Missing user data for document ID: ${doc.id}');
    }

    return AppUser(
      customerId: data['customerId'] ?? doc.id,
      username: data['username'] ?? '',
      deliveryStreet: data['deliveryStreet'] ?? '',
      deliveryHouseNumber: data['deliveryHouseNumber'] ?? '',
      deliveryZipCode: data['deliveryZipCode'] ?? '',
      deliveryCity: data['deliveryCity'] ?? '',
      userEmail: data['userEmail'] ?? '',
      phoneNumber: data['phoneNumber'],
      avatarUrl: data['avatarUrl'],
      isVerified: data['isVerified'] ?? false,
      wishlist: List<String>.from(data['wishlist'] ?? []),
      orderHistoryIds: List<String>.from(data['orderHistoryIds'] ?? []),
      lastLogin:
          data['lastLogin'] != null
              ? (data['lastLogin'] as Timestamp).toDate()
              : null,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'customerId': customerId,
    'username': username,
    'deliveryStreet': deliveryStreet,
    'deliveryHouseNumber': deliveryHouseNumber,
    'deliveryZipCode': deliveryZipCode,
    'deliveryCity': deliveryCity,
    'userEmail': userEmail,
    'phoneNumber': phoneNumber,
    'avatarUrl': avatarUrl,
    'isVerified': isVerified,
    'wishlist': wishlist,
    'orderHistoryIds': orderHistoryIds,
    'lastLogin': lastLogin != null ? Timestamp.fromDate(lastLogin!) : null,
    'createdAt': Timestamp.fromDate(createdAt),
  };
}

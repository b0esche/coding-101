import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gig_hub/src/Data/app_imports.dart';

class FirestoreDatabaseRepository extends DatabaseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// USER ###

  // create ###
  @override
  Future<void> createGuest(Guest guest) async {
    final docRef = _firestore.collection('users').doc(guest.id);
    await docRef.set(guest.toJson());
  }

  @override
  Future<void> createDJ(DJ dj) async {
    final docRef = _firestore.collection('users').doc(dj.id);
    await docRef.set(dj.toJson());
  }

  @override
  Future<void> createBooker(Booker booker) async {
    final docRef = _firestore.collection('users').doc(booker.id);
    await docRef.set(booker.toJson());
  }

  // delete ###
  @override
  Future<void> deleteGuest(Guest guest) async {
    await _firestore.collection('users').doc(guest.id).delete();
  }

  @override
  Future<void> deleteDJ(DJ dj) async {
    await _firestore.collection('users').doc(dj.id).delete();
  }

  @override
  Future<void> deleteBooker(Booker booker) async {
    await _firestore.collection('users').doc(booker.id).delete();
  }

  // update ###
  @override
  Future<void> updateGuest(Guest guest) async {
    await _firestore.collection('users').doc(guest.id).update({
      'favoriteUIds': guest.favoriteUIds,
    });
  }

  @override
  Future<void> updateDJ(DJ dj) async {
    await _firestore.collection('users').doc(dj.id).update({
      'name': dj.name,
      'city': dj.city,
      'about': dj.about,
      'info': dj.info,
      'headImageUrl': dj.headImageUrl,
      'avatarImageUrl': dj.avatarImageUrl,
      'genres': dj.genres,
      'bpm': dj.bpm,
      'streamingUrls': dj.streamingUrls,
      'mediaImageUrls': dj.mediaImageUrls,
      'favoriteUIds': dj.favoriteUIds,
    });
    notifyListeners();
  }

  @override
  Future<void> updateBooker(Booker booker) async {
    await _firestore.collection('users').doc(booker.id).update({
      'name': booker.name,
      'city': booker.city,
      'about': booker.about,
      'info': booker.info,
      'headImageUrl': booker.headImageUrl,
      'avatarImageUrl': booker.avatarImageUrl,
      'mediaImageUrls': booker.mediaImageUrls,
      'category': booker.category,
      'favoriteUIds': booker.favoriteUIds,
    });
  }

  // read ###
  @override
  Future<DJ> getProfileDJ() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception("no authenticated user");
    final snapshot = await _firestore.collection('users').doc(uid).get();
    final data = snapshot.data();
    if (data == null || data['type'] != 'dj') throw Exception("DJ not found");
    return DJ.fromJson(uid, data);
  }

  @override
  Future<Booker> getProfileBooker() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception("no authenticated user");
    final snapshot = await _firestore.collection('users').doc(uid).get();
    final data = snapshot.data();
    if (data == null || data['type'] != 'booker') {
      throw Exception("booker not found");
    }
    return Booker.fromJson(uid, data);
  }

  @override
  Future<List<DJ>> getDJs() async {
    final currentUser = await getCurrentUser();

    final blockedSnapshot =
        await _firestore
            .collection('users')
            .doc(currentUser.id)
            .collection('blocks')
            .get();

    final blockedUids = blockedSnapshot.docs.map((doc) => doc.id).toSet();

    final snapshot =
        await _firestore
            .collection('users')
            .where('type', isEqualTo: 'dj')
            .get();

    return snapshot.docs
        .where(
          (doc) => doc.id != currentUser.id && !blockedUids.contains(doc.id),
        )
        .map((doc) => DJ.fromJson(doc.id, doc.data()))
        .toList();
  }

  @override
  Future<List<DJ>> getFavoriteDJs(String userId) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    final data = userDoc.data();

    final favoriteIds = List<String>.from(data?['favoriteUIds'] ?? []);

    final List<DJ> favoriteDJs = [];

    for (final id in favoriteIds) {
      final doc = await _firestore.collection('users').doc(id).get();

      if (doc.exists) {
        final type = doc.data()?['type'];
        if (type?.toString().toLowerCase() == 'dj') {
          favoriteDJs.add(DJ.fromJson(doc.id, doc.data()!));
        }
      }
    }

    return favoriteDJs;
  }

  @override
  Future<List<DJ>> searchDJs({
    String? city,
    List<String>? genres,
    List<int>? bpmRange,
  }) async {
    final all = await getDJs();
    return all.where((dj) {
      final matchesCity =
          city == null ||
          city.trim().isEmpty ||
          dj.city.toLowerCase().contains(city.toLowerCase());
      final matchesGenres =
          genres == null ||
          genres.isEmpty ||
          genres.any((g) => dj.genres.contains(g));
      final matchesBpm =
          bpmRange == null ||
          bpmRange.length != 2 ||
          (dj.bpm.last >= bpmRange[0] && dj.bpm.first <= bpmRange[1]);
      return matchesCity && matchesGenres && matchesBpm;
    }).toList();
  }

  /// CHAT ###

  @override
  Future<void> sendMessage(ChatMessage message) async {
    final chatId = getChatId(message.senderId, message.receiverId);
    final docRef =
        _firestore.collection('chats').doc(chatId).collection('messages').doc();

    final newMessage = ChatMessage(
      id: docRef.id,
      senderId: message.senderId,
      receiverId: message.receiverId,
      message: message.message,
      timestamp: message.timestamp,
      read: message.read,
    );

    await docRef.set(newMessage.toJson());
    final chatDoc = _firestore.collection('chats').doc(chatId);

    await chatDoc.set({
      'lastMessage': newMessage.message,
      'lastTimestamp': FieldValue.serverTimestamp(),
      'participants': [message.senderId, message.receiverId],
      'lastMessageId': newMessage.id,
      'lastSenderId': newMessage.senderId,
    }, SetOptions(merge: true));
  }

  @override
  Stream<List<ChatMessage>> getChatsStream(String userId) {
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .snapshots()
        .asyncMap((querySnapshot) async {
          List<ChatMessage> allMessages = [];

          for (var doc in querySnapshot.docs) {
            final data = doc.data();
            final chatId = doc.id;
            final lastMessage = data['lastMessage'] as String? ?? '';
            final timestamp = (data['lastTimestamp'] as Timestamp?)?.toDate();
            final participants = List<String>.from(data['participants'] ?? []);
            final senderId = data['lastSenderId'] as String? ?? userId;

            final receiverId = participants.firstWhere(
              (id) => id != userId,
              orElse: () => '',
            );

            if (receiverId.isEmpty || timestamp == null) continue;

            final messagesQuery =
                await _firestore
                    .collection('chats')
                    .doc(chatId)
                    .collection('messages')
                    .orderBy('timestamp', descending: true)
                    .limit(1)
                    .get();

            String messageId = chatId;
            bool read = false;
            if (messagesQuery.docs.isNotEmpty) {
              final lastMsgDoc = messagesQuery.docs.first;
              final lastMsgData = lastMsgDoc.data();
              messageId = lastMsgDoc.id;
              read = lastMsgData['read'] ?? false;
            }

            allMessages.add(
              ChatMessage(
                id: messageId,
                senderId: senderId,
                receiverId: receiverId,
                message: lastMessage,
                timestamp: timestamp,
                read: read,
              ),
            );
          }

          return allMessages;
        });
  }

  @override
  Stream<List<ChatMessage>> getMessagesStream(
    String senderId,
    String receiverId,
  ) {
    final chatId = getChatId(senderId, receiverId);
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) {
                final data = doc.data();
                return ChatMessage.fromJson(doc.id, data);
              }).toList(),
        );
  }

  /// UTILS ###
  @override
  Future<void> blockUser(String currentUid, String targetUid) async {
    final firestore = FirebaseFirestore.instance;

    final now = FieldValue.serverTimestamp();

    final currentUserBlockRef = firestore
        .collection('users')
        .doc(currentUid)
        .collection('blocks')
        .doc(targetUid);

    await currentUserBlockRef.set({'timestamp': now});
  }

  @override
  Future<void> unblockUser(String currentUid, String targetUid) async {
    final firestore = FirebaseFirestore.instance;

    final currentUserBlockRef = firestore
        .collection('users')
        .doc(currentUid)
        .collection('blocks')
        .doc(targetUid);

    await currentUserBlockRef.delete();
  }

  @override
  Future<List<AppUser>> getBlockedUsers(String currentUid) async {
    final firestore = FirebaseFirestore.instance;

    final blockedSnapshot =
        await firestore
            .collection('users')
            .doc(currentUid)
            .collection('blocks')
            .get();

    final blockedUids = blockedSnapshot.docs.map((doc) => doc.id).toList();

    List<AppUser> blockedUsers = [];

    for (final uid in blockedUids) {
      try {
        final userDoc = await firestore.collection('users').doc(uid).get();
        if (userDoc.exists && userDoc.data() != null) {
          final data = userDoc.data()!;
          final type = data['type'] as String? ?? 'guest';

          switch (type) {
            case 'dj':
              blockedUsers.add(DJ.fromJson(uid, data));
              break;
            case 'booker':
              blockedUsers.add(Booker.fromJson(uid, data));
              break;
            case 'guest':
              blockedUsers.add(Guest.fromJson(uid, data));
              break;
          }
        }
      } catch (e) {
        // Skip users that can't be loaded
        continue;
      }
    }

    return blockedUsers;
  }

  Future<List<ChatMessage>> getMessages(String userId, String partnerId) async {
    final chatId = getChatId(userId, partnerId);
    final snapshot =
        await _firestore
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .orderBy('timestamp')
            .get();
    return snapshot.docs
        .map((doc) => ChatMessage.fromJson(doc.id, doc.data()))
        .toList();
  }

  Future<void> markMessageAsRead(
    String messageId,
    String userId,
    String partnerId,
    String currentUserId,
  ) async {
    final chatId = getChatId(userId, partnerId);
    final ref = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId);
    await ref.update({'read': true});
  }

  @override
  Future<void> deleteMessage(
    String chatId,
    String messageId,
    String currentUserId,
  ) async {
    final messageRef = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId);
    final msgDoc = await messageRef.get();
    if (!msgDoc.exists) {
      throw Exception('message not found');
    }
    final data = msgDoc.data();
    if (data == null || data['senderId'] != currentUserId) {
      throw Exception('You can only delete your own messages');
    }
    await messageRef.delete();
  }

  @override
  Future<void> deleteChat(String userId, String partnerId) async {
    final chatId = getChatId(userId, partnerId);
    final chatDoc = _firestore.collection('chats').doc(chatId);

    final messagesQuery = await chatDoc.collection('messages').get();
    for (final msgDoc in messagesQuery.docs) {
      await msgDoc.reference.delete();
    }

    await chatDoc.delete();
  }

  @override
  String getChatId(String uid1, String uid2) {
    final sorted = [uid1, uid2]..sort();
    return sorted.join('_');
  }

  @override
  Future<AppUser> getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("no user logged in");

    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

    if (!doc.exists || doc.data() == null) {
      throw Exception("failed to load user data");
    }

    final data = doc.data()!;

    final type = data['type'] as String? ?? 'guest';

    switch (type) {
      case 'dj':
        return DJ.fromJson(user.uid, data);
      case 'booker':
        return Booker.fromJson(user.uid, data);
      case 'guest':
        return Guest.fromJson(user.uid, data);
      default:
        throw Exception("Unknown user type: $type");
    }
  }

  @override
  Future<AppUser> getUserById(String id) async {
    final doc = await _firestore.collection('users').doc(id).get();
    if (!doc.exists) throw Exception("user id '$id' nicht not found");

    final data = doc.data();
    if (data == null) throw Exception("no data for user");

    final type = data['type'] as String?;

    switch (type) {
      case 'dj':
        return DJ.fromJson(id, data);
      case 'booker':
        return Booker.fromJson(id, data);
      case 'guest':
        return Guest.fromJson(id, data);
      default:
        throw Exception("unknown user type: $type");
    }
  }

  @override
  Future<void> updateUser(AppUser user) async {
    if (user is DJ) {
      await updateDJ(user);
    } else if (user is Booker) {
      await updateBooker(user);
    } else if (user is Guest) {
      await updateGuest(user);
    }
    notifyListeners();
  }

  @override
  Future<void> initFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();

    String? token = await messaging.getToken();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && token != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {'fcmToken': token},
      );
    }

    messaging.onTokenRefresh.listen((newToken) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'fcmToken': newToken});
      }
    });
  }
}

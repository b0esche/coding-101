import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gig_hub/src/Data/app_imports.dart';
import 'package:gig_hub/src/Features/chat/domain/chat_message.dart';

class FirestoreDatabaseRepository extends DatabaseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// ---------------------- USER ----------------------

  // create ###

  @override
  Future<void> createGuest(Guest guest) async {
    final docRef = _firestore.collection('users').doc(guest.id);
    await docRef.set({
      'id': guest.id,
      'type': guest.type.name,
      'favoriteUIds': guest.favoriteUIds,
    });
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
      'favoriteUIds': booker.favoriteUIds,
    });
  }

  // read ###
  @override
  Future<DJ> getProfileDJ() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception("No authenticated user");
    final snapshot = await _firestore.collection('users').doc(uid).get();
    final data = snapshot.data();
    if (data == null || data['type'] != 'dj') throw Exception("DJ not found");
    return DJ.fromJson(uid, data);
  }

  @override
  Future<Booker> getProfileBooker() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception("No authenticated user");
    final snapshot = await _firestore.collection('users').doc(uid).get();
    final data = snapshot.data();
    if (data == null || data['type'] != 'booker') {
      throw Exception("Booker not found");
    }
    return Booker.fromJson(uid, data);
  }

  @override
  Future<List<DJ>> getDJs() async {
    final snapshot =
        await _firestore
            .collection('users')
            .where('type', isEqualTo: 'dj')
            .get();
    return snapshot.docs.map((doc) => DJ.fromJson(doc.id, doc.data())).toList();
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

  /// ---------------------- CHAT ----------------------

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
    );

    await docRef.set(newMessage.toJson());
  }

  @override
  Future<List<ChatMessage>> getMessages(
    String senderId,
    String receiverId,
  ) async {
    final chatId = getChatId(senderId, receiverId);
    final snapshot =
        await _firestore
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .orderBy('timestamp')
            .get();

    return snapshot.docs
        .map((doc) => ChatMessage.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<List<ChatMessage>> getChats(String userId) async {
    final querySnapshot = await _firestore.collection('chats').get();
    List<ChatMessage> allMessages = [];

    for (var doc in querySnapshot.docs) {
      final messagesSnapshot =
          await doc.reference
              .collection('messages')
              .orderBy('timestamp', descending: true)
              .limit(1)
              .get();

      if (messagesSnapshot.docs.isNotEmpty) {
        final lastMessage = ChatMessage.fromJson(
          messagesSnapshot.docs.first.data(),
        );
        if (lastMessage.senderId == userId ||
            lastMessage.receiverId == userId) {
          allMessages.add(lastMessage);
        }
      }
    }

    allMessages.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return allMessages;
  }

  /// ---------------------- UTILS ----------------------

  @override
  String getChatId(String uid1, String uid2) {
    final sorted = [uid1, uid2]..sort();
    return sorted.join('_');
  }

  @override
  Future<AppUser> getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("Kein eingeloggter User");

    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
    if (!doc.exists) throw Exception("User-Dokument nicht gefunden");

    final data = doc.data();
    if (data == null) throw Exception("Keine Daten im User-Dokument");

    final type = data['type'] as String?;

    switch (type) {
      case 'dj':
        return DJ.fromJson(user.uid, data);
      case 'booker':
        return Booker.fromJson(user.uid, data);
      case 'guest':
        return Guest.fromJson(user.uid, data);
      default:
        throw Exception("Unbekannter Benutzer-Typ: $type");
    }
  }

  @override
  Future<AppUser> getUserById(String id) async {
    final doc = await _firestore.collection('users').doc(id).get();
    if (!doc.exists) throw Exception("User mit ID '$id' nicht gefunden");

    final data = doc.data();
    if (data == null) throw Exception("Keine Daten im User-Dokument");

    final type = data['type'] as String?;

    switch (type) {
      case 'dj':
        return DJ.fromJson(id, data);
      case 'booker':
        return Booker.fromJson(id, data);
      case 'guest':
        return Guest.fromJson(id, data);
      default:
        throw Exception("Unbekannter Benutzer-Typ: $type");
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
  }
}

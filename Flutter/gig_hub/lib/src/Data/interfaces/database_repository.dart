import 'package:gig_hub/src/Data/app_imports.dart';

abstract class DatabaseRepository with ChangeNotifier {
  // create user ###
  Future<void> createGuest(Guest guest);
  Future<void> createDJ(DJ user);
  Future<void> createBooker(Booker user);

  // delete user ###
  Future<void> deleteGuest(Guest user);
  Future<void> deleteDJ(DJ user);
  Future<void> deleteBooker(Booker user);

  // update user ###
  Future<void> updateGuest(Guest user);
  Future<void> updateDJ(DJ user);
  Future<void> updateBooker(Booker user);

  // get user ###
  Future<DJ> getProfileDJ();
  Future<Booker> getProfileBooker();
  Future<List<DJ>> getDJs();
  Future<List<DJ>> searchDJs({
    String? city,
    List<String>? genres,
    List<int>? bpmRange,
  });
  Future<List<DJ>> getFavoriteDJs(String userId);

  // chat ###
  Future<void> sendMessage(ChatMessage message);
  Stream<List<ChatMessage>> getChatsStream(String userId);
  String getChatId(String uid1, String uid2);
  Stream<List<ChatMessage>> getMessagesStream(
    String senderId,
    String receiverId,
  );
  Future<void> deleteChat(String userId, String partnerId);
  Future<void> deleteMessage(
    String chatId,
    String messageId,
    String currentUserId,
  );

  // utils ###
  Future<void> blockUser(String currentUid, String targetUid);
  Future<void> unblockUser(String currentUid, String targetUid);
  Future<List<AppUser>> getBlockedUsers(String currentUid);
  Future<AppUser> getCurrentUser();
  Future<AppUser> getUserById(String id);
  Future<void> updateUser(AppUser user);
  Future<void> initFirebaseMessaging();

  // status messages ###
  Future<void> createStatusMessage(StatusMessage statusMessage);
  Future<StatusMessage?> getActiveStatusMessage(String userId);
  Future<void> deleteStatusMessage(String statusMessageId);
}

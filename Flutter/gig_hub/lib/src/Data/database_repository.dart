import '../Features/chat/domain/chat_message.dart';
import 'users.dart';

abstract class DatabaseRepository {
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

  // chat ###
  Future<void> sendMessage(ChatMessage message);
  Future<List<ChatMessage>> getChats(String userId);
  String getChatId(String uid1, String uid2);
  Stream<List<ChatMessage>> getMessagesStream(
    String senderId,
    String receiverId,
  );

  // utils ###
  Future<AppUser> getCurrentUser();
  Future<AppUser> getUserById(String id);
  Future<void> updateUser(AppUser user);
}

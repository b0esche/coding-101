import 'search_list_item.dart';
import 'chat.dart';
import 'user.dart';


abstract class DatabaseRepository {
  void addUser(User user);
  List<User> getUsers();
  void SendMessage(ChatMessage message);
  List<ChatMessage> getMessages(String userId1, String userId2);
  List<SearchListItem> searchDJs(
    List<String>? genres,
    String? city,
    int? bpmMin,
    int? bpmMax,
  );
}

class MockDatabaseRepository implements DatabaseRepository {
  final List<User> _users = [];
  final List<ChatMessage> _messages = [];
 

  @override
  void addUser(User user) {
    _users.add(user);
  }

  @override
  List<User> getUsers() {
    return _users;
  }

  @override
  void SendMessage(ChatMessage message) {
    _messages.add(message);
  }

  @override
  List<ChatMessage> getMessages(String userId1, String userId2) {
    return _messages
        .where(
          (message) =>
              (message.senderId == userId1 && message.receiverId == userId2) ||
              (message.senderId == userId2 && message.receiverId == userId1),
        )
        .toList();
  }

  @override
  List<SearchListItem> searchDJs(
    List<String>? genres,
    String? city,
    int? bpmMin,
    int? bpmMax,
  ) {
    if (bpmMin != null && bpmMax != null && bpmMin > bpmMax) {
      return [];
    }
    return _users
        .where((user) => user.userType == UserType.dj)
        .cast<DJ>()
        .where(
          (dj) =>
              (genres == null ||
                  genres.isEmpty ||
                  genres.any((g) => dj.genres.contains(g))) &&
              (city == null || dj.city == city) &&
              (bpmMin == null || dj.bpmMax >= bpmMin) &&
              (bpmMax == null || dj.bpmMin <= bpmMax),
        )
        .map((dj) => SearchListItem(dj: dj))
        .toList();
  }
}

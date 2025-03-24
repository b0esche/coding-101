import 'chat.dart';
import 'user.dart';

abstract class DatabaseRepository {
  void addUser(User user);
  List<User> getUsers();
  void SendMessage(ChatMessage message);
  List<ChatMessage> getMessages(String userId1, String userId2);
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
        .where((msg) =>
            (msg.senderId == userId1 && msg.receiverId == userId2) ||
            (msg.senderId == userId2 && msg.receiverId == userId1))
        .toList();
  }
}

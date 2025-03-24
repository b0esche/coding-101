import 'chat.dart';
import 'user.dart';

abstract class DatabaseRepository {
  void addUser(User user);
  List<User> getUsers();
  void SendMessage(ChatMessage message);
  List<ChatMessage> getMessages(String userId1, String userId2);
  void addSearchItem(DJ dj);
}

class MockDatabaseRepository implements DatabaseRepository {
  final List<User> _users = [];
  final List<ChatMessage> _messages = [];
  final List<DJ> _djs = [];

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
        .where((message) =>
            (message.senderId == userId1 && message.receiverId == userId2) ||
            (message.senderId == userId2 && message.receiverId == userId1))
        .toList();
  }

  @override
  void addSearchItem(DJ dj) {
    _djs.add(dj);
  }
}

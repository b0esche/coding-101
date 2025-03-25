// import "database_repository.dart";
// import "user.dart";

class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime timestamp;

  ChatMessage(
      {required this.id,
      required this.senderId,
      required this.receiverId,
      required this.message,
      required this.timestamp});

  @override
  String toString() {
    return "$message - $timestamp\n";
  }

  // String toStringWithUser(MockDatabaseRepository repo) {
  //   User? sender = repo.getUsers().firstWhere(
  //         (user) => user.userId == senderId,
  //       );

  //   return "${sender.name}: $message ($timestamp)\n".toString();
  // }
}

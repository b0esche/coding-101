import 'package:gig_hub/src/Common/genre_bubble.dart';
import '../Features/chat/domain/chat_message.dart';
import 'user.dart';

abstract class DatabaseRepository {
  // userdata
  void createDJ(DJ dj);
  void createBooker(Booker booker);
  List<DJ> getDJs();
  AppUser? getUserById(String userId);

  // chatdata
  void sendMessage(ChatMessage message);
  List<ChatMessage> getMessages(String userId1, String userId2);
  List<ChatMessage> getAllMessagesForUser(String userId);
}

class MockDatabaseRepository implements DatabaseRepository {
  final List<DJ> _djs = [
    DJ(
      avatarUrl: "https://picsum.photos/101",
      headUrl: "https://picsum.photos/190",
      city: "Berlin",
      rating: 3.5,
      about:
          "Ich mache sehr tolle Musik und Ich mache sehr tolle Musik und Ich mache sehr tolle Musik und Ich mache sehr tolle Musik",
      set1Url: "set1Url",
      set2Url: "set2Url",
      info: "info",
      genres: [genres[1], genres[17], genres[23], genres[49]],
      bpmMin: 130,
      bpmMax: 150,
      userId: "dj_lorem",
      name: "DJ Lorem Ipsum",
      email: "loremipsum@email.com",
    ),
    DJ(
      avatarUrl: "https://picsum.photos/102",
      headUrl: "https://picsum.photos/150",
      city: "Graz",
      rating: 4.5,
      about: "Ich bin der besteste sowieso",
      set1Url: "set1Url",
      set2Url: "set2Url",
      info: "info",
      genres: [genres[12], genres[10], genres[29], genres[14]],
      bpmMin: 120,
      bpmMax: 135,
      userId: "dj_bobo",
      name: "DJ Bobo",
      email: "loremipsum@email.com",
    ),
    DJ(
      avatarUrl: "https://picsum.photos/103",
      headUrl:
          "https://images.unsplash.com/photo-1496337589254-7e19d01cec44?q=80&w=1740&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      city: "Saint-Tropez",
      rating: 5,
      about: "Diese Worte widme ich meinem Onkel Falco",
      set1Url: "set1Url",
      set2Url: "set2Url",
      info:
          "Ich brauche genügend Platz um meinen Hubschrauber zu parken, außerdem mindestens 3 Flaschen Champagner.",
      genres: [genres[11], genres[0], genres[37], genres[46], genres[6]],
      bpmMin: 130,
      bpmMax: 150,
      userId: "dj_claudio",
      name: "Claudio Fahihi Montana",
      email: "loremipsum@email.com",
    ),
    DJ(
      avatarUrl: "https://picsum.photos/104",
      headUrl: "https://picsum.photos/150",
      city: "Wuppertal",
      rating: 4.5,
      about: "Da wo ich lege wächst kein Grass mehr ich sach dir dat",
      set1Url: "set1Url",
      set2Url: "set2Url",
      info: "info",
      genres: [genres[15], genres[32], genres[33]],
      bpmMin: 140,
      bpmMax: 170,
      userId: "dj_jan",
      name: "JanE Ri Knirsch",
      email: "loremipsum@email.com",
    ),
    DJ(
      avatarUrl: "https://picsum.photos/105",
      headUrl: "https://picsum.photos/150",
      city: "Wien",
      rating: 4.5,
      about: "Frag besser nicht...",
      set1Url: "set1Url",
      set2Url: "set2Url",
      info: "info",
      genres: [genres[14], genres[24], genres[34]],
      bpmMin: 130,
      bpmMax: 150,
      userId: "dj_moneyboy",
      name: "Money Boy",
      email: "loremipsum@email.com",
    ),
  ];

  final List<Booker> bookers = [
    Booker(
      headUrl: "https://picsum.photos/150",
      avatarUrl: "https://picsum.photos/105",
      city: 'Berlin',
      type: 'Club',
      about: 'Trau dich',
      info: 'Wie sind um die Ecke links',
      mediaUrl: ["https://picsum.photos/150"],
      userId: 'booker_bitbat',
      name: 'BitBat Club',
      email: 'abc@mail.de',
      rating: 4.5,
    ),
  ];
  final List<ChatMessage> _messages = [
    ChatMessage(
      id: '1',
      senderId: 'dj_lorem',
      receiverId: 'dj_bobo',
      message: 'Moin von Lorem',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    ChatMessage(
      id: '2',
      senderId: 'dj_bobo',
      receiverId: 'dj_lorem',
      message: 'Servus von Bobo!',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    ChatMessage(
      id: '3',
      senderId: 'dj_claudio',
      receiverId: 'dj_lorem',
      message: 'Was geht ab, Lorem?',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    ChatMessage(
      id: '4',
      senderId: 'dj_lorem',
      receiverId: 'dj_claudio',
      message: 'Nichts besonderes, bei dir?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 55)),
    ),
  ];

  @override
  void createDJ(DJ dj) {
    _djs.add(dj);
  }

  @override
  void createBooker(Booker booker) {
    bookers.add(booker);
  }

  @override
  List<DJ> getDJs() {
    return _djs;
  }

  @override
  AppUser? getUserById(String userId) {
    try {
      return _djs.firstWhere((dj) => dj.userId == userId);
    } catch (e) {
      // User ist kein DJ, versuche Booker
    }
    try {
      return bookers.firstWhere((booker) => booker.userId == userId);
    } catch (e) {
      // User nicht gefunden
    }
    return null;
  }

  @override
  void sendMessage(ChatMessage message) {
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
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  @override
  List<ChatMessage> getAllMessagesForUser(String userId) {
    return _messages
        .where(
          (message) =>
              message.senderId == userId || message.receiverId == userId,
        )
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }
}

import 'package:gig_hub/src/Common/genre_bubble.dart';
import '../Features/chat/domain/chat_message.dart';
import 'app_user.dart';

abstract class DatabaseRepository {
  Future<void> createDJ(DJ dj);
  Future<void> createBooker(Booker booker);
  Future<List<DJ>> getDJs();
  Future<AppUser?> getUserById(String userId);
  Future<List<DJ>> searchDJs({
    String? city,
    List<String>? genres,
    List<int>? bpmRange,
  });

  Future<void> sendMessage(ChatMessage message);
  Future<List<ChatMessage>> getMessages(String userId1, String userId2);
  Future<List<ChatMessage>> getAllMessagesForUser(String userId);
}

class MockDatabaseRepository implements DatabaseRepository {
  final List<DJ> _djs = [
    DJ(
      avatarImageUrl: "https://picsum.photos/101",
      headImageUrl:
          "https://images.unsplash.com/photo-1496337589254-7e19d01cec44?q=80&w=1740&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      city: "Berlin",
      userRating: 3.5,
      about:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.",
      streamingUrls: [],
      mediaImageUrls: [
        "https://picsum.photos/250",
        "https://picsum.photos/251",
        "https://picsum.photos/252",
      ],
      info: "info",
      genres: [genres[1], genres[17], genres[23], genres[49]],
      bpmMin: 130,
      bpmMax: 150,
      id: "dj_lorem",
      name: "DJ Lorem Ipsum",
    ),
  ];

  final List<Booker> bookers = [
    Booker(
      headImageUrl: "https://picsum.photos/150",
      avatarImageUrl: "https://picsum.photos/105",
      city: 'Berlin',

      about: 'Trau dich',
      info: 'Wie sind um die Ecke links',
      mediaImageUrls: [
        "https://picsum.photos/250",
        "https://picsum.photos/251",
        "https://picsum.photos/252",
      ],
      id: 'booker_bitbat',
      name: 'BitBat Club',

      userRating: 4.5,
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
    ChatMessage(
      id: '5',
      senderId: 'booker_bitbat',
      receiverId: 'dj_lorem',
      message: 'Freitag wieder BitBat?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 55)),
    ),
  ];

  @override
  Future<List<DJ>> searchDJs({
    String? city,
    List<String>? genres,
    List<int>? bpmRange,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    String normalize(String input) => input.trim().toLowerCase();
    return _djs.where((dj) {
      final matchesCity =
          city == null || city.trim().isEmpty
              ? true
              : normalize(dj.city).contains(normalize(city));

      final matchesGenres =
          genres == null || genres.isEmpty
              ? true
              : genres.any((genre) => dj.genres.contains(genre));

      final matchesBpm =
          bpmRange == null || bpmRange.length != 2
              ? true
              : (dj.bpmMax >= bpmRange[0] && dj.bpmMin <= bpmRange[1]);

      return matchesCity && matchesGenres && matchesBpm;
    }).toList();
  }

  @override
  Future<void> createDJ(DJ dj) async {
    await Future.delayed(const Duration(seconds: 1));
    _djs.add(dj);
  }

  @override
  Future<void> createBooker(Booker booker) async {
    await Future.delayed(const Duration(seconds: 1));
    bookers.add(booker);
  }

  @override
  Future<List<DJ>> getDJs() async {
    await Future.delayed(const Duration(seconds: 1));
    return _djs;
  }

  @override
  Future<AppUser?> getUserById(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      return _djs.firstWhere((dj) => dj.id == userId);
    } catch (e) {
      //
    }
    try {
      return bookers.firstWhere((booker) => booker.id == userId);
    } catch (e) {
      //
    }
    return null;
  }

  @override
  Future<void> sendMessage(ChatMessage message) async {
    await Future.delayed(const Duration(seconds: 1));
    _messages.add(message);
  }

  @override
  Future<List<ChatMessage>> getMessages(String userId1, String userId2) async {
    await Future.delayed(const Duration(seconds: 1));
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
  Future<List<ChatMessage>> getAllMessagesForUser(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    return _messages
        .where(
          (message) =>
              message.senderId == userId || message.receiverId == userId,
        )
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }
}

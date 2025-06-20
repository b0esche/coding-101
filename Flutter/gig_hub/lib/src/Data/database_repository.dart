import 'package:gig_hub/src/Common/genre_bubble.dart';
import '../Features/chat/domain/chat_message.dart';
import 'user.dart';

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
      avatarUrl: "https://picsum.photos/101",
      headUrl: "https://picsum.photos/190",
      city: "Berlin",
      rating: 3.5,
      about:
          "Ich mache sehr tolle Musik und Ich mache sehr tolle Musik und Ich mache sehr tolle Musik und Ich mache sehr tolle Musik",
      set1Url: "https://soundcloud.com/yourset",
      set2Url: "https://soundcloud.com/yourotherset",
      mediaUrl: [
        "https://picsum.photos/250",
        "https://picsum.photos/251",
        "https://picsum.photos/252",
      ],
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
      set1Url: "https://soundcloud.com/yourset",
      set2Url: "https://soundcloud.com/yourotherset",
      mediaUrl: null,
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
      set1Url: "https://soundcloud.com/yourset",
      set2Url: "https://soundcloud.com/yourotherset",
      mediaUrl: [
        "https://picsum.photos/250",
        "https://picsum.photos/251",
        "https://picsum.photos/252",
      ],
      info:
          "Ich brauche genügend Platz um meinen Hubschrauber zu parken, außerdem mindestens 3 Flaschen Champagner.",
      genres: [genres[11], genres[0], genres[37], genres[46], genres[6]],
      bpmMin: 130,
      bpmMax: 160,
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
      set1Url: "https://soundcloud.com/yourset",
      set2Url: "https://soundcloud.com/yourotherset",
      mediaUrl: [
        "https://picsum.photos/250",
        "https://picsum.photos/251",
        "https://picsum.photos/252",
      ],
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
      set1Url: "https://soundcloud.com/yourset",
      set2Url: "https://soundcloud.com/yourotherset",
      mediaUrl: [
        "https://picsum.photos/250",
        "https://picsum.photos/251",
        "https://picsum.photos/252",
      ],
      info: "info",
      genres: [genres[14], genres[24], genres[34]],
      bpmMin: 130,
      bpmMax: 150,
      userId: "dj_moneyboy",
      name: "Money Boy",
      email: "loremipsum@email.com",
    ),
    DJ(
      genres: [genres[2], genres[3], genres[44], genres[12]],
      headUrl: "https://picsum.photos/155",
      avatarUrl: "https://picsum.photos/111",
      bpmMin: 140,
      bpmMax: 172,
      about: "Mein Sound fährt im Hühnerstall Motorrad",
      set1Url: "https://soundcloud.com/yourset",
      set2Url: "https://soundcloud.com/yourotherset",
      mediaUrl: [
        "https://picsum.photos/250",
        "https://picsum.photos/251",
        "https://picsum.photos/252",
      ],
      info:
          "Ich esse ausschließlich Fallobst, welches beim Fall unter nN gelandet ist (nur aus Holland oder Flandern)",
      userId: "serId",
      name: "DJ Föbitz",
      email: "e@mail.de",
      city: "Bonn",
      rating: 3.0,
    ),
    DJ(
      genres: [genres[17], genres[22], genres[41], genres[49]],
      headUrl: "https://picsum.photos/154",
      avatarUrl: "https://picsum.photos/112",
      bpmMin: 90,
      bpmMax: 122,
      about: "alles easy",
      set1Url: "https://soundcloud.com/yourset",
      set2Url: "https://soundcloud.com/yourotherset",
      mediaUrl: [
        "https://picsum.photos/250",
        "https://picsum.photos/251",
        "https://picsum.photos/252",
      ],
      info: "bitte ausschließlich pioneer mixer....",
      userId: "muserId",
      name: "DJ Carglass",
      email: "ee@mail.de",
      city: "Chemnitz",
      rating: 3.5,
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
      mediaUrl: [
        "https://picsum.photos/250",
        "https://picsum.photos/251",
        "https://picsum.photos/252",
      ],
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
      return _djs.firstWhere((dj) => dj.userId == userId);
    } catch (e) {
      //
    }
    try {
      return bookers.firstWhere((booker) => booker.userId == userId);
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

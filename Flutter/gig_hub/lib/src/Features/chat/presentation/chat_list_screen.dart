import 'package:intl/intl.dart';

import '../../../Data/app_imports.dart';

class ChatListScreenArgs {
  final AppUser currentUser;

  ChatListScreenArgs({required this.currentUser});
}

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key, required this.currentUser});

  final AppUser currentUser;

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final db = FirestoreDatabaseRepository();

  @override
  void initState() {
    super.initState();
  }

  Future<List<dynamic>> _buildChatEntries(
    List<ChatMessage> recentMessages,
  ) async {
    final List<ChatListItem> items = [];

    for (final msg in recentMessages) {
      final partnerId =
          msg.senderId == widget.currentUser.id ? msg.receiverId : msg.senderId;
      final partnerUser = await db.getUserById(partnerId);
      items.add(ChatListItem(user: partnerUser, recent: msg));
    }

    items.sort((a, b) => b.recent.timestamp.compareTo(a.recent.timestamp));

    final List<dynamic> entries = [];
    DateTime? lastDate;

    for (final item in items) {
      final itemDate = DateTime(
        item.recent.timestamp.year,
        item.recent.timestamp.month,
        item.recent.timestamp.day,
      );

      if (lastDate == null || itemDate.isBefore(lastDate)) {
        entries.add(itemDate);
        lastDate = itemDate;
      }

      entries.add(item);
    }

    return entries;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.primalBlack,
      appBar: AppBar(
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: const Icon(Icons.chevron_left_rounded, size: 36),
          color: Palette.glazedWhite,
        ),
        title: const Text('chats'),
        backgroundColor: Palette.primalBlack,
        iconTheme: IconThemeData(color: Palette.glazedWhite),
        titleTextStyle: TextStyle(color: Palette.glazedWhite, fontSize: 20),
      ),
      body: StreamBuilder<List<ChatMessage>>(
        stream: db.getChatsStream(widget.currentUser.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Palette.forgedGold,
                strokeWidth: 1.65,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'couldn\'t load chats',
                style: TextStyle(color: Palette.glazedWhite),
              ),
            );
          }

          final recentMessages = snapshot.data ?? [];

          if (recentMessages.isEmpty) {
            return Center(
              child: Text(
                'no chats. start now!',
                style: TextStyle(color: Palette.glazedWhite, fontSize: 16),
              ),
            );
          }

          return FutureBuilder<List<dynamic>>(
            future: _buildChatEntries(recentMessages),
            builder: (context, asyncSnapshot) {
              if (!asyncSnapshot.hasData) {
                return const SizedBox.shrink();
              }

              final chatEntries = asyncSnapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: chatEntries.length,
                itemBuilder: (context, idx) {
                  final entry = chatEntries[idx];

                  if (entry is DateTime) {
                    final isToday =
                        DateTime.now().difference(entry).inDays == 0;
                    final formattedDate =
                        isToday
                            ? 'Today'
                            : DateFormat('MMM dd, yyyy').format(entry);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Center(
                        child: Text(
                          formattedDate,
                          style: TextStyle(
                            color: Palette.glazedWhite.o(0.6),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }

                  if (entry is ChatListItem) {
                    return ChatListItemWidget(
                      chatListItem: entry,
                      currentUser: widget.currentUser,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => ChatScreen(
                                  chatPartner: entry.user,
                                  currentUser: widget.currentUser,
                                ),
                          ),
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              );
            },
          );
        },
      ),
    );
  }
}

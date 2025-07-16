import 'package:flutter/material.dart';
import 'package:gig_hub/src/Data/firestore_repository.dart';
import 'package:gig_hub/src/Data/users.dart';
import 'package:gig_hub/src/Features/chat/domain/chat_list_item.dart';
import 'package:gig_hub/src/Features/chat/presentation/chat_list_item_widget.dart';
import 'package:gig_hub/src/Theme/palette.dart';
import 'package:gig_hub/src/Features/chat/presentation/chat_screen.dart';

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
  List<ChatListItem> _chatListItems = [];
  bool _isLoading = true;
  bool _hasError = false;
  final db = FirestoreDatabaseRepository();

  @override
  void initState() {
    super.initState();
    _loadRecentChats();
  }

  Future<void> _loadRecentChats() async {
    try {
      final recentMessages = await db.getChats(widget.currentUser.id);

      final List<ChatListItem> items = [];
      for (final msg in recentMessages) {
        final partnerId =
            msg.senderId == widget.currentUser.id
                ? msg.receiverId
                : msg.senderId;

        final partnerUser = await db.getUserById(partnerId);

        items.add(ChatListItem(user: partnerUser, recent: msg));
      }

      items.sort((a, b) => b.recent.timestamp.compareTo(a.recent.timestamp));

      if (mounted) {
        setState(() {
          _chatListItems = items;
          _hasError = false;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('$e');

      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
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
      body:
          _isLoading
              ? Center(
                child: CircularProgressIndicator(color: Palette.forgedGold),
              )
              : _hasError
              ? Center(
                child: Text(
                  'couldn\'t load chats',
                  style: TextStyle(color: Palette.glazedWhite),
                ),
              )
              : _chatListItems.isEmpty
              ? Center(
                child: Text(
                  'no chats. start now!',
                  style: TextStyle(color: Palette.glazedWhite, fontSize: 16),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _chatListItems.length,
                itemBuilder: (context, idx) {
                  final chatItem = _chatListItems[idx];
                  return ChatListItemWidget(
                    chatListItem: chatItem,

                    currentUser: widget.currentUser,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ChatScreen(
                                chatPartner: chatItem.user,

                                currentUser: widget.currentUser,
                              ),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gig_hub/src/Data/database_repository.dart';
import 'package:gig_hub/src/Data/app_user.dart';
import 'package:gig_hub/src/Features/chat/domain/chat_message.dart';
import 'package:gig_hub/src/Features/chat/domain/chat_list_item.dart';
import 'package:gig_hub/src/Features/chat/presentation/chat_list_item_widget.dart';
import 'package:gig_hub/src/Theme/palette.dart';
import 'package:gig_hub/src/Features/chat/presentation/chat_screen.dart';

class ChatListScreenArgs {
  final DatabaseRepository repo;
  final DJ currentUser;

  ChatListScreenArgs({required this.repo, required this.currentUser});
}

class ChatListScreen extends StatefulWidget {
  static const routeName = '/chatList';

  const ChatListScreen({
    super.key,
    required this.repo,
    required this.currentUser,
  });

  final DatabaseRepository repo;
  final DJ currentUser;

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<ChatListItem> _chatListItems = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadChatListItems();
  }

  Future<void> _loadChatListItems() async {
    try {
      final allMessages = await widget.repo.getAllMessagesForUser(
        widget.currentUser.id,
      );

      final Map<String, ChatMessage> latestMessagesByPartner = {};
      final Set<String> chatPartnerIds = {};

      for (var message in allMessages) {
        final partnerId =
            message.senderId == widget.currentUser.id
                ? message.receiverId
                : message.senderId;
        chatPartnerIds.add(partnerId);

        if (!latestMessagesByPartner.containsKey(partnerId) ||
            message.timestamp.isAfter(
              latestMessagesByPartner[partnerId]!.timestamp,
            )) {
          latestMessagesByPartner[partnerId] = message;
        }
      }

      final List<ChatListItem> items = [];

      for (final partnerId in chatPartnerIds) {
        final partnerUser = await widget.repo.getUserById(partnerId);
        if (partnerUser != null &&
            latestMessagesByPartner.containsKey(partnerId)) {
          items.add(
            ChatListItem(
              user: partnerUser as DJ,
              recent: latestMessagesByPartner[partnerId]!,
            ),
          );
        }
      }

      items.sort((a, b) => b.recent.timestamp.compareTo(a.recent.timestamp));

      if (mounted) {
        setState(() {
          _chatListItems = items;
          _isLoading = false;
        });
      }
    } catch (e) {
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
                  'Fehler beim Laden der Chats.',
                  style: TextStyle(color: Palette.glazedWhite),
                ),
              )
              : _chatListItems.isEmpty
              ? Center(
                child: Text(
                  'Keine Chats vorhanden.',
                  style: TextStyle(color: Palette.glazedWhite, fontSize: 16),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _chatListItems.length,
                itemBuilder: (context, index) {
                  final chatListItem = _chatListItems[index];
                  return ChatListItemWidget(
                    chatListItem: chatListItem,
                    repo: widget.repo,
                    currentUser: widget.currentUser,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        ChatScreen.routeName,
                        arguments: ChatScreenArgs(
                          chatPartner: chatListItem.user as DJ,
                          repo: widget.repo,
                          currentUser: widget.currentUser,
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}

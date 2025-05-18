import 'package:flutter/material.dart';
import 'package:gig_hub/src/Data/database_repository.dart';
import 'package:gig_hub/src/Data/user.dart';
import 'package:gig_hub/src/Features/chat/domain/chat_message.dart';
import 'package:gig_hub/src/Features/chat/domain/chat_list_item.dart';
import 'package:gig_hub/src/Features/chat/presentation/chat_list_item_widget.dart';
import 'package:gig_hub/src/Theme/palette.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({
    super.key,
    required this.repo,
    required this.currentUser,
  });
  final DatabaseRepository repo;
  final AppUser currentUser;

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<ChatListItem> _chatListItems = [];

  @override
  void initState() {
    super.initState();
    _loadChatListItems();
  }

  void _loadChatListItems() {
    final allMessages = widget.repo.getAllMessagesForUser(
      widget.currentUser.userId,
    );
    final Map<String, ChatMessage> latestMessagesByPartner = {};
    final Set<String> chatPartnerIds = {};

    for (var message in allMessages) {
      String partnerId =
          message.senderId == widget.currentUser.userId
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
    for (String partnerId in chatPartnerIds) {
      AppUser? partnerUser = widget.repo.getUserById(partnerId);
      if (partnerUser != null &&
          latestMessagesByPartner.containsKey(partnerId)) {
        items.add(
          ChatListItem(
            user: partnerUser,
            recent: latestMessagesByPartner[partnerId]!,
          ),
        );
      }
    }

    // Sortiere die Chat-Liste, sodass die neuesten Chats oben sind
    items.sort((a, b) => b.recent.timestamp.compareTo(a.recent.timestamp));

    if (mounted) {
      setState(() {
        _chatListItems = items;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.primalBlack,
      appBar: AppBar(
        title: Text('chats'),
        backgroundColor: Palette.primalBlack,
        iconTheme: IconThemeData(color: Palette.glazedWhite),
        titleTextStyle: TextStyle(color: Palette.glazedWhite, fontSize: 20),
      ),
      body:
          _chatListItems.isEmpty
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
                  );
                },
              ),
    );
  }
}

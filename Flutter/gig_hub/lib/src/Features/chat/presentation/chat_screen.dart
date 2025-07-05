import 'package:flutter/material.dart';
import 'package:gig_hub/src/Data/database_repository.dart';
import 'package:gig_hub/src/Data/app_user.dart';
import 'package:gig_hub/src/Features/chat/domain/chat_message.dart';
import 'package:gig_hub/src/Features/profile/booker/presentation/profile_screen_booker.dart';
import 'package:gig_hub/src/Features/profile/dj/presentation/profile_screen_dj.dart';
import 'package:gig_hub/src/Theme/palette.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScreenArgs {
  final DJ chatPartner;
  final DatabaseRepository repo;
  final DJ currentUser;

  ChatScreenArgs({
    required this.chatPartner,
    required this.repo,
    required this.currentUser,
  });
}

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat';

  final DJ chatPartner;
  final DatabaseRepository repo;
  final DJ currentUser;

  const ChatScreen({
    super.key,
    required this.chatPartner,
    required this.repo,
    required this.currentUser,
  });

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String getPartnerAvatarUrl() {
    return widget.chatPartner.avatarImageUrl;
  }

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final messages = await widget.repo.getMessages(
      widget.currentUser.id,
      widget.chatPartner.id,
    );
    if (!mounted) return;
    setState(() {
      _messages = messages;
    });
    _scrollToBottom();
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: widget.currentUser.id,
      receiverId: widget.chatPartner.id,
      message: text,
      timestamp: DateTime.now(),
    );

    await widget.repo.sendMessage(newMessage);

    setState(() {
      _messages.add(newMessage);
    });

    _controller.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final partnerAvatarUrl = getPartnerAvatarUrl();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 96,
        backgroundColor: Palette.glazedWhite,
        elevation: 1,
        iconTheme: IconThemeData(color: Palette.primalBlack),
        title: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Palette.primalBlack, width: 1.5),
              ),
              child: GestureDetector(
                onTap: () {
                  if (widget.chatPartner is DJ) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => ProfileScreenDJ(
                              dj: widget.chatPartner,
                              repo: widget.repo,
                              showChatButton: false,
                              showEditButton: true,
                            ),
                      ),
                    );
                  } else if (widget.chatPartner is Booker) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => ProfileScreenBooker(
                              booker: widget.chatPartner as Booker,
                              repo: widget.repo,
                              showEditButton: false,
                            ),
                      ),
                    );
                  }
                },
                child: CircleAvatar(
                  backgroundImage:
                      partnerAvatarUrl.isNotEmpty
                          ? NetworkImage(partnerAvatarUrl)
                          : const AssetImage('assets/images/default_avatar.jpg')
                              as ImageProvider<Object>,
                  radius: 38,
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 222,
              child: Text(
                widget.chatPartner.name,
                style: GoogleFonts.sometypeMono(
                  textStyle: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Palette.primalBlack,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Palette.primalBlack.o(0.95),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                final isMe = message.senderId == widget.currentUser.id;
                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Stack(
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          color:
                              isMe ? Palette.forgedGold : Palette.glazedWhite,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: Radius.circular(isMe ? 16 : 4),
                            bottomRight: Radius.circular(isMe ? 4 : 16),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Palette.primalBlack.o(0.1),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Text(
                          message.message,
                          style: TextStyle(
                            color: Palette.primalBlack,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 5,
                        right: 12,
                        child: Text(
                          '${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontSize: 10,
                            color: Palette.primalBlack.o(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
            child: Container(
              decoration: BoxDecoration(
                color: Palette.glazedWhite,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, -2),
                    blurRadius: 5,
                    color: Palette.primalBlack.o(0.05),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: TextField(
                        controller: _controller,
                        minLines: 1,
                        maxLines: 4,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: "message...",
                          hintStyle: TextStyle(color: Palette.primalBlack),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      Icons.send_rounded,
                      color: Palette.forgedGold,
                      size: 28,
                    ),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

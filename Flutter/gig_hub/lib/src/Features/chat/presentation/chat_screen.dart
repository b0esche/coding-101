import 'package:flutter/material.dart';
import 'package:gig_hub/src/Data/database_repository.dart';
import 'package:gig_hub/src/Data/firestore_repository.dart';
import 'package:gig_hub/src/Data/users.dart';
import 'package:gig_hub/src/Features/chat/domain/chat_message.dart';
import 'package:gig_hub/src/Features/profile/dj/presentation/profile_screen_dj.dart';
import 'package:gig_hub/src/Theme/palette.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChatScreenArgs {
  final AppUser chatPartner;

  final AppUser currentUser;

  ChatScreenArgs({required this.chatPartner, required this.currentUser});
}

class ChatScreen extends StatefulWidget {
  final AppUser chatPartner;

  final AppUser currentUser;

  const ChatScreen({
    super.key,
    required this.chatPartner,

    required this.currentUser,
  });

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final db = FirestoreDatabaseRepository();
  String getPartnerAvatarUrl() {
    return widget.chatPartner.avatarUrl;
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
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
      read: false,
    );

    await db.sendMessage(newMessage);
    _controller.clear();
    _scrollToBottomDelayed();
  }

  void _scrollToBottomDelayed() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.minScrollExtent);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final db = context.watch<DatabaseRepository>();
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => ProfileScreenDJ(
                            dj: widget.chatPartner as DJ,

                            showChatButton: false,
                            showEditButton: true,
                            showFavoriteIcon: true,
                            currentUser: widget.currentUser,
                          ),
                    ),
                  );
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
                widget.chatPartner.displayName,
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
            child: StreamBuilder<List<ChatMessage>>(
              stream: db.getMessagesStream(
                widget.currentUser.id,
                widget.chatPartner.id,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("start talking!"));
                }

                final messages = snapshot.data!;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.jumpTo(
                      _scrollController.position.minScrollExtent,
                    );
                  }
                });

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[messages.length - 1 - index];
                    final isMe = message.senderId == widget.currentUser.id;

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Stack(
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.75,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color:
                                  isMe
                                      ? Palette.forgedGold
                                      : Palette.glazedWhite,
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
                );
              },
            ),
          ),
          _buildMessageInput(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
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
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
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
              onPressed: () => _sendMessage(),
            ),
          ],
        ),
      ),
    );
  }
}

import '../../../Data/app_imports.dart';

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

  String getPartnerAvatarUrl() => widget.chatPartner.avatarUrl;

  @override
  void initState() {
    super.initState();
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
        toolbarHeight: 108,
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
                      builder: (_) {
                        if (widget.chatPartner is DJ) {
                          return ProfileScreenDJ(
                            dj: widget.chatPartner as DJ,
                            showChatButton: false,
                            showEditButton: true,
                            showFavoriteIcon: true,
                            currentUser: widget.currentUser,
                          );
                        } else {
                          return ProfileScreenBooker(
                            booker: widget.chatPartner as Booker,
                            showEditButton: true,
                            db: db,
                          );
                        }
                      },
                    ),
                  );
                },
                child: CircleAvatar(
                  backgroundImage:
                      partnerAvatarUrl.isNotEmpty
                          ? NetworkImage(partnerAvatarUrl)
                          : const AssetImage('assets/images/default_avatar.jpg')
                              as ImageProvider<Object>,
                  radius: 42,
                ),
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 222,
              child: Text(
                widget.chatPartner.displayName,
                maxLines: 2,
                style: GoogleFonts.sometypeMono(
                  textStyle: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Palette.primalBlack,
                    fontWeight: FontWeight.w500,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
          ],
        ),
        leadingWidth: 32,
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

                final rawMessages = snapshot.data!;
                rawMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

                final List<dynamic> messageItems = [];
                DateTime? lastDate;

                for (final msg in rawMessages) {
                  final msgDate = DateTime(
                    msg.timestamp.year,
                    msg.timestamp.month,
                    msg.timestamp.day,
                  );

                  if (lastDate == null || msgDate.isAfter(lastDate)) {
                    messageItems.add(msgDate);
                    lastDate = msgDate;
                  }

                  messageItems.add(msg);
                }

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
                  itemCount: messageItems.length,
                  itemBuilder: (context, index) {
                    final item = messageItems[messageItems.length - 1 - index];

                    if (item is DateTime) {
                      final isToday =
                          DateTime.now().difference(item).inDays == 0;
                      final dateText =
                          isToday
                              ? 'Today'
                              : '${item.day.toString().padLeft(2, '0')}.${item.month.toString().padLeft(2, '0')}.${item.year}';

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: Text(
                            dateText,
                            style: TextStyle(
                              color: Palette.glazedWhite.o(0.6),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }

                    final ChatMessage message = item;
                    final isMe = message.senderId == widget.currentUser.id;

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Stack(
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              minWidth: 96,
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
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2, bottom: 2),
                              child: Text(
                                message.message,
                                style: TextStyle(
                                  color: Palette.primalBlack,
                                  fontSize: 15,
                                ),
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

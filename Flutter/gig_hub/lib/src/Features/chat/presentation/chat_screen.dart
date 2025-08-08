import 'package:flutter_localization/flutter_localization.dart';
import 'package:gig_hub/src/Data/services/localization_service.dart';

import '../../../Data/app_imports.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

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

class ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _markLastMessageAsRead();
  }

  Future<void> _markLastMessageAsRead() async {
    final messages = await db.getMessages(
      widget.currentUser.id,
      widget.chatPartner.id,
    );
    if (messages.isNotEmpty) {
      final lastMsg = messages.last;
      if (!lastMsg.read && lastMsg.senderId != widget.currentUser.id) {
        await db.markMessageAsRead(
          lastMsg.id,
          widget.currentUser.id,
          widget.chatPartner.id,
          widget.currentUser.id,
        );
      }
    }
  }

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final db = FirestoreDatabaseRepository();

  String getPartnerAvatarUrl() => widget.chatPartner.avatarUrl;
  late encrypt.Encrypter _encrypter;
  late encrypt.Key _aesKey;

  bool _encryptionReady = false;

  final Set<String> _deleteModeMessages = {};

  @override
  void initState() {
    super.initState();
    _initEncryption();
    _bottomsheetAnimationController = AnimationController(vsync: this);
  }

  Future<void> _initEncryption() async {
    final keyString = dotenv.env['ENCRYPTION_KEY'];
    if (keyString == null || keyString.length != 32) {
      return;
    }

    _aesKey = encrypt.Key.fromUtf8(keyString);
    _encrypter = encrypt.Encrypter(encrypt.AES(_aesKey));

    setState(() {
      _encryptionReady = true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (!_encryptionReady) return;
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final iv = encrypt.IV.fromLength(16);
    final encrypted = _encrypter.encrypt(text, iv: iv);

    final encryptedText = 'enc::${iv.base64}:${encrypted.base64}';

    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: widget.currentUser.id,
      receiverId: widget.chatPartner.id,
      message: encryptedText,
      timestamp: DateTime.now(),
      read: false,
    );

    await db.sendMessage(newMessage);
    _controller.clear();
    _scrollToBottomDelayed();
  }

  String _decryptMessage(String text) {
    if (!_encryptionReady) return '[loading key...]';

    if (text.startsWith('enc::')) {
      try {
        final encryptedPart = text.substring(5);

        final parts = encryptedPart.split(':');
        if (parts.length != 2) return '[invalid format]';

        final iv = encrypt.IV.fromBase64(parts[0]);
        final encryptedData = parts[1];

        return _encrypter.decrypt64(encryptedData, iv: iv);
      } catch (e) {
        return '[decoding error]';
      }
    }

    return text;
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

  late final AnimationController _bottomsheetAnimationController;

  @override
  Widget build(BuildContext context) {
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
              width: 172,
              child: Text(
                widget.chatPartner.displayName,

                maxLines: 2,
                style: GoogleFonts.sometypeMono(
                  textStyle: TextStyle(
                    wordSpacing: -3,
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
        actionsPadding: EdgeInsets.only(bottom: 42),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  ModalBottomSheetRoute(
                    isDismissible: true,
                    scrollControlDisabledMaxHeightRatio: 0.7,
                    backgroundColor: Palette.forgedGold.o(0.9),
                    builder: (context) {
                      return BottomSheet(
                        backgroundColor: Colors.transparent,
                        animationController: _bottomsheetAnimationController,
                        onDragEnd:
                            (details, {required isClosing}) =>
                                Navigator.pop(context),
                        enableDrag: true,
                        showDragHandle: true,
                        dragHandleColor: Palette.shadowGrey,
                        onClosing: () {},
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              spacing: 24,
                              children: [
                                Text(
                                  widget.chatPartner.displayName,
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                    color: Palette.shadowGrey,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Palette.shadowGrey,
                                  ),
                                ),
                                PinchZoom(
                                  maxScale: 2,
                                  zoomEnabled: true,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Palette.shadowGrey,
                                        width: 2.35,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Palette.gigGrey.o(0.65),
                                          blurRadius: 3,
                                          offset: Offset(1, 1),
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: CircleAvatar(
                                      backgroundImage:
                                          partnerAvatarUrl.isNotEmpty
                                              ? NetworkImage(partnerAvatarUrl)
                                              : const AssetImage(
                                                    'assets/images/default_avatar.jpg',
                                                  )
                                                  as ImageProvider<Object>,
                                      radius: 108,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                      Palette.glazedWhite,
                                    ),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor: Palette.primalBlack,
                                          surfaceTintColor: Palette.forgedGold,
                                          title: Text(
                                            AppLocale.blockUser.getString(
                                              context,
                                            ),
                                            style: GoogleFonts.sometypeMono(
                                              textStyle: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: Palette.glazedWhite,
                                              ),
                                            ),
                                          ),
                                          content: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      WidgetStatePropertyAll(
                                                        Palette.glazedWhite,
                                                      ),
                                                ),
                                                onPressed:
                                                    () =>
                                                        Navigator.of(
                                                          context,
                                                        ).pop(),
                                                child: Text(
                                                  AppLocale.cancel.getString(
                                                    context,
                                                  ),
                                                  style: TextStyle(
                                                    color: Palette.primalBlack,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      WidgetStatePropertyAll(
                                                        Palette.glazedWhite,
                                                      ),
                                                ),
                                                onPressed: () async {
                                                  await db.blockUser(
                                                    widget.currentUser.id,
                                                    widget.chatPartner.id,
                                                  );
                                                  await db.deleteChat(
                                                    widget.currentUser.id,
                                                    widget.chatPartner.id,
                                                  );
                                                  if (context.mounted) {
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).pop();
                                                  }
                                                },
                                                child: Text(
                                                  AppLocale.blockAndDelete
                                                      .getString(context),
                                                  style: TextStyle(
                                                    color: Palette.primalBlack,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 24,
                                      right: 24,
                                    ),
                                    child: Text(
                                      AppLocale.block.getString(context),
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Palette.primalBlack,
                                      ),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                      Palette.glazedWhite,
                                    ),
                                  ),
                                  onPressed: () {
                                    // TODO: reporting
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 24,
                                      right: 24,
                                    ),
                                    child: Text(
                                      AppLocale.report.getString(context),
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Palette.primalBlack,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 36),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    elevation: 2,
                    enableDrag: true,
                    isScrollControlled: false,
                  ),
                );
              },
              style: ButtonStyle(
                elevation: WidgetStateProperty.all(3),
                tapTargetSize: MaterialTapTargetSize.padded,
                splashFactory: NoSplash.splashFactory,
              ),
              icon: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Palette.primalBlack.o(0.85),
                  border: Border.all(color: Palette.shadowGrey, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Palette.primalBlack.o(0.85),
                      offset: Offset(0.2, 0.15),
                      blurRadius: 1.65,
                    ),
                    BoxShadow(
                      color: Palette.glazedWhite.o(0.85),
                      blurStyle: BlurStyle.inner,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.announcement_rounded,
                    color: Palette.glazedWhite,
                    size: 22,
                    shadows: [Shadow(color: Palette.glazedWhite)],
                  ),
                ),
              ),
            ),
          ),
        ],
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
                  return Center(
                    child: Text(AppLocale.startTalking.getString(context)),
                  );
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
                              ? AppLocale.today.getString(context)
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

                    final inDeleteMode =
                        isMe && _deleteModeMessages.contains(message.id);
                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            transform:
                                inDeleteMode
                                    ? Matrix4.translationValues(-48, 0, 0)
                                    : Matrix4.identity(),
                            child: GestureDetector(
                              onLongPress:
                                  isMe
                                      ? () {
                                        setState(() {
                                          if (inDeleteMode) {
                                            _deleteModeMessages.remove(
                                              message.id,
                                            );
                                          } else {
                                            _deleteModeMessages.add(message.id);
                                          }
                                        });
                                      }
                                      : null,
                              child: Container(
                                constraints: BoxConstraints(
                                  minWidth: 96,
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.75,
                                ),
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: Stack(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            isMe
                                                ? Palette.forgedGold
                                                : Palette.glazedWhite,
                                        borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(16),
                                          topRight: const Radius.circular(16),
                                          bottomLeft: Radius.circular(
                                            isMe ? 16 : 4,
                                          ),
                                          bottomRight: Radius.circular(
                                            isMe ? 4 : 16,
                                          ),
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
                                        padding: const EdgeInsets.only(
                                          top: 4,
                                          bottom: 2,
                                          right: 60,
                                        ),
                                        child: Text(
                                          _decryptMessage(message.message),
                                          style: TextStyle(
                                            color: Palette.primalBlack,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 10,
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
                              ),
                            ),
                          ),
                          if (inDeleteMode)
                            AnimatedOpacity(
                              opacity: 1.0,
                              duration: const Duration(milliseconds: 180),
                              child: IconButton(
                                style: ButtonStyle(
                                  tapTargetSize: MaterialTapTargetSize.padded,
                                ),
                                icon: Icon(
                                  Icons.delete_sweep_outlined,
                                  color: Palette.alarmRed.o(0.85),
                                  size: 32,
                                ),
                                onPressed: () async {
                                  final chatId = db.getChatId(
                                    widget.currentUser.id,
                                    widget.chatPartner.id,
                                  );
                                  await db.deleteMessage(
                                    chatId,
                                    message.id,
                                    widget.currentUser.id,
                                  );
                                  setState(() {
                                    _deleteModeMessages.remove(message.id);
                                  });
                                },
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
                  showCursor: false,
                  textInputAction: TextInputAction.send,
                  controller: _controller,
                  minLines: 1,
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: AppLocale.msg.getString(context),
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

import 'package:flutter/material.dart';
import 'package:gig_hub/src/Data/users.dart';
import 'package:gig_hub/src/Features/chat/domain/chat_list_item.dart';
import 'package:gig_hub/src/Theme/palette.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ChatListItemWidget extends StatelessWidget {
  final ChatListItem chatListItem;
  final AppUser currentUser;
  final VoidCallback? onTap;

  const ChatListItemWidget({
    super.key,
    required this.chatListItem,
    required this.currentUser,
    this.onTap,
  });

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inHours >= 24) {
      return '24h+';
    } else {
      return DateFormat.Hm().format(timestamp);
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatarUrl = chatListItem.user.avatarUrl;
    final userName = chatListItem.user.displayName;
    final lastMessage = chatListItem.recent.message;
    final lastStamp = chatListItem.recent.timestamp;
    final formattedTime = _formatTimestamp(lastStamp);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Palette.glazedWhite.o(0.9),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Palette.primalBlack.o(0.15),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: 11.5,
          ),
          child: Row(
            children: [
              // Avatar
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Palette.primalBlack.o(0.35),
                    width: 1.4,
                  ),
                ),
                child: CircleAvatar(
                  radius: 38,
                  backgroundImage:
                      avatarUrl.isNotEmpty
                          ? NetworkImage(avatarUrl)
                          : const AssetImage('assets/images/default_avatar.jpg')
                              as ImageProvider<Object>,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        formattedTime,
                        style: TextStyle(
                          fontSize: 12,
                          color: Palette.primalBlack.o(0.6),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            userName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.sometypeMono(
                              textStyle: TextStyle(
                                fontSize: 18.5,
                                fontWeight: FontWeight.w700,
                                color: Palette.primalBlack,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.sometypeMono(
                        textStyle: TextStyle(
                          fontSize: 14,
                          color: Palette.primalBlack.o(0.85),
                          wordSpacing: -3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

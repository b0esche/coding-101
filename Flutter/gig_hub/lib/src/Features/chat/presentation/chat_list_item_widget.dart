// gig_hub/src/Features/chat/presentation/chat_list_item_widget.dart
import 'package:flutter/material.dart';
import 'package:gig_hub/src/Data/database_repository.dart';
import 'package:gig_hub/src/Data/app_user.dart';
import 'package:gig_hub/src/Features/chat/domain/chat_list_item.dart';
import 'package:gig_hub/src/Theme/palette.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatListItemWidget extends StatelessWidget {
  final ChatListItem chatListItem;
  final DatabaseRepository repo;
  final DJ currentUser;
  final VoidCallback? onTap;

  const ChatListItemWidget({
    super.key,
    required this.chatListItem,
    required this.repo,
    required this.currentUser,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String avatarUrl = chatListItem.user.avatarImageUrl;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
          color: Palette.glazedWhite.o(0.9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Palette.primalBlack.o(0.2),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          leading: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Palette.primalBlack.o(0.35),
                width: 1.3,
              ),
            ),
            child: CircleAvatar(
              backgroundImage:
                  avatarUrl.isNotEmpty
                      ? NetworkImage(avatarUrl)
                      : const AssetImage('assets/images/default_avatar.jpg')
                          as ImageProvider<Object>,
              radius: 28,
            ),
          ),
          title: Text(
            chatListItem.user.name,
            style: GoogleFonts.sometypeMono(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Palette.primalBlack,
                fontSize: 18,
              ),
            ),
          ),
          subtitle: Text(
            chatListItem.recent.message,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Palette.primalBlack.o(0.7)),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}

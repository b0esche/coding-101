// gig_hub/src/Features/chat/domain/chat_list_item.dart
import 'package:gig_hub/src/Data/app_user.dart';
import 'package:gig_hub/src/Features/chat/domain/chat_message.dart';

class ChatListItem {
  final DJ user;
  final ChatMessage recent;

  ChatListItem({required this.user, required this.recent});
}

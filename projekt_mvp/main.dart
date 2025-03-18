import 'classes/chat_list_item.dart';

void main() {
  ChatListItem x = ChatListItem(
      "einName", "Hi dies ist die letzte Nachricht", "avatarUrl.html");

  x.name = "DJ Bifi";
  print(x.name);
  print(x.recentMessage);
}

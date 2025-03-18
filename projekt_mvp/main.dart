import 'classes/chat_list_item.dart';

void main() {
  // Neue Instanz IN Variable erzeugen
  ChatListItem x = ChatListItem(
      "einName", "Hi dies ist die letzte Nachricht", "avatarUrl.html");

// Attributwerte manipulieren und printen
  x.name = "DJ Bifi";
  print(x.name);
  print(x.recentMessage);

  // Neue Instanz OHNE Variable erzeugen
  new ChatListItem("peter", "hallo manni", "www.de");
}

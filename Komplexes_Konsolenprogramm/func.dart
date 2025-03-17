// Passwortmanager

import "dart:io";
import "main.dart";

// Menü anzeigen und Option wählen
void showMenu() {
  print("\x1B[34mPersönlicher Passwort Manager\x1B[0m\n");
  print("\x1B[33m1.\x1B[0m Neues Passwort speichern");
  print("\x1B[33m2.\x1B[0m Passwort anzeigen");
  print("\x1B[33m3.\x1B[0m Accounts anzeigen");
  print("\x1B[33m4.\x1B[0m Passwort löschen");
  print("\x1B[31m5. Beenden\x1B[0m");
  stdout.write("Wähle eine Option: ");
  String? choice = stdin.readLineSync();

  switch (choice) {
    case "1":
      addPassword();
    case "2":
      getPassword();
    case "3":
      listAccounts();
    case "4":
      deletePassword();
    case "5":
      print("Programm wird beendet...");
      return;
    default:
      print("Ungültige Eingabe!");
  }
  showMenu();
}

// Neues Passwort speichern
void addPassword() {
  stdout.write("Zu welchem Account gehört das Passwort? ");
  String? account = stdin.readLineSync();
  stdout.write("Gib nun dein Passwort ein: ");
  String? password = stdin.readLineSync();

  if (account != null && password != null) {
    passwords[account] = password;
    print("Passwort für $account gespeichert!");
  } else {
    print("Ungültige Eingabe!");
  }
}

// Ein Passwort anzeigen
void getPassword() {
  stdout.write("Für Welchen Account? ");
  String? account = stdin.readLineSync();

  if (account != null && passwords.containsKey(account)) {
    print("Passwort für $account: ${passwords[account]}");
  } else {
    print("Kein Passwort gefunden!");
  }
}

// Alle Accounts anzeigen
void listAccounts() {
  if (passwords.isEmpty) {
    print("Keine Passwörter gespeichert!");
  } else {
    print("Gespeicherte Accounts:");
    for (String account in passwords.keys) {
      print("- $account");
    }
  }
}

// Ein Passwort löschen
void deletePassword() {
  stdout.write("Welches Passwort soll gelöscht werden? ");
  String? account = stdin.readLineSync();

  if (account != null && passwords.containsKey(account)) {
    passwords.remove(account);
    print("Passwort für $account wurde gelöscht!");
  } else {
    print("Kein Passwort für diesen Account gefunden!");
  }
}

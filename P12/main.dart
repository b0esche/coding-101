import "chat.dart";
import "database_repository.dart";
import "user.dart";

// import "chat.dart";

void main() {
  MockDatabaseRepository repo = MockDatabaseRepository();

  User dj = DJ(
      userId: "dj_000",
      name: "DJ Lorem Ipsum",
      email: "djloremipsum@email.com",
      userType: UserType.dj,
      genres: ["House", "G-House"],
      headUrl:
          "https://www.leadersnet.de/resources/images/2024/4/24/141616/bootshaus-koeln-mit-dj-diesel_748_486_crop_939ea044d44337fae475b812f4e61f4e.jpg",
      city: "Berlin",
      bpmMin: 120,
      bpmMax: 130,
      about: "Ich will der allerbeste sein!",
      set1Url: "qertqrtre",
      set2Url: "zzrtzwrtt",
      info: "Ich habe kein Auto...",
      rating: 4.0,
      repo: repo);

  User dj1 = DJ(
      userId: "dj_001",
      name: "DJ Ötzi",
      email: "djoetzi@email.com",
      userType: UserType.dj,
      genres: ["House", "Schranz"],
      headUrl: "https://www.leadersnet.de/resources/images/",
      city: "Berlin",
      bpmMin: 120,
      bpmMax: 140,
      about: "I bin so schööö!",
      set1Url: "qertqrtre",
      set2Url: "zzrtzwrtt",
      info: "I bi da Anton",
      rating: 4.5,
      repo: repo);

  User dj2 = DJ(
      userId: "dj_002",
      name: "DJ Claudio Fahihi Montana",
      email: "claudiofahihimontana@email.com",
      userType: UserType.dj,
      genres: ["Gabber", "Hardtekk"],
      headUrl: "https://www.leadersnet.de/resources/images/",
      city: "Saint-Tropez",
      bpmMin: 140,
      bpmMax: 170,
      about: "Ich spiel' die Musik.",
      set1Url: "qertqrtre",
      set2Url: "zzrtzwrtt",
      info: "Unter 20.000€ kommen wir auf keinen grünen Zweig.",
      rating: 5.0,
      repo: repo);

  User dj3 = DJ(
      userId: "dj_003",
      name: "DJ Carlos Clementino",
      email: "carlosclementino@email.com",
      userType: UserType.dj,
      genres: ["Downtempo", "House"],
      headUrl: "https://www.leadersnet.de/resources/images/",
      city: "Izmir",
      bpmMin: 100,
      bpmMax: 120,
      about: "Keiner kocht wie ich!",
      set1Url: "qertqrtre",
      set2Url: "zzrtzwrtt",
      info: "Ich lege ausschließlich bei JGAs auf.",
      rating: 4.0,
      repo: repo);

  User booker = Booker(
      userId: "booker_000",
      name: "BitBat Club",
      email: "bitbatclub@email.com",
      userType: UserType.booker,
      headUrl:
          "https://www.club-stereo.net/wp-content/uploads/2025/02/verifiziert-150225-sarahwhoeverphoto-12.jpg",
      city: "Berlin",
      type: "Club",
      about: "Bei uns gehts anders ab!",
      mediaUrl: [
        "https://www.club-stereo.net/wp-content/uploads/2025/02/verifiziert-150225-sarahwhoeverphoto-12.jpg"
      ],
      info: "Du brauchst unbedingt ein Auto!",
      rating: 5.0,
      repo: repo);

  // dj.showProfile();
  // booker.showProfile();
  // repo.addUser(dj);
  // repo.addUser(dj1);
  // repo.addUser(dj2);
  // repo.addUser(dj3);
  // repo.addUser(booker);
  //print(repo.getUsers());
  repo.SendMessage(ChatMessage(
      id: "987",
      senderId: "booker_000",
      receiverId: "dj_002",
      message: "Moin!",
      timestamp: DateTime.timestamp()));
  repo.SendMessage(ChatMessage(
      id: "988",
      senderId: "dj_002",
      receiverId: "booker_000",
      message: "Selber Moin!",
      timestamp: DateTime.timestamp()));
  print(repo.searchDJs(["House", "Gabber"], null, null, null));
  print(repo.getMessages("booker_000", "dj_002"));
}

import "database_repository.dart";
import "user.dart";

// import "chat.dart";

void main() {
  MockDatabaseRepository repo = MockDatabaseRepository();

  User dj = DJ(
      userId: "dj_001",
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
      rating: 4.0);

  User booker = Booker(
      userId: "booker_001",
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
      rating: 5.0);

  dj.showProfile();
  booker.showProfile();
  repo.addUser(dj);
  repo.addUser(booker);
  print(repo.getUsers());
  print(repo.searchDJs(["House"], "Berlin", null, null));
}

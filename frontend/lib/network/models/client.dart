class TourClient {
  final int id;
  final String name;
  final String surname;
  final String birthday;

  TourClient(
      {required this.id,
      required this.name,
      required this.surname,
      required this.birthday});

  TourClient.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        surname = json["surname"],
        birthday = json["birthday"];
}

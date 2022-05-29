class Manager {
  final int id;
  final String name;
  final String surname;
  final String birthday;
  final String travelAgency;
  final int travelAgencyId;

  Manager(
      {required this.id,
      required this.name,
      required this.surname,
      required this.birthday,
      required this.travelAgency,
      required this.travelAgencyId});

  Manager.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        surname = json["surname"],
        birthday = json["birthday"],
        travelAgency = json["travel_agency"],
        travelAgencyId = json["id_travel_agency"];
}


class TravelAgency {
  final int id;
  final String name;
  final String address;

  TravelAgency({required this.id, required this.name, required this.address});

  TravelAgency.fromJson(Map<String, dynamic> json):
      id = json["id"],
      name = json["name"],
      address = json["address"];
}

class TourOperator {
  int id;
  String name;

  TourOperator({required this.id, required this.name});

  TourOperator.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"];
}
class HotelBooking {
  int id;
  String dateStart;
  String dateEnd;
  double price;

  HotelBooking(
      {required this.id,
      required this.dateStart,
      required this.dateEnd,
      required this.price});

  HotelBooking.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        dateStart = json["date_start"],
        dateEnd = json["date_end"],
        price = json["price"];
}

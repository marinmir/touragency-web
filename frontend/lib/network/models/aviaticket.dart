enum AviaticketClass { business, econom }

class Aviaticket {
  int id;
  double price;
  bool isOneWay;
  AviaticketClass ticketClass;

  Aviaticket(
      {required this.id,
      required this.price,
      required this.isOneWay,
      required this.ticketClass});

  Aviaticket.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        price = json["price"],
        isOneWay = json["one_way"],
        ticketClass = Aviaticket.ticketClassFromString(json["ticket_class"]);

  static AviaticketClass ticketClassFromString(String rawValue) {
    if (rawValue == "business") {
      return AviaticketClass.business;
    } else {
      return AviaticketClass.econom;
    }
  }

  static String stringFromTicketClass(AviaticketClass ticketClass) {
    switch (ticketClass) {
      case AviaticketClass.econom:
        return "econom";
      case AviaticketClass.business:
        return "business";
    }
  }
}

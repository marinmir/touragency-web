import 'package:touragency_frontend/network/models/aviaticket.dart';
import 'package:touragency_frontend/network/models/client.dart';
import 'package:touragency_frontend/network/models/country.dart';
import 'package:touragency_frontend/network/models/hotel_booking.dart';
import 'package:touragency_frontend/network/models/manager.dart';
import 'package:touragency_frontend/network/models/tour_operator.dart';

class Tour {
  int id;
  Aviaticket aviaticket;
  Country country;
  HotelBooking hotelBooking;
  TourClient client;
  Manager manager;
  TourOperator tourOperator;

  Tour(
      {required this.id,
      required this.aviaticket,
      required this.country,
      required this.hotelBooking,
      required this.client,
      required this.manager,
      required this.tourOperator});

  Tour.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        aviaticket = Aviaticket.fromJson(Map.from(json["aviaticket"])),
        country = Country.fromJson(Map<String, dynamic>.from(json["country"])),
        hotelBooking = HotelBooking.fromJson(Map<String, dynamic>.from(json["hotel_booking"])),
        client = TourClient.fromJson(Map<String, dynamic>.from(json["tour_client"])),
        manager = Manager.fromJson(Map<String, dynamic>.from(json["tour_manager"])),
        tourOperator = TourOperator.fromJson(Map<String, dynamic>.from(json["tour_operator"]));
}

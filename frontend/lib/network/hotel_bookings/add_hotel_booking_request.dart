import 'package:touragency_frontend/network/base/network_request.dart';

class AddHotelBookingRequest extends NetworkRequest {
  final String dateStart;
  final String dateEnd;
  final int price;

  AddHotelBookingRequest(
      {required this.dateStart,
        required this.dateEnd,
        required this.price});

  @override
  Map<String, dynamic> get body => {
    "date_start": dateStart,
    "date_end": dateEnd,
    "price": price
  };

  @override
  String get path => "/hotel_booking";

  @override
  NetworkRequestType get type => NetworkRequestType.post;
}

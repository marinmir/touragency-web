import 'package:touragency_frontend/network/base/network_request.dart';

class AddTourRequest extends NetworkRequest {
  final int clientId;
  final int managerId;
  final int tourOperatorId;
  final int countryId;
  final int hotelBookingId;
  final int aviaticketId;

  AddTourRequest(
      {required this.clientId,
        required this.managerId,
        required this.tourOperatorId,
        required this.countryId,
        required this.hotelBookingId,
        required this.aviaticketId});

  @override
  Map<String, dynamic> get body => {
    "id_client": clientId,
    "id_manager": managerId,
    "id_tour_operator": tourOperatorId,
    "id_country": countryId,
    "id_hotel_booking": hotelBookingId,
    "id_aviaticket": aviaticketId
  };

  @override
  String get path => "/tour";

  @override
  NetworkRequestType get type => NetworkRequestType.post;
}

import 'package:touragency_frontend/network/base/network_request.dart';

class AddManagerRequest extends NetworkRequest {
  final int travelAgencyId;
  final String name;
  final String surname;
  final String birthday;

  AddManagerRequest(
      {required this.travelAgencyId,
      required this.name,
      required this.surname,
      required this.birthday});

  @override
  Map<String, dynamic> get body => {
        "id_travel_agency": travelAgencyId,
        "name": name,
        "surname": surname,
        "birthday": birthday
      };

  @override
  String get path => "/tour_manager";

  @override
  NetworkRequestType get type => NetworkRequestType.post;
}

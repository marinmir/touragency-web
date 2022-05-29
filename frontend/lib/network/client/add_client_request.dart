import 'package:touragency_frontend/network/base/network_request.dart';

class AddClientRequest extends NetworkRequest {
  final String name;
  final String surname;
  final String birthday;

  AddClientRequest(
      {required this.name,
        required this.surname,
        required this.birthday});

  @override
  Map<String, dynamic> get body => {
    "name": name,
    "surname": surname,
    "birthday": birthday
  };

  @override
  String get path => "/tour_client";

  @override
  NetworkRequestType get type => NetworkRequestType.post;
}

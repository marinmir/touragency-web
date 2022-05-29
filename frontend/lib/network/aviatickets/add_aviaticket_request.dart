import 'package:touragency_frontend/network/base/network_request.dart';

class AddAviaticketRequest extends NetworkRequest {
  final bool oneWay;
  final String ticketClass;
  final int price;

  AddAviaticketRequest(
      {required this.oneWay,
        required this.ticketClass,
        required this.price});

  @override
  Map<String, dynamic> get body => {
    "one_way": oneWay,
    "ticket_class": ticketClass,
    "price": price
  };

  @override
  String get path => "/aviaticket";

  @override
  NetworkRequestType get type => NetworkRequestType.post;
}

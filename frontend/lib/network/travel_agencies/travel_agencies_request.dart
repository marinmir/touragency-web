import 'package:touragency_frontend/network/base/network_request.dart';

class TravelAgenciesRequest extends NetworkRequest {
  final int limit;
  final int offset;

  TravelAgenciesRequest({required this.limit, required this.offset});

  @override
  Map<String, dynamic> get parameters => {"limit": "$limit", "offset": "$offset"};

  @override
  String get path => "/travel_agencies";

  @override
  NetworkRequestType get type => NetworkRequestType.get;
}

import 'package:touragency_frontend/network/base/network_request.dart';

class CountriesRequest extends NetworkRequest {
  final int limit;
  final int offset;

  CountriesRequest({required this.limit, required this.offset});

  @override
  Map<String, dynamic> get parameters => {"limit": "$limit", "offset": "$offset"};

  @override
  String get path => "/countries";

  @override
  NetworkRequestType get type => NetworkRequestType.get;
}

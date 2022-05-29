import 'package:touragency_frontend/network/base/network_request.dart';

class ManagersRequest extends NetworkRequest {
  final int limit;
  final int offset;

  ManagersRequest({required this.limit, required this.offset});

  @override
  Map<String, dynamic> get parameters => {"limit": "$limit", "offset": "$offset"};

  @override
  String get path => "/tour_managers";

  @override
  NetworkRequestType get type => NetworkRequestType.get;
}

import 'package:touragency_frontend/network/base/network_request.dart';

class DeleteManagerRequest extends NetworkRequest {
  final int id;

  DeleteManagerRequest(
      {required this.id});

  @override
  Map<String, dynamic> get parameters => {
    "id": "$id"
  };

  @override
  String get path => "/tour_manager";

  @override
  NetworkRequestType get type => NetworkRequestType.delete;
}

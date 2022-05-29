import 'package:touragency_frontend/network/base/network_request.dart';

class AuthRequest extends NetworkRequest {
  final String username;
  final String password;

  AuthRequest({required this.password, required this.username});

  @override
  Map<String, dynamic> get body => {"username": username, "password": password};

  @override
  String get path => "/login";

  @override
  NetworkRequestType get type => NetworkRequestType.post;
}

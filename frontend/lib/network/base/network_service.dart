
import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:touragency_frontend/network/base/network_request.dart';
import 'package:http/http.dart';

abstract class NetworkService {
  Future<Map<String, dynamic>?> execute(NetworkRequest request);
}

class NetworkServiceImpl extends NetworkService {
  final String host;

  NetworkServiceImpl({required this.host});

  @override Future<Map<String, dynamic>?> execute(NetworkRequest request) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    var headers = request.headers;

    if (token != null) {
      headers.addAll({"Authorization": "Bearer $token"});
    }
    
    Response response;
    final url = request.toUri(host);
    try {
      switch (request.type) {
        case NetworkRequestType.get:
          response = await get(url, headers: headers);
          break;
        case NetworkRequestType.post:
          response = await post(url, headers: headers, body: jsonEncode(request.body));
          break;
        case NetworkRequestType.patch:
          response = await patch(url, headers: headers);
          break;
        case NetworkRequestType.delete:
          response = await delete(url, headers: headers);
      }

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return {"error": response.body.toString(), "code": response.statusCode};
      }
      if (response.body.isNotEmpty) {
        return jsonDecode(response.body);
      } else {
        return {"status": "no content"};
      }

    } on SocketException {
      print("Network error");
    }
  }
}
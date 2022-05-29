import 'package:shared_preferences/shared_preferences.dart';
import 'package:touragency_frontend/network/auth/auth_request.dart';
import 'package:touragency_frontend/network/base/network_service.dart';

abstract class AuthService {
  Future<bool> login(String username, String password);
}

class AuthServiceImpl extends AuthService {
  final NetworkService networkService;

  AuthServiceImpl({required this.networkService});

  @override
  Future<bool> login(String username, String password) async {
    final response = await networkService
        .execute(AuthRequest(password: password, username: username));

    if (response == null || response["error"] != null) {
      return false;
    }

    final token = response["access_token"];
    final sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setString("access_token", token);
    return true;
  }
}

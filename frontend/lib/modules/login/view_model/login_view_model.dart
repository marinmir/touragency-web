
abstract class LoginViewModel {
  Sink<String> get username;
  Sink<String> get password;
  Stream<bool> get canLogin;
  Stream<bool> get hasError;

  void didTapLogin();
}

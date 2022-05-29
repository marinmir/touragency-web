import 'package:touragency_frontend/auth/auth_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:touragency_frontend/modules/login/coordinator/login_coordinator.dart';
import 'package:touragency_frontend/modules/login/view_model/login_view_model.dart';

class LoginViewModelImpl extends LoginViewModel {
  final AuthService authService;
  final LoginCoordinator coordinator;

  final BehaviorSubject<String> _usernameSubject = BehaviorSubject.seeded("");
  final BehaviorSubject<String> _passwordSubject = BehaviorSubject.seeded("");
  final PublishSubject<bool> _hasErrorSubject = PublishSubject();

  @override
  Sink<String> get username => _usernameSubject.sink;
  @override
  Sink<String> get password => _passwordSubject.sink;
  @override
  Stream<bool> get canLogin => Rx.combineLatest2(
      _usernameSubject.stream,
      _passwordSubject.stream,
          (String login, String password) =>
      login.isNotEmpty && password.isNotEmpty);
  @override
  Stream<bool> get hasError => _hasErrorSubject.stream;

  LoginViewModelImpl({required this.coordinator, required this.authService});

  @override
  void didTapLogin() async {
    final username = _usernameSubject.value;
    final password = _passwordSubject.value;

    final success = await authService.login(username, password);
    if (success) {
      coordinator.navigateToMain();
    } else {
      _hasErrorSubject.add(true);
    }
  }
}

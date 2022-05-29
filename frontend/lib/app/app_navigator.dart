import 'package:flutter/material.dart';
import 'package:touragency_frontend/auth/auth_service.dart';
import 'package:touragency_frontend/modules/add_manager/view/add_manager_screen.dart';
import 'package:touragency_frontend/modules/add_manager/view_model/add_manager_view_model_impl.dart';
import 'package:touragency_frontend/modules/add_manager/view_model/services/add_manager_service_impl.dart';
import 'package:touragency_frontend/modules/login/coordinator/login_coordinator_impl.dart';
import 'package:touragency_frontend/modules/login/view/login_screen.dart';
import 'package:touragency_frontend/modules/login/view_model/login_view_model_impl.dart';
import 'package:touragency_frontend/modules/main/coordinator/main_coordinator.dart';
import 'package:touragency_frontend/modules/main/view/main_screen.dart';
import 'package:touragency_frontend/modules/main/view_model/main_view_model_impl.dart';
import 'package:touragency_frontend/network/base/network_service.dart';

abstract class AppNavigator {
  static final _networkService = NetworkServiceImpl(host: "localhost:1323");
  static final _authService = AuthServiceImpl(networkService: _networkService);

  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
            builder: (context) => LoginView(
                viewModel: LoginViewModelImpl(
                    coordinator: LoginCoordinatorImpl(context: context),
                    authService: _authService)));
      case "/main":
        return MaterialPageRoute(
            builder: (context) => MainView(
                viewModel: MainViewModelImpl(
                    coordinator: MainCoordinator(
                        context: context, networkService: _networkService))));
      case "/manager/add":
        return MaterialPageRoute(
            builder: (context) => AddManagerView(
                viewModel: AddManagerViewModelImpl(
                    service: AddManagerServiceImpl(
                        networkService: _networkService))));
    }
    return MaterialPageRoute(
        builder: (context) => const Scaffold(
              body: Center(
                child: Text("Unknown page was requested!"),
              ),
            ));
  }
}

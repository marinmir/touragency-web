
import 'package:flutter/material.dart';
import 'package:touragency_frontend/modules/login/coordinator/login_coordinator.dart';

class LoginCoordinatorImpl extends LoginCoordinator {
  final BuildContext context;

  LoginCoordinatorImpl({required this.context});

  @override
  void navigateToMain() {
    Navigator.pushReplacementNamed(context, "/main");
  }

}
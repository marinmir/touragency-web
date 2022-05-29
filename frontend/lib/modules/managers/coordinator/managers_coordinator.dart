
import 'package:flutter/material.dart';

class ManagersCoordinator {
  final BuildContext context;

  ManagersCoordinator({required this.context});

  Future<void> showAddManagerScreen() async {
    await Navigator.pushNamed(context, "/manager/add");
  }
}
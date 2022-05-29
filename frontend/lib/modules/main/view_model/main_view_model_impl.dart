import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rxdart/rxdart.dart';
import 'package:touragency_frontend/modules/main/coordinator/main_coordinator.dart';
import 'package:touragency_frontend/modules/main/view_model/main_view_model.dart';

class MainViewModelImpl extends MainViewModel {
  final MainCoordinator coordinator;
  final BehaviorSubject<Widget> _contentStream = BehaviorSubject.seeded(Center(
    child: Text(
        "Welcome to demo web-application for touragency system.\nTap burger button in the top left corner to start work."),
  ));

  MainViewModelImpl({required this.coordinator});

  @override
  Stream<Widget> get content => _contentStream.stream;

  @override
  void didTapManagers() {
    _contentStream.add(coordinator.getManagersScreen());
  }

  @override
  void didTapTourOperators() {
    _contentStream.add(coordinator.getTourOperatorsScreen());
  }

  @override
  void didTapTours() {
    _contentStream.add(coordinator.getTourScreen());
  }
}

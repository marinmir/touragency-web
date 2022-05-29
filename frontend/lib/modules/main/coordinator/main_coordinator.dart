import 'package:flutter/material.dart';
import 'package:touragency_frontend/modules/managers/coordinator/managers_coordinator.dart';
import 'package:touragency_frontend/modules/managers/view/managers_screen.dart';
import 'package:touragency_frontend/modules/managers/view_model/managers_view_model_impl.dart';
import 'package:touragency_frontend/modules/managers/view_model/services/managers_service_impl.dart';
import 'package:touragency_frontend/modules/tour/tour_coordinator.dart';
import 'package:touragency_frontend/modules/tour_operators/view/tour_operators_screen.dart';
import 'package:touragency_frontend/modules/tour_operators/view_model/service/tour_operators_service_impl.dart';
import 'package:touragency_frontend/modules/tour_operators/view_model/tour_operators_view_model_impl.dart';
import 'package:touragency_frontend/network/base/network_service.dart';

class MainCoordinator {
  final BuildContext context;
  final NetworkService networkService;
  final TourCoordinator tourCoordinator;

  MainCoordinator({required this.context, required this.networkService})
      : tourCoordinator =
            TourCoordinator(context: context, networkService: networkService);

  Widget getManagersScreen() {
    return ManagersView(
        viewModel: ManagersViewModelImpl(
            coordinator: ManagersCoordinator(context: context),
            managersService:
                ManagersServiceImpl(networkService: networkService)));
  }

  Widget getTourOperatorsScreen() {
    return TourOperatorsView(
        viewModel: TourOperatorsViewModelImpl(
            service: TourOperatorsServiceImpl(networkService: networkService)));
  }

  Widget getTourScreen() {
    return tourCoordinator.getStartScreen();
  }
}

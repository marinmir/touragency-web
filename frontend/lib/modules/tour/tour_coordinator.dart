
import 'package:flutter/material.dart';
import 'package:touragency_frontend/modules/tour/add_client/view/add_client_screen.dart';
import 'package:touragency_frontend/modules/tour/add_client/view_model/add_client_view_model_impl.dart';
import 'package:touragency_frontend/modules/tour/add_client/view_model/service/add_client_service_impl.dart';
import 'package:touragency_frontend/modules/tour/setup_tour/view/setup_tour_screen.dart';
import 'package:touragency_frontend/modules/tour/setup_tour/view_model/service/setup_tour_service_impl.dart';
import 'package:touragency_frontend/modules/tour/setup_tour/view_model/setup_tour_view_model_impl.dart';
import 'package:touragency_frontend/network/base/network_service.dart';
import 'package:touragency_frontend/network/models/client.dart';
import 'package:touragency_frontend/network/models/manager.dart';

class TourCoordinator {
  final BuildContext context;
  final NetworkService networkService;
  SetupTourViewModelImpl? setupTourViewModel;

  final _pageController = PageController();

  TourCoordinator({required this.context, required this.networkService});


  Widget getStartScreen() {
    setupTourViewModel = SetupTourViewModelImpl(coordinator: this, service: SetupTourServiceImpl(networkService: networkService));
    return SizedBox(
      width: 1200,
      height: 1000,
      child: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          AddClientScreen(viewModel: AddClientViewModelImpl(coordinator: this,  addClientService: AddClientServiceImpl(networkService: networkService))),
          SetupTourView(viewModel: setupTourViewModel!)
        ],
      ),
    );
  }

  void didCompleteTourCreation() {
    _pageController.animateToPage(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  void routeToTourCreation(TourClient client, Manager manager) {
    setupTourViewModel!.client = client;
    setupTourViewModel!.manager = manager;
    _pageController.animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

}
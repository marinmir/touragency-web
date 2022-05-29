import 'package:rxdart/rxdart.dart';
import 'package:touragency_frontend/modules/managers/coordinator/managers_coordinator.dart';
import 'package:touragency_frontend/modules/managers/view_model/managers_view_model.dart';
import 'package:touragency_frontend/network/models/manager.dart';
import 'package:touragency_frontend/modules/managers/view_model/services/managers_service.dart';

class ManagersViewModelImpl extends ManagersViewModel {
  final ManagersService managersService;
  final ManagersCoordinator coordinator;
  final BehaviorSubject<List<Manager>> _managersSubject = BehaviorSubject.seeded([]);
  final BehaviorSubject<bool> _showLoaderSubject = BehaviorSubject.seeded(true);
  final PublishSubject<String> _errorTextSubject = PublishSubject();

  final int _limit = 50;
  final int _offset = 0;

  ManagersViewModelImpl({required this.coordinator, required this.managersService});

  @override
  Stream<List<Manager>> get managers => _managersSubject.stream;
  @override
  Stream<bool> get showLoader => _showLoaderSubject.stream;
  @override
  Stream<String> get errorText => _errorTextSubject.stream;

  @override
  void onLoad() async {
    final managers = await managersService.getManagers(_limit, _offset);
    _showLoaderSubject.add(false);
    _managersSubject.add(managers);
  }

  @override
  void didTapAddManager() async {
    await coordinator.showAddManagerScreen();
    onLoad();
  }

  @override
  void delete(Manager manager) async {
    final result = await managersService.delete(manager);
    if (result) {
      onLoad();
    } else {
      _errorTextSubject.add("There was error on deleting manager!");
    }
  }
}
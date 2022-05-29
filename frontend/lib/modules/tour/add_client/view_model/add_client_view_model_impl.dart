
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:touragency_frontend/modules/tour/add_client/view_model/add_client_view_model.dart';
import 'package:touragency_frontend/modules/tour/add_client/view_model/service/add_client_service.dart';
import 'package:touragency_frontend/modules/tour/tour_coordinator.dart';
import 'package:touragency_frontend/network/models/client.dart';
import 'package:touragency_frontend/network/models/manager.dart';

class AddClientViewModelImpl extends AddClientViewModel {
  final AddClientService addClientService;
  final TourCoordinator coordinator;

  final BehaviorSubject<List<Manager>> _managersSubject = BehaviorSubject.seeded([]);
  final BehaviorSubject<DateTime> _birthdaySubject = BehaviorSubject.seeded(DateTime.now());
  final BehaviorSubject<String> _nameSubject = BehaviorSubject.seeded("");
  final BehaviorSubject<String> _surnameSubject = BehaviorSubject.seeded("");
  final PublishSubject<Manager> _managerSubject = PublishSubject();
  final BehaviorSubject<bool> _canProceedSubject = BehaviorSubject.seeded(false);

  TourClient? _client;
  Manager? _manager;

  final _formatter = DateFormat("yyyy-MM-dd");

  AddClientViewModelImpl({required this.coordinator, required this.addClientService}) {
    Rx.combineLatest4(_birthdaySubject, _nameSubject, _surnameSubject, _managerSubject, (a, b, c, d)  {
      return true;
    }).listen((event) {
      _canProceedSubject.add(event);
    });

    _managerSubject.stream.listen((event) {
      _manager = event;
    });
  }
  @override
  Sink<DateTime> get birthday => _birthdaySubject.sink;

  @override
  Sink<Manager> get manager => _managerSubject.sink;

  @override
  Stream<List<Manager>> get managers => _managersSubject.stream;

  @override
  Sink<String> get name => _nameSubject.sink;

  @override
  Sink<String> get surname => _surnameSubject.sink;

  @override
  Stream<bool> get canProceed => _canProceedSubject.stream;

  @override
  void onSaveClient() async {
    _client = await addClientService.addClient(_nameSubject.value, _surnameSubject.value, _formatter.format(_birthdaySubject.value));

    if (_client != null) {
      coordinator.routeToTourCreation(_client!, _manager!);
    }
  }

  @override
  void onLoad() async {
    final managers = await addClientService.loadManagers();

    _managersSubject.add(managers);
  }


}
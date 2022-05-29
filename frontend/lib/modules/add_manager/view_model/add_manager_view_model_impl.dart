import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:touragency_frontend/modules/add_manager/view_model/add_manager_view_model.dart';
import 'package:touragency_frontend/modules/add_manager/view_model/services/add_manager_service.dart';
import 'package:touragency_frontend/network/models/manager.dart';
import 'package:touragency_frontend/network/models/travel_agency.dart';

class AddManagerViewModelImpl extends AddManagerViewModel {
  final PublishSubject<DateTime> _birthdaySubject = PublishSubject();
  final PublishSubject<String> _nameSubject = PublishSubject();
  final PublishSubject<String> _surnameSubject = PublishSubject();
  final PublishSubject<TravelAgency> _travelAgencySubject = PublishSubject();
  final PublishSubject<List<TravelAgency>> _travelAgenciesSubject =
      PublishSubject();
  final PublishSubject<String> _errorTextSubject = PublishSubject();
  final PublishSubject<void> _shouldCloseSubject = PublishSubject();
  final BehaviorSubject<bool> _canAddManagerSubject = BehaviorSubject.seeded(false);

  Manager? manager;
  final formatter = DateFormat("yyyy-MM-dd");

  final AddManagerService service;
  Stream? _subscription;

  AddManagerViewModelImpl({required this.service}) {
  }

  @override
  Sink<DateTime> get birthday => _birthdaySubject.sink;

  @override
  Sink<String> get name => _nameSubject.sink;

  @override
  Sink<String> get surname => _surnameSubject.sink;

  @override
  Sink<TravelAgency> get travelAgency => _travelAgencySubject.sink;

  @override
  Stream<List<TravelAgency>> get travelAgencies =>
      _travelAgenciesSubject.stream;

  @override
  Stream<bool> get canAddManager => _canAddManagerSubject.stream;

  @override
  Stream<String> get errorText => _errorTextSubject.stream;
  @override
  Stream<void> get shouldClose => _shouldCloseSubject.stream;

  @override
  void onLoad() async {
    final travelAgencies = await service.getTravelAgencies();
    _travelAgenciesSubject.add(travelAgencies);

    Rx.combineLatest4(
        _birthdaySubject.stream, _nameSubject.stream, _surnameSubject.stream, _travelAgencySubject.stream,
            (DateTime birthday, String name, String surname, TravelAgency travelAgency) {
          return Manager(
              id: 0,
              name: name,
              surname: surname,
              birthday: formatter.format(birthday),
              travelAgency: travelAgency.name,
              travelAgencyId: travelAgency.id);

        }).listen((event) {
          manager = event;
      _canAddManagerSubject.add(true);
    });
  }

  @override
  void didTapAdd() async {
    if (manager != null) {
      final success = await service.addTourManager(manager!.travelAgencyId, manager!.name, manager!.surname, manager!.birthday);
      if (success) {
        _shouldCloseSubject.add(null);
      } else {
        _errorTextSubject.add("There was an error while adding tour manager to the database");
      }
    }

  }
}

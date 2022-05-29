import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:touragency_frontend/modules/tour/setup_tour/view_model/service/setup_tour_service.dart';
import 'package:touragency_frontend/modules/tour/setup_tour/view_model/setup_tour_view_model.dart';
import 'package:touragency_frontend/modules/tour/tour_coordinator.dart';
import 'package:touragency_frontend/network/models/aviaticket.dart';
import 'package:touragency_frontend/network/models/client.dart';
import 'package:touragency_frontend/network/models/country.dart';
import 'package:touragency_frontend/network/models/hotel_booking.dart';
import 'package:touragency_frontend/network/models/manager.dart';
import 'package:touragency_frontend/network/models/tour_operator.dart';

class SetupTourViewModelImpl extends SetupTourViewModel {
  final SetupTourService service;
  TourClient? client;
  Manager? manager;
  final formatter = DateFormat("yyyy-MM-dd");
  final TourCoordinator coordinator;

  final PublishSubject<DateTime> _bookingStartSubject = PublishSubject();
  final PublishSubject<DateTime> _bookingEndSubject = PublishSubject();
  final PublishSubject<double> _bookingPriceSubject = PublishSubject();
  final BehaviorSubject<bool> _bookingReadySubject =
      BehaviorSubject.seeded(false);

  final PublishSubject<double> _ticketPriceSubject = PublishSubject();
  final PublishSubject<String> _ticketClassSubject = PublishSubject();
  final PublishSubject<bool> _ticketOneWaySubject = PublishSubject();
  final BehaviorSubject<bool> _ticketReadySubject =
      BehaviorSubject.seeded(false);

  final BehaviorSubject<List<Country>> _countriesSubject =
      BehaviorSubject.seeded([]);
  final PublishSubject<Country> _countrySubject = PublishSubject();

  final BehaviorSubject<List<TourOperator>> _tourOperatorsSubject =
      BehaviorSubject.seeded([]);
  final PublishSubject<TourOperator> _tourOperatorSubject = PublishSubject();

  final BehaviorSubject<bool> _canCreateTourSubject =
      BehaviorSubject.seeded(false);
  final PublishSubject<bool> _successCreateSubject = PublishSubject();

  @override
  Sink<DateTime> get bookingStart => _bookingStartSubject.sink;
  @override
  Sink<DateTime> get bookingEnd => _bookingEndSubject.sink;
  @override
  Sink<double> get bookingPrice => _bookingPriceSubject.sink;
  @override
  Stream<bool> get bookingReady => _bookingReadySubject.stream;
  HotelBooking? _booking;

  @override
  Sink<String> get ticketClass => _ticketClassSubject.sink;
  @override
  Sink<bool> get ticketOneWay => _ticketOneWaySubject.sink;
  @override
  Sink<double> get ticketPrice => _ticketPriceSubject.sink;
  @override
  Stream<bool> get ticketReady => _ticketReadySubject.stream;
  Aviaticket? _tourTicket;

  @override
  Stream<List<Country>> get countries => _countriesSubject.stream;
  @override
  Sink<Country> get country => _countrySubject.sink;
  Country? _selectedCountry;

  @override
  Stream<List<TourOperator>> get tourOperators => _tourOperatorsSubject.stream;
  @override
  Sink<TourOperator> get tourOperator => _tourOperatorSubject.sink;
  TourOperator? _selectedTourOperator;

  @override
  Stream<bool> get canCreateTour => _canCreateTourSubject.stream;
  @override
  Stream<bool> get successCreate => _successCreateSubject.stream;

  SetupTourViewModelImpl({required this.coordinator, required this.service}) {
    Rx.combineLatest3(
        _bookingStartSubject, _bookingEndSubject, _bookingPriceSubject,
        (DateTime dateStart, DateTime dateEnd, double price) {
      return HotelBooking(
          id: 0,
          dateStart: formatter.format(dateStart),
          dateEnd: formatter.format(dateEnd),
          price: price);
    }).listen((event) {
      _booking = event;
      _bookingReadySubject.add(true);
    });

    Rx.combineLatest3(
        _ticketOneWaySubject, _ticketClassSubject, _ticketPriceSubject,
        (bool isOneWay, String ticketClass, double price) {
      return Aviaticket(
          id: 0,
          price: price,
          isOneWay: isOneWay,
          ticketClass: Aviaticket.ticketClassFromString(ticketClass));
    }).listen((event) {
      _tourTicket = event;
      _ticketReadySubject.add(true);
    });

    _tourOperatorSubject.listen((value) {
      _selectedTourOperator = value;
    });

    _countrySubject.listen((value) {
      _selectedCountry = value;
    });

    Rx.combineLatest4(_tourOperatorSubject, _countrySubject,
        _ticketReadySubject, _bookingReadySubject,
        (operator, country, bool ticketReady, bool bookingReady) {
      return operator != null && country != null && ticketReady && bookingReady;
    }).listen((event) {
      _canCreateTourSubject.add(event);
    });
  }

  @override
  void onLoad() async {
    final responses = await Future.wait(
        [service.getAllCountries(), service.getAllTourOperators()]);
    List<Country> countries = responses[0] as List<Country>;
    _countriesSubject.add(countries);
    List<TourOperator> tourOperators = responses[1] as List<TourOperator>;
    _tourOperatorsSubject.add(tourOperators);
  }

  @override
  void onCreateHotelBooking() async {
    _booking = await service.createBooking(
        _booking!.dateStart, _booking!.dateEnd, _booking!.price);
  }

  @override
  void onCreateTicket() async {
    _tourTicket = await service.createAviaticket(
        _tourTicket!.ticketClass, _tourTicket!.price, _tourTicket!.isOneWay);
  }

  @override
  void onCreateTour() async {
    final tourCreated = await service.createTour(_tourTicket!, _booking!, client!,
        manager!, _selectedTourOperator!, _selectedCountry!);
    _successCreateSubject.add(tourCreated);
    coordinator.didCompleteTourCreation();
  }
}

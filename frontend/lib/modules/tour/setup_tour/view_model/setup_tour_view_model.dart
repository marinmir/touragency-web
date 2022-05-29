

import 'package:touragency_frontend/network/models/country.dart';
import 'package:touragency_frontend/network/models/tour_operator.dart';

abstract class SetupTourViewModel {
  Sink<double> get ticketPrice;
  Sink<String> get ticketClass;
  Sink<bool> get ticketOneWay;
  Stream<bool> get ticketReady;
  void onCreateTicket();

  Sink<double> get bookingPrice;
  Sink<DateTime> get bookingStart;
  Sink<DateTime> get bookingEnd;
  Stream<bool> get bookingReady;
  void onCreateHotelBooking();

  Stream<List<TourOperator>> get tourOperators;
  Sink<TourOperator> get tourOperator;

  Stream<List<Country>> get countries;
  Sink<Country> get country;

  void onLoad();

  Stream<bool> get canCreateTour;
  void onCreateTour();

  Stream<bool> get successCreate;
}
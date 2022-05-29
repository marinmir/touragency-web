import 'package:touragency_frontend/network/models/aviaticket.dart';
import 'package:touragency_frontend/network/models/client.dart';
import 'package:touragency_frontend/network/models/country.dart';
import 'package:touragency_frontend/network/models/hotel_booking.dart';
import 'package:touragency_frontend/network/models/manager.dart';
import 'package:touragency_frontend/network/models/tour.dart';
import 'package:touragency_frontend/network/models/tour_operator.dart';

abstract class SetupTourService {
  Future<HotelBooking> createBooking(
      String dateStart, String dateEnd, double price);
  Future<Aviaticket> createAviaticket(
      AviaticketClass ticketClass, double price, bool isOneWay);
  Future<bool> createTour(
      Aviaticket ticket,
      HotelBooking booking,
      TourClient client,
      Manager manager,
      TourOperator tourOperator,
      Country country);

  Future<List<Country>> getAllCountries();
  Future<List<TourOperator>> getAllTourOperators();
}

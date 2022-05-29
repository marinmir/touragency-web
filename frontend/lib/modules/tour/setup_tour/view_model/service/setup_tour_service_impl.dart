import 'package:touragency_frontend/modules/tour/setup_tour/view_model/service/setup_tour_service.dart';
import 'package:touragency_frontend/network/aviatickets/add_aviaticket_request.dart';
import 'package:touragency_frontend/network/base/network_service.dart';
import 'package:touragency_frontend/network/countries/countries_request.dart';
import 'package:touragency_frontend/network/hotel_bookings/add_hotel_booking_request.dart';
import 'package:touragency_frontend/network/models/aviaticket.dart';
import 'package:touragency_frontend/network/models/client.dart';
import 'package:touragency_frontend/network/models/country.dart';
import 'package:touragency_frontend/network/models/hotel_booking.dart';
import 'package:touragency_frontend/network/models/manager.dart';
import 'package:touragency_frontend/network/models/tour.dart';
import 'package:touragency_frontend/network/models/tour_operator.dart';
import 'package:touragency_frontend/network/tour_operators/tour_operators_request.dart';
import 'package:touragency_frontend/network/tours/add_tour_request.dart';

class SetupTourServiceImpl extends SetupTourService {
  final NetworkService networkService;

  SetupTourServiceImpl({required this.networkService});

  @override
  Future<Aviaticket> createAviaticket(
      AviaticketClass ticketClass, double price, bool isOneWay) async {
    final response = await networkService.execute(AddAviaticketRequest(
        oneWay: isOneWay,
        ticketClass: Aviaticket.stringFromTicketClass(ticketClass),
        price: (price * 100).round()));

    if (response == null || response["error"] != null) {
      throw Exception("Error on adding aviaticket");
    }

    return Aviaticket.fromJson(response);
  }

  @override
  Future<HotelBooking> createBooking(
      String dateStart, String dateEnd, double price) async {
    final response = await networkService.execute(AddHotelBookingRequest(
        dateStart: dateStart, dateEnd: dateEnd, price: (price * 100).round()));

    if (response == null || response["error"] != null) {
      throw Exception("Error on adding aviaticket");
    }

    return HotelBooking.fromJson(response);
  }

  @override
  Future<bool> createTour(
      Aviaticket ticket,
      HotelBooking booking,
      TourClient client,
      Manager manager,
      TourOperator tourOperator,
      Country country) async {
    final response = await networkService.execute(AddTourRequest(
        clientId: client.id,
        managerId: manager.id,
        tourOperatorId: tourOperator.id,
        countryId: country.id,
        hotelBookingId: booking.id,
        aviaticketId: ticket.id));

    if (response == null || response["error"] != null) {
      return false;
    }

    return true;
  }

  @override
  Future<List<Country>> getAllCountries() async {
    final response =
        await networkService.execute(CountriesRequest(limit: 100, offset: 0));

    List<Country> result = List.empty(growable: true);
    if (response == null || response["error"] != null) {
      return result;
    }

    final countriesNetwork = response["countries"] as List<dynamic>;

    for (var element in countriesNetwork) {
      final json = Map<String, dynamic>.from(element);
      result.add(Country.fromJson(json));
    }

    return result;
  }

  @override
  Future<List<TourOperator>> getAllTourOperators() async {
    final response = await networkService
        .execute(TourOperatorsRequest(limit: 100, offset: 0));

    List<TourOperator> result = List.empty(growable: true);
    if (response == null || response["error"] != null) {
      return result;
    }

    final tourOperatorsNetwork = response["tour_operators"] as List<dynamic>;

    for (var element in tourOperatorsNetwork) {
      final json = Map<String, dynamic>.from(element);
      result.add(TourOperator.fromJson(json));
    }

    return result;
  }
}

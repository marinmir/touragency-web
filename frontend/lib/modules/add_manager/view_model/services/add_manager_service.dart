
import 'package:touragency_frontend/network/models/travel_agency.dart';

abstract class AddManagerService {
  Future<List<TravelAgency>> getTravelAgencies();
  Future<bool> addTourManager(int travelAgencyId, String name, String surname, String birthday);
}
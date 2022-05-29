
import 'package:touragency_frontend/network/models/travel_agency.dart';

abstract class AddManagerViewModel {
  Sink<String> get name;
  Sink<String> get surname;
  Sink<DateTime> get birthday;
  Sink<TravelAgency> get travelAgency;
  Stream<List<TravelAgency>> get travelAgencies;
  Stream<bool> get canAddManager;

  Stream<String> get errorText;
  Stream<void> get shouldClose;

  void onLoad();
  void didTapAdd();

}
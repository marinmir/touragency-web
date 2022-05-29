
import 'package:touragency_frontend/modules/add_manager/view_model/services/add_manager_service.dart';
import 'package:touragency_frontend/network/base/network_service.dart';
import 'package:touragency_frontend/network/managers/add_manager_request.dart';
import 'package:touragency_frontend/network/models/travel_agency.dart';
import 'package:touragency_frontend/network/travel_agencies/travel_agencies_request.dart';

class AddManagerServiceImpl extends AddManagerService {
  final NetworkService networkService;

  AddManagerServiceImpl({required this.networkService});

  Future<List<TravelAgency>> getTravelAgencies() async {
    final response = await networkService.execute(TravelAgenciesRequest(limit: 20, offset: 0));

    List<TravelAgency> result = List.empty(growable: true);
    if (response == null || response["error"] != null) {
      return result;
    }

    final travelAgenciesNetwork = response["travel_agencies"] as List<dynamic>;

    for (var element in travelAgenciesNetwork) {
      final json = Map<String, dynamic>.from(element);
      result.add(TravelAgency.fromJson(json));
    }

    return result;
  }

  Future<bool> addTourManager(int travelAgencyId, String name, String surname, String birthday) async {
    final response = await networkService.execute(AddManagerRequest(travelAgencyId: travelAgencyId, name: name, surname: surname, birthday: birthday));

    return response != null && response["error"] == null;
  }
}
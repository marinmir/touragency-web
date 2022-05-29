
import 'package:touragency_frontend/modules/tour/add_client/view_model/service/add_client_service.dart';
import 'package:touragency_frontend/network/base/network_service.dart';
import 'package:touragency_frontend/network/client/add_client_request.dart';
import 'package:touragency_frontend/network/managers/managers_request.dart';
import 'package:touragency_frontend/network/models/client.dart';
import 'package:touragency_frontend/network/models/manager.dart';

class AddClientServiceImpl extends AddClientService {
  final NetworkService networkService;
  
  AddClientServiceImpl({required this.networkService});
  
  @override
  Future<TourClient?> addClient(String name, String surname, String birthday) async {
    final response = await networkService.execute(AddClientRequest(name: name, surname: surname, birthday: birthday));

    if (response == null || response["error"] != null) {
      return null;
    }

    final result = Map<String, dynamic>.from(response);
    return TourClient.fromJson(result);
  }

  @override
  Future<List<Manager>> loadManagers() async {
    final response = await networkService.execute(ManagersRequest(limit: 100, offset: 0));

    List<Manager> result = List.empty(growable: true);
    if (response == null || response["error"] != null) {
      return result;
    }

    final managersNetwork = response["managers"] as List<dynamic>;

    for (var element in managersNetwork) {
      final json = Map<String, dynamic>.from(element);
      result.add(Manager.fromJson(json));
    }

    return result;
  }
  
}
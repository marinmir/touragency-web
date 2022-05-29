
import 'package:touragency_frontend/network/managers/delete_manager_request.dart';
import 'package:touragency_frontend/network/models/manager.dart';
import 'package:touragency_frontend/modules/managers/view_model/services/managers_service.dart';
import 'package:touragency_frontend/network/base/network_service.dart';
import 'package:touragency_frontend/network/managers/managers_request.dart';

class ManagersServiceImpl extends ManagersService {
  final NetworkService networkService;

  ManagersServiceImpl({required this.networkService});

  @override
  Future<List<Manager>> getManagers(int limit, int offset) async {
    final response = await networkService
        .execute(ManagersRequest(limit: limit, offset: offset));
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

  @override
  Future<bool> delete(Manager manager) async {
    final response = await networkService.execute(DeleteManagerRequest(id: manager.id));

    return response != null && response["error"] == null;
  }
}

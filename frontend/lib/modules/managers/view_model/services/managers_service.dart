
import 'package:touragency_frontend/network/models/manager.dart';

abstract class ManagersService {
  Future<List<Manager>> getManagers(int limit, int offset);

  Future<bool> delete(Manager manager);
}
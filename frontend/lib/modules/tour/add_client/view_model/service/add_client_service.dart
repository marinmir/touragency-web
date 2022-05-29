
import 'package:touragency_frontend/network/models/client.dart';
import 'package:touragency_frontend/network/models/manager.dart';

abstract class AddClientService {
  Future<List<Manager>> loadManagers();
  Future<TourClient?> addClient(String name, String surname, String birthday);
}
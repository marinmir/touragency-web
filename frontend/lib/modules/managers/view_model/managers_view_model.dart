
import 'package:touragency_frontend/network/models/manager.dart';

abstract class ManagersViewModel {
  Stream<List<Manager>> get managers;
  Stream<bool> get showLoader;
  Stream<String> get errorText;

  void onLoad();
  void didTapAddManager();
  void delete(Manager manager);
}
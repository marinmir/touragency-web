
import 'package:touragency_frontend/network/models/manager.dart';

abstract class AddClientViewModel {
  Stream<List<Manager>> get managers;
  Stream<bool> get canProceed;
  Sink<String> get name;
  Sink<String> get surname;
  Sink<DateTime> get birthday;
  Sink<Manager> get manager;

  void onLoad();
  void onSaveClient();

}
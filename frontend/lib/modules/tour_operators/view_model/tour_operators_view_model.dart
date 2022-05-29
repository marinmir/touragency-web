
import 'package:touragency_frontend/network/models/tour_operator.dart';

abstract class TourOperatorsViewModel {
  Stream<List<TourOperator>> get tourOperators;
  Stream<bool> get showLoader;

  void onLoad();
}
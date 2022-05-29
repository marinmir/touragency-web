
import 'package:touragency_frontend/network/models/tour_operator.dart';

abstract class TourOperatorsService {
  Future<List<TourOperator>> getTourOperators();
}
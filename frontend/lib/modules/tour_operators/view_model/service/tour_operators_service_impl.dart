
import 'package:touragency_frontend/modules/tour_operators/view_model/service/tour_operators_service.dart';
import 'package:touragency_frontend/network/base/network_service.dart';
import 'package:touragency_frontend/network/models/tour_operator.dart';
import 'package:touragency_frontend/network/tour_operators/tour_operators_request.dart';

class TourOperatorsServiceImpl extends TourOperatorsService {
  final NetworkService networkService;

  TourOperatorsServiceImpl({required this.networkService});

  @override
  Future<List<TourOperator>> getTourOperators() async {
    final response = await networkService.execute(TourOperatorsRequest(limit: 100, offset: 0));

    List<TourOperator> result = List.empty(growable: true);
    if (response == null || response["error"] != null) {
      return result;
    }

    final tourOperatorsNetwork = response["tour_operators"] as List<dynamic>;

    for (var element in tourOperatorsNetwork) {
      final json = Map<String, dynamic>.from(element);
      result.add(TourOperator.fromJson(json));
    }

    return result;
  }
}
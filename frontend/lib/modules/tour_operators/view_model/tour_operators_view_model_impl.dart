import 'package:rxdart/rxdart.dart';
import 'package:touragency_frontend/modules/tour_operators/view_model/service/tour_operators_service.dart';
import 'package:touragency_frontend/modules/tour_operators/view_model/tour_operators_view_model.dart';
import 'package:touragency_frontend/network/models/tour_operator.dart';

class TourOperatorsViewModelImpl extends TourOperatorsViewModel {
  final TourOperatorsService service;

  final BehaviorSubject<List<TourOperator>> _tourOperatorsSubject =
      BehaviorSubject.seeded([]);
  final PublishSubject<bool> _showLoaderSubject = PublishSubject();

  TourOperatorsViewModelImpl({required this.service});

  @override
  Stream<List<TourOperator>> get tourOperators => _tourOperatorsSubject.stream;

  @override
  Stream<bool> get showLoader => _showLoaderSubject.stream;

  @override
  void onLoad() async {
    final tourOperators = await service.getTourOperators();
    _tourOperatorsSubject.add(tourOperators);
  }
}

import 'package:flutter/material.dart';
import 'package:touragency_frontend/modules/tour_operators/view_model/tour_operators_view_model.dart';
import 'package:touragency_frontend/network/models/tour_operator.dart';

class TourOperatorsView extends StatefulWidget {
  final TourOperatorsViewModel viewModel;

  TourOperatorsView({required this.viewModel});
  @override
  State<TourOperatorsView> createState() => _TourOperatorsViewState();
}

class _TourOperatorsViewState extends State<TourOperatorsView> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.onLoad();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder(
            stream: widget.viewModel.tourOperators,
            builder: (BuildContext context,
                AsyncSnapshot<List<TourOperator>> snapshot) {
              if (snapshot.hasData) {
                final tourOperators = snapshot.data!;
                if (tourOperators.isNotEmpty) {
                  return ListView.builder(
                      itemCount: tourOperators.length,
                      itemBuilder: (context, index) => ListTile(
                            title: Text(
                                "${index + 1}. ${tourOperators[index].name}"),
                          ));
                } else {
                  return const Center(
                    child: Text("No tour operators is registered in database"),
                  );
                }
              } else {
                return Container();
              }
            }),
        StreamBuilder(
            stream: widget.viewModel.showLoader,
            builder: (context, AsyncSnapshot<bool> snapshot) {
              return Visibility(
                  visible: snapshot.hasData && snapshot.data!,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ));
            }),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:touragency_frontend/modules/managers/view_model/managers_view_model.dart';
import 'package:touragency_frontend/network/models/manager.dart';

class ManagersView extends StatefulWidget {
  final ManagersViewModel viewModel;

  ManagersView({required this.viewModel});
  @override
  State<ManagersView> createState() => _ManagersViewState();
}

class _ManagersViewState extends State<ManagersView> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.onLoad();

    widget.viewModel.errorText.listen((event) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: const Text("Error occurred!"), content: Text(event));
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder(
            stream: widget.viewModel.managers,
            builder:
                (BuildContext context, AsyncSnapshot<List<Manager>> snapshot) {
              if (snapshot.hasData) {
                final managers = snapshot.data!;
                if (managers.isNotEmpty) {
                  return ListView.builder(
                      itemCount: managers.length,
                      itemBuilder: (context, index) => ListTile(
                            title: Text(
                                "${index + 1}. ${managers[index].name} (${managers[index].travelAgency})"),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              tooltip: "Delete manager",
                              onPressed: () {
                                widget.viewModel.delete(managers[index]);
                              },
                            ),
                          ));
                } else {
                  return const Center(
                    child: Text("No managers is registered in database"),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 32, right: 32),
                  child: FloatingActionButton(
                      onPressed: () {
                        widget.viewModel.didTapAddManager();
                      },
                      child: const Icon(Icons.add)),
                )
              ],
            )
          ],
        )
      ],
    );
  }
}

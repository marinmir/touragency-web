import 'package:flutter/material.dart';
import 'package:touragency_frontend/modules/add_manager/view_model/add_manager_view_model.dart';
import 'package:touragency_frontend/network/models/travel_agency.dart';

class AddManagerView extends StatefulWidget {
  final AddManagerViewModel viewModel;

  AddManagerView({required this.viewModel});

  @override
  State<AddManagerView> createState() => _AddManagerViewState();
}

class _AddManagerViewState extends State<AddManagerView> {
  TravelAgency? selectedAgency;

  @override
  void initState() {
    super.initState();
    widget.viewModel.shouldClose.listen((event) {
      Navigator.pop(context, null);
    });
    widget.viewModel.errorText.listen((event) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: const Text("Error occurred!"), content: Text(event));
          });
    });
    widget.viewModel.onLoad();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add manager"),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 500,
            height: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  onChanged: (text) {
                    widget.viewModel.name.add(text);
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Name",
                      hintText: "Enter manager's name"),
                ),
                const SizedBox(height: 16),
                TextField(
                  onChanged: (text) {
                    widget.viewModel.surname.add(text);
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Surname",
                      hintText: "Enter manager's surname"),
                ),
                const SizedBox(height: 16),
                InputDatePickerFormField(
                    initialDate: DateTime(2010),
                    firstDate: DateTime(1950),
                    lastDate: DateTime.now(),
                    fieldLabelText: "Birthday",
                    fieldHintText: "Enter manager's birthday",
                    onDateSubmitted: (date) {
                      setState(() {
                        widget.viewModel.birthday.add(date);
                      });
                    }),
                const SizedBox(height: 16),
                StreamBuilder(
                    stream: widget.viewModel.travelAgencies,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<TravelAgency>> snapshot) {
                      if (snapshot.hasData) {
                        final items = snapshot.data!
                            .map((e) => DropdownMenuItem<TravelAgency>(
                            value: e, child: Text(e.name)))
                            .toList();
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Touragency:"),
                            SizedBox(width: 16),
                            DropdownButton(
                                value: selectedAgency,
                                items: items,
                                onChanged: (TravelAgency? value) {
                                  setState(() {
                                    selectedAgency = value;
                                    widget.viewModel.travelAgency.add(value!);
                                  });
                                })
                          ],
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    }),
                const SizedBox(height: 32),
                StreamBuilder(
                    stream: widget.viewModel.canAddManager,
                    builder:
                        (BuildContext context, AsyncSnapshot<bool> snapshot) {
                      return ElevatedButton(
                          onPressed: snapshot.hasData && snapshot.data!
                              ? () {
                            widget.viewModel.didTapAdd();
                          }
                              : null,
                          child: const Text("Add manager"));
                    })
              ],
            ),
          )

        ],
      ),
    );
  }
}

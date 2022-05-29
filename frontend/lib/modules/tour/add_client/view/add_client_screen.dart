
import 'package:flutter/material.dart';
import 'package:touragency_frontend/modules/tour/add_client/view_model/add_client_view_model.dart';
import 'package:touragency_frontend/network/models/manager.dart';

class AddClientScreen extends StatefulWidget {
  final AddClientViewModel viewModel;

  AddClientScreen({required this.viewModel});

  @override
  State<AddClientScreen> createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {
  Manager? selectedManager;
  
  @override
  void initState() {
    super.initState();
    
    widget.viewModel.onLoad();
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 700,
          height: 700,
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
                    hintText: "Enter client's name"),
              ),
              const SizedBox(height: 16),
              TextField(
                onChanged: (text) {
                  widget.viewModel.surname.add(text);
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Surname",
                    hintText: "Enter client's surname"),
              ),
              const SizedBox(height: 16),
              InputDatePickerFormField(
                  initialDate: DateTime(2010),
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now(),
                  fieldLabelText: "Birthday",
                  fieldHintText: "Enter client's birthday",
                  onDateSubmitted: (date) {
                    setState(() {
                      widget.viewModel.birthday.add(date);
                    });
                  }),
              const SizedBox(height: 16),
              StreamBuilder(
                  stream: widget.viewModel.managers,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Manager>> snapshot) {
                    if (snapshot.hasData) {
                      final items = snapshot.data!
                          .map((e) => DropdownMenuItem<Manager>(
                          value: e, child: Text("${e.name} (${e.travelAgency})")))
                          .toList();
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Manager:"),
                          SizedBox(width: 16),
                          DropdownButton(
                              value: selectedManager,
                              items: items,
                              onChanged: (Manager? value) {
                                setState(() {
                                  selectedManager = value;
                                  widget.viewModel.manager.add(value!);
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
                  stream: widget.viewModel.canProceed,
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    return ElevatedButton(
                        onPressed: snapshot.hasData && snapshot.data!
                            ? () {
                          widget.viewModel.onSaveClient();
                        }
                            : null,
                        child: const Text("Setup tour details"));
                  })
            ],
          ),
        )
      ],
    );
  }
}
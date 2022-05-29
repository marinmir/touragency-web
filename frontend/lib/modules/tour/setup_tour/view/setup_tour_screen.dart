import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:touragency_frontend/modules/tour/setup_tour/view_model/setup_tour_view_model.dart';
import 'package:touragency_frontend/network/models/country.dart';
import 'package:touragency_frontend/network/models/tour_operator.dart';

class SetupTourView extends StatefulWidget {
  final SetupTourViewModel viewModel;

  SetupTourView({required this.viewModel});

  @override
  State<SetupTourView> createState() => _SetupTourViewState();
}

class _SetupTourViewState extends State<SetupTourView> {
  Country? country;
  TourOperator? tourOperator;
  String? ticketClass;
  bool isOneWay = false;

  @override
  void initState() {
    super.initState();

    widget.viewModel.onLoad();

    widget.viewModel.successCreate.listen((event) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: const Text("Success!"),
                content:
                    Text("Congratulations! You've done with tour creation"));
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: 1200,
        height: 1000,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _bookingInfoCard(),
                  const SizedBox(width: 32),
                  _aviaticketInfoCard()
                ],
              ),
              const SizedBox(height: 32),
              _otherTourOptions()
            ],
          ),
        ),
      ),
    );
  }

  Widget _bookingInfoCard() => StreamBuilder<bool>(
      stream: widget.viewModel.bookingReady,
      builder: (context, snapshot) {
        return Container(
          width: 400,
          height: 300,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: snapshot.hasData && snapshot.data!
                      ? Colors.greenAccent
                      : Colors.black),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: InputDatePickerFormField(
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1950),
                          lastDate: DateTime(2023),
                          fieldLabelText: "From",
                          fieldHintText: "Tour start date",
                          onDateSubmitted: (date) {
                            setState(() {
                              widget.viewModel.bookingStart.add(date);
                            });
                          }),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InputDatePickerFormField(
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1950),
                          lastDate: DateTime(2023),
                          fieldLabelText: "To",
                          fieldHintText: "Tour end date",
                          onDateSubmitted: (date) {
                            setState(() {
                              widget.viewModel.bookingEnd.add(date);
                            });
                          }),
                    )
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (text) {
                      double? value = double.tryParse(text);
                      if (value != null) {
                        widget.viewModel.bookingPrice.add(value);
                      }
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Price",
                        hintText: "Enter booking's price"),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                    onPressed: snapshot.hasData && snapshot.data!
                        ? () {
                            widget.viewModel.onCreateHotelBooking();
                          }
                        : null,
                    child: const Text("Book hotel")),
                const SizedBox(width: 16),
              ],
            ),
          ),
        );
      });

  Widget _aviaticketInfoCard() => StreamBuilder<bool>(
      stream: widget.viewModel.ticketReady,
      builder: (context, snapshot) {
        return Container(
          width: 400,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.white,
              border: Border.all(
                  color: snapshot.hasData && snapshot.data!
                      ? Colors.greenAccent
                      : Colors.black),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    DropdownButton(
                        value: ticketClass,
                        items: [
                          const DropdownMenuItem(
                              child: Text("Business"), value: "business"),
                          const DropdownMenuItem(
                              child: Text("Econom"), value: "econom")
                        ],
                        onChanged: (String? value) {
                          setState(() {
                            ticketClass = value;
                            widget.viewModel.ticketClass.add(value!);
                          });
                        }),
                    const SizedBox(width: 16),
                    const Text("One way ticket"),
                    Switch(
                        value: isOneWay,
                        onChanged: (value) {
                          setState(() {
                            isOneWay = value;
                            widget.viewModel.ticketOneWay.add(value);
                          });

                        })
                  ],
                ),
                Expanded(
                  child: TextField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (text) {
                      double? value = double.tryParse(text);
                      if (value != null) {
                        widget.viewModel.ticketPrice.add(value);
                      }
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Price",
                        hintText: "Enter aviaticket's price"),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                    onPressed: snapshot.hasData && snapshot.data!
                        ? () {
                            widget.viewModel.onCreateTicket();
                          }
                        : null,
                    child: const Text("Buy aviaticket")),
                const SizedBox(width: 16),
              ],
            ),
          ),
        );
      });

  Widget _otherTourOptions() => StreamBuilder<bool>(
      stream: widget.viewModel.canCreateTour,
      builder: (context, snapshot) {
        return Container(
          width: 800,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
              border: Border.all(
                  color: snapshot.hasData && snapshot.data!
                      ? Colors.greenAccent
                      : Colors.black),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    StreamBuilder(
                        stream: widget.viewModel.tourOperators,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<TourOperator>> snapshot) {
                          if (snapshot.hasData) {
                            final items = snapshot.data!
                                .map((e) => DropdownMenuItem<TourOperator>(
                                    value: e, child: Text(e.name)))
                                .toList();
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text("Tour Operator:"),
                                const SizedBox(width: 16),
                                DropdownButton(
                                    value: tourOperator,
                                    items: items,
                                    onChanged: (TourOperator? value) {
                                      setState(() {
                                        tourOperator = value;
                                        widget.viewModel.tourOperator.add(value!);
                                      });
                                    })
                              ],
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        }),
                    const SizedBox(width: 16),
                    StreamBuilder(
                        stream: widget.viewModel.countries,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Country>> snapshot) {
                          if (snapshot.hasData) {
                            final items = snapshot.data!
                                .map((e) => DropdownMenuItem<Country>(
                                    value: e, child: Text(e.name)))
                                .toList();
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Country:"),
                                const SizedBox(width: 16),
                                DropdownButton(
                                    value: country,
                                    items: items,
                                    onChanged: (Country? value) {
                                      setState(() {
                                        country = value;
                                        widget.viewModel.country.add(value!);
                                      });
                                    })
                              ],
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        })
                  ],
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                    onPressed: snapshot.hasData && snapshot.data!
                        ? () {
                            widget.viewModel.onCreateTour();
                          }
                        : null,
                    child: const Text("Create tour")),
                const SizedBox(width: 16),
              ],
            ),
          ),
        );
      });
}

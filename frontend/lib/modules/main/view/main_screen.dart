import 'package:flutter/material.dart';
import 'package:touragency_frontend/modules/main/view_model/main_view_model.dart';

class MainView extends StatefulWidget {
  final MainViewModel viewModel;

  MainView({required this.viewModel});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(child: Text("Menu")),
            ListTile(
              title: const Text("Managers"),
              onTap: () {
                setState(() {
                  if (currentIndex != 1) {
                    currentIndex = 1;
                    widget.viewModel.didTapManagers();
                    Navigator.pop(context);
                  }
                });
              },
            ),
            ListTile(
              title: const Text("Tour operators"),
              onTap: () {
                setState(() {
                  if (currentIndex != 2) {
                    currentIndex = 2;
                    widget.viewModel.didTapTourOperators();
                    Navigator.pop(context);
                  }
                });
              },
            ),
            ListTile(
              title: const Text("Tours"),
              onTap: () {
                setState(() {
                  if (currentIndex != 3) {
                    currentIndex = 3;
                    widget.viewModel.didTapTours();
                    Navigator.pop(context);
                  }
                });
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: widget.viewModel.content,
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          return snapshot.hasData ? snapshot.data! : Container();
        },
      ),
    );
  }

  String _getTitle() {
    switch (currentIndex) {
      case 1:
        return "Managers";
      case 2:
        return "Tour Operators";
      case 3:
        return "Tours";
      default:
        return "Touragency";
    }
  }
}

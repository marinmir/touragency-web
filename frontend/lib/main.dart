import 'package:flutter/material.dart';
import 'package:touragency_frontend/app/app_navigator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Touragency',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: AppNavigator.generate,
    );
  }
}

import 'package:flutter/material.dart';

abstract class MainViewModel {
  void didTapManagers();
  void didTapTours();
  void didTapTourOperators();

  Stream<Widget> get content;
}
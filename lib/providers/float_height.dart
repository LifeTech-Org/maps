import 'package:flutter/material.dart';

class FloatingHeight extends ChangeNotifier {
  double _height = 85;

  double get height => _height;
  void setHeight(double height) {
    _height = height;
    notifyListeners();
  }
}

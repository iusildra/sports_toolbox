import 'package:flutter/material.dart';

class ThemeModel extends ChangeNotifier {
  final _colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.purple,
  ];

  int _currentIndex = 0;

  Color get color => _colors[_currentIndex];

  void switchColor() {
    _currentIndex = (_currentIndex + 1) % _colors.length;
    notifyListeners();
  }
}
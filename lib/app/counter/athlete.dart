import 'package:flutter/material.dart';

class Athlete {
  Athlete({
    required this.key,
    required this.name,
    required this.setup,
    required this.score,
  });

  final int key;
  final CounterSettings setup;
  final String name;

  int score;

  void increment({int inc = 1}) => score += inc;

  void decrement({int dec = 1}) => score -= dec;
}

class CounterSettings {
  CounterSettings({required this.color});

  final Color color;
}

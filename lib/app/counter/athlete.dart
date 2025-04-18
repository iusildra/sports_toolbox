import 'package:flutter/material.dart';
import 'package:sports_toolbox/app/counter/penalty.dart';

class Athlete {
  Athlete({required this.key, required this.name, required this.setup});

  final int key;
  final CounterSettings setup;
  final String name;

  int _score = 0;
  List<PenaltyType> penalties = List.empty(growable: true);

  void increment({int inc = 1}) => _score += inc;

  void decrement({int dec = 1}) => _score -= dec;

  void addPenalty(PenaltyType penalty) => penalties.add(penalty);

  void reset() {
    _score = 0;
    penalties.clear();
  }

  get score => _score;

  get scoreWithPenalties => penalties.fold(
    _score,
    (initialScore, penalty) => initialScore - penalty.value,
  );
}

class CounterSettings {
  CounterSettings({required this.color});

  final Color color;
}

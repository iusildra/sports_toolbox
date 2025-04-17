import 'package:flutter/material.dart';
import 'package:sports_toolbox/app/counter/penalty.dart';

class Athlete {
  Athlete({required this.key, required this.name, required this.setup});

  final int key;
  final CounterSettings setup;
  final String name;

  int score = 0;
  List<PenaltyType> penalties = List.empty(growable: true);

  void increment({int inc = 1}) => score += inc;

  void decrement({int dec = 1}) => score -= dec;

  void addPenalty(PenaltyType penalty) => penalties.add(penalty);

  get scoreWithoutPenalties =>
      penalties.fold(score, (initialScore, penalty) => initialScore - penalty.value);
}

class CounterSettings {
  CounterSettings({required this.color});

  final Color color;
}

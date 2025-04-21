import 'package:flutter/material.dart';
import 'package:sports_toolbox/data/models/athlete.dart';
import 'package:sports_toolbox/data/models/penalty.dart';

class CounterModel extends ChangeNotifier {
  final Map<int, Athlete> athletes = {
    0: Athlete(key: 0, name: 'Athlete 1', color: Colors.blue.shade200),
    1: Athlete(key: 1, name: 'Athlete 2', color: Colors.red.shade200),
  };

  void updateAthleteSetup(Athlete athlete) {
    athletes[athlete.key] = athlete;
    notifyListeners();
  }

  void incrementScore(int index) {
    athletes[index]?.increment();
    notifyListeners();
  }

  void addPenalty(Athlete athlete, PenaltyType penalty) {
    athletes[athlete.key]?.addPenalty(penalty);
    notifyListeners();
  }

  void resetScores() {
    athletes.values.forEach((a) => a.reset());
    notifyListeners();
  }
}

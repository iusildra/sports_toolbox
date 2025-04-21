import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sports_toolbox/data/models/athlete.dart';
import 'package:sports_toolbox/data/models/penalty.dart';
import 'package:sports_toolbox/domain/models/counter_model.dart';
import 'package:sports_toolbox/models/settings_model.dart';

class CounterViewModel extends ChangeNotifier {
  final CounterModel _counterModel;

  CounterViewModel(this._counterModel) {
    _counterModel.addListener(notifyListeners);
  }

  Map<int, Athlete> get athletes => _counterModel.athletes;
  int get athleteCount => _counterModel.athletes.length;

  void updateAthleteSetup(Athlete athlete) =>
      _counterModel.updateAthleteSetup(athlete);
  void incrementScore(BuildContext context, int index) {
    _counterModel.incrementScore(index);
    Provider.of<SettingsModel>(context, listen: false).performVibrate();
  }

  void addPenalty(Athlete athlete, PenaltyType penalty) =>
      _counterModel.addPenalty(athlete, penalty);
  void resetScores() => _counterModel.resetScores();

  @override
  void dispose() {
    _counterModel.removeListener(notifyListeners);
    super.dispose();
  }
}

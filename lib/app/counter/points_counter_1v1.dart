import 'package:flutter/material.dart';
import 'package:sports_toolbox/app/counter/athlete.dart';
import 'package:sports_toolbox/app/counter/counter_setup.dart';

class PointsCounter1v1Page extends StatefulWidget {
  const PointsCounter1v1Page({super.key});

  @override
  State<StatefulWidget> createState() => _PointsCounterState();
}

class _PointsCounterState extends State<PointsCounter1v1Page> {
  static const String appName = 'Points Counter';

  static List<Color> availableColors = [
    Colors.blue.shade200,
    Colors.red.shade200,
    Colors.green.shade200,
    Colors.yellow.shade200,
    Colors.purple.shade200,
  ];

  Map<int, Athlete> athleteScores = {
    0: Athlete(
      key: 0,
      name: 'Athlete 1',
      setup: CounterSettings(color: Colors.blue.shade200),
      score: 0,
    ),
    1: Athlete(
      key: 1,
      name: 'Athlete 2',
      setup: CounterSettings(color: Colors.red.shade200),
      score: 0,
    ),
  };

  Iterable<Color> _availableColorForAthlete(Athlete athlete) =>
      availableColors.where(
        (color) => athleteScores.values.every(
          (a) => a == athlete || a.setup.color != color,
        ),
      );

  void updateAthletes(Athlete athlete) =>
      setState(() => athleteScores[athlete.key] = athlete);

  void showAthleteSetupDialog(Athlete athlete) async {
    final newAthletes = await showDialog<Athlete>(
      context: context,
      builder: (context) => CounterSetup(
        athlete: athlete,
        availableColors: _availableColorForAthlete(athlete),
      ),
    );
    if (newAthletes != null) {
      updateAthletes(newAthletes);
    }
  }

  void incrementScore(int index) =>
      setState(() => athleteScores[index]?.increment());

  void resetScore() => setState(() {
    for (var a in athleteScores.values) {
      a.score = 0;
    }
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appName),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: resetScore),
        ],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
            athleteScores.values
                .map(
                  (athlete) => Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                athlete.name,
                                style: const TextStyle(fontSize: 16),
                              ),
                              IconButton(
                                icon: const Icon(Icons.settings),
                                onPressed: () => showAthleteSetupDialog(athlete),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => incrementScore(athlete.key),
                            child: Container(
                              color: athlete.setup.color,
                              child: Center(
                                child: Text(
                                  athlete.score.toString(),
                                  style: TextTheme.of(context).displayLarge,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sports_toolbox/app/counter/athlete.dart';
import 'package:sports_toolbox/app/counter/counter_setup.dart';

class PointsCounterPage extends StatefulWidget {
  const PointsCounterPage({super.key});

  @override
  State<StatefulWidget> createState() => _PointsCounterState();
}

class _PointsCounterState extends State<PointsCounterPage> {
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
      setup: CounterSettings(color: availableColors[0]),
      score: 0,
    ),
    1: Athlete(
      key: 1,
      name: 'Athlete 2',
      setup: CounterSettings(color: availableColors[1]),
      score: 0,
    ),
  };

  Iterable<Color> _availableColorForAthlete(Athlete athlete) =>
      availableColors.where(
        (color) => athleteScores.values.every(
          (a) => a == athlete || a.setup.color != color,
        ),
      );

  void updateAthletes(Athlete athlete) {
    setState(() => athleteScores[athlete.key] = athlete);
    resetScore();
  }

  void showAthleteSetupDialog(Athlete athlete) async {
    final newAthletes = await showDialog<Athlete>(
      context: context,
      builder:
          (context) => CounterSetup(
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text(appName),
            stretch: true,
            pinned: false,
            floating: false,
          ),
          Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height
            ),
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: athleteScores.values.map(athleteScoreColumn).toList(),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: resetScore,
                    child: const Text('Reset Scores'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Expanded athleteScoreColumn(Athlete athlete) => Expanded(
    child: Container(
      color: athlete.setup.color,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                athlete.name,
                style: TextTheme.of(
                  context,
                ).titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => showAthleteSetupDialog(athlete),
              ),
            ],
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => incrementScore(athlete.key),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    style: BorderStyle.solid,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
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
  );
}

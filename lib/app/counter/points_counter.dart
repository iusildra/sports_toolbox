import 'package:flutter/material.dart';
import 'package:sports_toolbox/app/counter/athlete.dart';
import 'package:sports_toolbox/app/counter/counter_setup.dart';
import 'package:sports_toolbox/app/counter/penalty.dart';
import 'package:sports_toolbox/app/counter/penalty_picker.dart';
import 'package:sports_toolbox/app/decorations.dart';
import 'package:sports_toolbox/components/dialogs.dart';

class PointsCounterPage extends StatefulWidget {
  const PointsCounterPage({super.key});

  static Key columnKey(int index) => Key("athlete-$index-column");
  static Key scoreBoxKey(int index) => Key("athlete-$index-score-box");
  static Key scoreDisplayKey(int index) => Key("athlete-$index-score-display");

  @override
  State<StatefulWidget> createState() => _PointsCounterState();
}

class _PointsCounterState extends State<PointsCounterPage> {
  static const String appName = 'Points Counter';

  static final List<Color> availableColors = [
    Colors.blue.shade200,
    Colors.red.shade200,
    Colors.green.shade200,
    Colors.yellow.shade200,
    Colors.purple.shade200,
  ];

  final Map<int, Athlete> athleteScores = {
    0: Athlete(
      key: 0,
      name: 'Athlete 1',
      setup: CounterSettings(color: availableColors[0]),
    ),
    1: Athlete(
      key: 1,
      name: 'Athlete 2',
      setup: CounterSettings(color: availableColors[1]),
    ),
  };

  Iterable<Color> _availableColorForAthlete(Athlete athlete) =>
      availableColors.where(
        (color) => athleteScores.values.every(
          (a) => a == athlete || a.setup.color != color,
        ),
      );

  void updateAthleteSetup(Athlete athlete) {
    setState(() => athleteScores[athlete.key] = athlete);
    resetScores();
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
      updateAthleteSetup(newAthletes);
    }
  }

  void showPenaltyPickerDialog(Athlete athlete) async {
    final penalty = await showDialog<PenaltyType>(
      context: context,
      builder: (context) => PenaltyPickerDialog(athlete: athlete),
    );
    if (penalty != null) {
      setState(() => athlete.addPenalty(penalty));
    }
  }

  void incrementScore(int index) =>
      setState(() => athleteScores[index]?.increment());

  void resetScores() =>
      setState(() => athleteScores.values.forEach((a) => a.reset()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(appName)),
      body: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:
                athleteScores
                    .map(
                      (i, v) => MapEntry(i, athleteScoreColumn(v, i % 2 != 0)),
                    )
                    .values
                    .toList(),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton.tonalIcon(
                  key: const Key("reset-button"),
                  onPressed:
                      () => showDialog(
                        context: context,
                        builder:
                            (context) => CustomDialogs.confirmAction(
                              context,
                              const Key("confirm-reset"),
                              resetScores,
                              title: 'Please confirm reset',
                              content: 'Are you sure you want to reset?',
                              action: 'Reset',
                            ),
                      ),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Expanded athleteScoreColumn(Athlete athlete, bool reverse) {
    List<Widget> header = [
      IconButton(
        icon: const Icon(Icons.remove_circle_outline),
        onPressed: () => showPenaltyPickerDialog(athlete),
        tooltip: "Add penalty",
      ),
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
    ];
    return Expanded(
      key: PointsCounterPage.columnKey(athlete.key),
      child: Container(
        color: athlete.setup.color,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: reverse ? header.reversed.toList() : header,
            ),
            Expanded(
              child: GestureDetector(
                key: PointsCounterPage.scoreBoxKey(athlete.key),
                onTap: () => incrementScore(athlete.key),
                child: Container(
                  decoration: Borders.surrounding(context),
                  child: scoreDisplay(context, athlete),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget scoreDisplay(BuildContext context, Athlete athlete) => Column(
    key: PointsCounterPage.scoreDisplayKey(athlete.key),
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            athlete.scoreWithPenalties.toString(),
            style: TextTheme.of(context).displayLarge,
          ),
          athlete.penalties.isNotEmpty
              ? Text(
                "(${athlete.score.toString()})",
                style: TextTheme.of(context).titleLarge,
              )
              : const SizedBox(),
        ],
      ),
      Wrap(
        alignment: WrapAlignment.start,
        spacing: 8,
        runSpacing: 8,
        children: athlete.penalties.map((p) => p.asIcons).toList(),
      ),
    ],
  );
}

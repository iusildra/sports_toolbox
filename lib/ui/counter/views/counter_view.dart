import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sports_toolbox/ui/counter/counter_setup.dart';
import 'package:sports_toolbox/ui/counter/views/penalty_picker.dart';
import 'package:sports_toolbox/components/decorations.dart';
import 'package:sports_toolbox/components/dialogs.dart';
import 'package:sports_toolbox/data/models/athlete.dart';
import 'package:sports_toolbox/domain/models/counter_model.dart';
import 'package:sports_toolbox/ui/counter/view_models/counter_view_model.dart';

class CounterPage extends StatelessWidget {
  static const String appName = 'Points Counter';
  const CounterPage({super.key});

  static Key columnKey(int index) => Key("athlete-$index-column");
  static Key scoreBoxKey(int index) => Key("athlete-$index-score-box");
  static Key scoreDisplayKey(int index) => Key("athlete-$index-score-display");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(appName)),
      body: CounterView(viewModel: CounterViewModel(CounterModel())),
    );
  }
}

class CounterView extends StatelessWidget {
  const CounterView({super.key, required this.viewModel});

  final CounterViewModel viewModel;

  @override
  Widget build(BuildContext _) => ListenableBuilder(
    listenable: viewModel,
    builder:
        (context, _) => Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ...viewModel.athletes.values.map(
                  (v) => athleteScoreColumn(context, v, v.key % 2 != 0),
                ),
              ],
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
                                viewModel.resetScores,
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

  Expanded athleteScoreColumn(
    BuildContext context,
    Athlete athlete,
    bool reverse,
  ) {
    List<Widget> header = [
      IconButton(
        icon: const Icon(Icons.remove_circle_outline),
        onPressed:
            () => PenaltyPickerDialog.showPenaltyPickerDialog(
              context,
              athlete,
              viewModel.addPenalty,
            ),
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
        onPressed:
            () => CounterSetup.showAthleteSetupDialog(
              context,
              athlete,
              viewModel.athletes.values,
              viewModel.updateAthleteSetup,
            ),
      ),
    ];
    return Expanded(
      key: CounterPage.columnKey(athlete.key),
      child: Container(
        color: athlete.color,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: reverse ? header.reversed.toList() : header,
            ),
            Expanded(
              child: GestureDetector(
                key: CounterPage.scoreBoxKey(athlete.key),
                onTap: () => viewModel.incrementScore(context, athlete.key),
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
    key: CounterPage.scoreDisplayKey(athlete.key),
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

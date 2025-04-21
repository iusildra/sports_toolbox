import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sports_toolbox/ui/timer/views/duration_picker.dart';
import 'package:sports_toolbox/domain/models/timer_model.dart';
import 'package:sports_toolbox/ui/timer/view_models/timer_view_model.dart';
import 'package:sports_toolbox/utils/date_time_utils.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TimerViewModel(TimerModel()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Timer')),
        body: const TimerView(),
      ),
    );
  }
}

class TimerView extends StatelessWidget {
  const TimerView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TimerViewModel>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Wrap(
              key: Key("timers"),
              spacing: 32,
              alignment: WrapAlignment.center,
              children: List.generate(viewModel.durations.length, (index) {
                final duration = viewModel.durations[index];
                final displayedDuration = index == viewModel.currentDurationIndex
                    ? viewModel.remainingTime
                    : duration;
                return GestureDetector(
                  onTap: () => viewModel.changeTimer(index),
                  child: Text(
                    DateTimeUtils.formattedStandardTime(displayedDuration),
                    style: TextStyle(
                      color: index == viewModel.currentDurationIndex
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: viewModel.startPauseTimer,
                child: Text(viewModel.isRunning ? 'Pause' : 'Start'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: viewModel.resetTimer,
                child: const Text('Reset'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final newDuration = await showDialog<Duration>(
                    context: context,
                    builder: (context) => DurationPickerDialog(
                      initialDuration: viewModel.remainingTime,
                    ),
                  );
                  if (newDuration != null) viewModel.setTimer(newDuration);
                },
                child: const Text('Set timer'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () async {
                  final newDuration = await showDialog<Duration>(
                    context: context,
                    builder: (context) => DurationPickerDialog(
                      initialDuration: TimerModel.defaultDuration,
                    ),
                  );
                  if (newDuration != null) viewModel.addDuration(newDuration);
                },
                child: const Text('Add timer'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: viewModel.durations.length > 1
                    ? viewModel.removeDuration
                    : null,
                child: const Text('Remove timer'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
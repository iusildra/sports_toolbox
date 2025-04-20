import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sports_toolbox/app/time/duration_picker.dart';
import 'package:sports_toolbox/utils/date_time_utils.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  static const defaultDuration = Duration(minutes: 1);
  static const _oneSecond = Duration(seconds: 1);

  Timer? _timer;

  int _currentDuration = 0;
  Duration _remainingTime = defaultDuration;
  List<Duration> durations = List.filled(1, defaultDuration, growable: true);

  bool _isRunning() => _timer?.isActive ?? false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Timer oneSecond() => Timer.periodic(const Duration(seconds: 1), (timer) {
    setState(() {
      if (_remainingTime.inSeconds > 0) {
        _remainingTime -= _oneSecond;
      } else {
        _currentDuration = (_currentDuration + 1) % durations.length;
        _remainingTime = durations[_currentDuration] - Duration(seconds: 1);
      }
    });
  });

  void _startPauseTimer() =>
      setState(() => _isRunning() ? _timer?.cancel() : _timer = oneSecond());

  void _resetTimer() {
    _timer?.cancel();
    _remainingTime = durations[_currentDuration];
  }

  void _setDuration(Duration newDuration) => setState(() {
    durations[_currentDuration] = newDuration;
    _remainingTime = newDuration;
  });

  void _addDuration(Duration duration) =>
      setState(() => durations.insert(_currentDuration + 1, duration));

  void _removeDuration() {
    setState(() {
      durations.removeAt(_currentDuration);
      _currentDuration = _currentDuration % durations.length;
      _remainingTime = durations[_currentDuration];
    });
  }

  Color _colorForDuration(BuildContext context, int index) =>
      index == _currentDuration
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.inversePrimary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Timer')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            Expanded(
              child: Wrap(
                key: Key("timers"),
                direction: Axis.horizontal,
                spacing: 32,
                alignment: WrapAlignment.center,
                children: List.generate(durations.length, (index) {
                  final duration = durations[index];
                  final displayedDuration =
                      index == _currentDuration ? _remainingTime : duration;
                  return GestureDetector(
                    onTap:
                        () => setState(() {
                          _currentDuration = index;
                          _remainingTime = duration;
                        }),
                    child: Text(
                      DateTimeUtils.formattedStandardTime(displayedDuration),
                      style: TextStyle(
                        color: _colorForDuration(context, index),
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }),
              ),
            ),
            ...timerActions(),
          ],
        ),
      ),
    );
  }

  List<Row> timerActions() => [
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 16,
      children: [
        ElevatedButton(
          onPressed: _startPauseTimer,
          child: Text(_isRunning() ? 'Pause' : 'Start'),
        ),
        ElevatedButton(
          onPressed: () => setState(() => _resetTimer()),
          child: const Text('Reset'),
        ),
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 16,
      children: [
        ElevatedButton(
          onPressed: () async {
            final newDuration = await showDialog<Duration>(
              context: context,
              builder:
                  (context) => DurationPickerDialog(
                    initialDuration: durations[_currentDuration],
                  ),
            );
            if (newDuration != null) _setDuration(newDuration);
          },
          child: const Text('Set timer'),
        ),
        ElevatedButton(
          onPressed: () async {
            final newDuration = await showDialog<Duration>(
              context: context,
              builder:
                  (context) =>
                      DurationPickerDialog(initialDuration: defaultDuration),
            );
            if (newDuration != null) _addDuration(newDuration);
          },
          child: const Text('Add timer'),
        ),
        ElevatedButton(
          onPressed: durations.length > 1 ? () => _removeDuration() : null,
          child: const Text('Remove timer'),
        ),
      ],
    ),
  ];
}

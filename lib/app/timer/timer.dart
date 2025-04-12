import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sports_toolbox/app/timer/duration_picker.dart';
import 'package:sports_toolbox/utils/date_time_utils.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  static const defaultDuration = Duration(minutes: 1);
  static const _oneSecond = Duration(seconds: 1);
  Duration _wantedDuration = defaultDuration;
  Duration _remainingTime = defaultDuration;
  Timer? _timer;

  bool _isRunning() => _timer?.isActive ?? false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startPauseTimer() => setState(
    () =>
        _isRunning()
            ? _timer?.cancel()
            : _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
              setState(
                () =>
                    _remainingTime.inSeconds > 0
                        ? _remainingTime -= _oneSecond
                        : _resetTimer(),
              );
            }),
  );

  void _resetTimer() => setState(() {
    _timer?.cancel();
    _remainingTime = _wantedDuration;
  });

  void _setDuration(Duration newDuration) => setState(() {
    _wantedDuration = newDuration;
    _remainingTime = newDuration;
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Timer')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateTimeUtils.formattedStandardTime(_remainingTime),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _startPauseTimer,
                  child: Text(_isRunning() ? 'Pause' : 'Start'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _resetTimer,
                  child: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final newDuration = await showDialog<Duration>(
                  context: context,
                  builder:
                      (context) => DurationPickerDialog(
                        initialDuration: _wantedDuration,
                      ),
                );
                if (newDuration != null) _setDuration(newDuration);
              },
              child: const Text('Set Timer'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sports_toolbox/utils/date_time_utils.dart';

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({super.key});

  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  late Stopwatch _stopwatch;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _timer = Timer.periodic(const Duration(milliseconds: 10), _triggerTimeUpdate);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _triggerTimeUpdate(Timer timer) => mounted ? setState(() {}) : {};

  void _startStop() => setState(
    () => _stopwatch.isRunning ? _stopwatch.stop() : _stopwatch.start(),
  );

  void _reset() => setState(() => _stopwatch.reset());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stopwatch')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateTimeUtils.formattedTimeWithCentiseconds(_stopwatch.elapsed),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _startStop,
                  child: Text(_stopwatch.isRunning ? 'Stop' : 'Start'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: _reset, child: const Text('Reset')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

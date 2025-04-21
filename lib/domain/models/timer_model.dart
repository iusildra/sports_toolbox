import 'dart:async';
import 'package:flutter/foundation.dart';

class TimerModel extends ChangeNotifier {
  static const defaultDuration = Duration(minutes: 1);
  static const _oneSecond = Duration(seconds: 1);

  final List<Duration> _durations = [defaultDuration];
  int _currentDurationIndex = 0;
  Duration _remainingTime = defaultDuration;
  Timer? _timer;

  List<Duration> get durations => List.unmodifiable(_durations);

  int get currentDurationIndex => _currentDurationIndex;
  Duration get remainingTime => _remainingTime;
  bool get isRunning => _timer?.isActive ?? false;

  void startPauseTimer({AsyncCallback? onComplete}) {
    if (isRunning) {
      _timer?.cancel();
      notifyListeners();
      return;
    }

    _timer = Timer.periodic(_oneSecond, (timer) async {
      if (_remainingTime.inSeconds > 0) {
        _remainingTime -= _oneSecond;
      } else {
        await onComplete?.call();
        _currentDurationIndex =
            (_currentDurationIndex + 1) % _durations.length;
        _remainingTime =
            _durations[_currentDurationIndex] - Duration(seconds: 1);
      }
      notifyListeners();
    });
    notifyListeners();
  }

  void resetTimer() {
    _timer?.cancel();
    _remainingTime = _durations[_currentDurationIndex];
    notifyListeners();
  }

  void changeTimer(int index) {
    _currentDurationIndex = index;
    _remainingTime = _durations[_currentDurationIndex];
    notifyListeners();
  }

  void addDuration(Duration duration) {
    _durations.insert(_currentDurationIndex + 1, duration);
    notifyListeners();
  }

  void setTimer(Duration duration) {
    _durations[_currentDurationIndex] = duration;
    _remainingTime = duration;
    notifyListeners();
  }

  void removeDuration() {
    if (_durations.length > 1) {
      _durations.removeAt(_currentDurationIndex);
      _currentDurationIndex %= _durations.length;
      _remainingTime = _durations[_currentDurationIndex];
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

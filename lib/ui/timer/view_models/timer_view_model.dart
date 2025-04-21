import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sports_toolbox/domain/models/timer_model.dart';

class TimerViewModel extends ChangeNotifier {
  final TimerModel _timerModel;
  final AudioPlayer _audioPlayer;

  TimerViewModel(this._timerModel, this._audioPlayer) {
    _timerModel.addListener(notifyListeners);
  }

  List<Duration> get durations => _timerModel.durations;
  int get currentDurationIndex => _timerModel.currentDurationIndex;
  Duration get remainingTime => _timerModel.remainingTime;
  bool get isRunning => _timerModel.isRunning;

  void startPauseTimer() => _timerModel.startPauseTimer(
    onComplete:
        () => _audioPlayer.play(
          AssetSource('rooster_alarm.mp3'),
          volume: 1.0,
          mode: PlayerMode.lowLatency,
        ),
  );
  void resetTimer() => _timerModel.resetTimer();
  void changeTimer(int index) => _timerModel.changeTimer(index);
  void setTimer(Duration duration) => _timerModel.setTimer(duration);
  void addDuration(Duration duration) => _timerModel.addDuration(duration);
  void removeDuration() => _timerModel.removeDuration();

  @override
  void dispose() {
    _timerModel.removeListener(notifyListeners);
    super.dispose();
  }
}

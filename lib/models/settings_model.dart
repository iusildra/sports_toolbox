import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class SettingsModel extends ChangeNotifier {
  Color _color;
  VibrationKind _vibrationModel;

  SettingsModel({Color? color, VibrationKind? vibration})
    : _color = color ?? Colors.blue,
      _vibrationModel = vibration ?? NoVibration();

  Color get color => _color;
  VibrationKind get vibration => _vibrationModel;

  void update({Color? color, VibrationKind? vibrationModel}) {
    if (color != null) _color = color;
    if (vibrationModel != null) _vibrationModel = vibrationModel;
    notifyListeners();
  }
}

sealed class VibrationKind {
  const VibrationKind();

  Future<bool> get hasVibrator => Vibration.hasVibrator();

  Future<void> performVibrate() => switch (this) {
    NoVibration() => Future.value(),
    VibrationWithSettings(duration: final d, intensity: final i) =>
      Vibration.vibrate(duration: d, amplitude: i),
  };
}

class NoVibration extends VibrationKind {
  const NoVibration();
}

class VibrationWithSettings extends VibrationKind {
  final int duration;
  final int intensity;

  const VibrationWithSettings({this.duration = 100, this.intensity = 50});
}

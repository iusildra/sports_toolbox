import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class SettingsModel extends ChangeNotifier {
  Color _color = Colors.blue;
  VibrationModel? _vibrationModel;

  SettingsModel({Color? color, VibrationModel? vibrationModel})
    : _color = color ?? Colors.blue,
      _vibrationModel = vibrationModel;

  Color get color => _color;
  VibrationModel? get vibrationModel => _vibrationModel;

  void performVibrate() {
    vibrationModel?.doVibrate();
  }

  void update({Color? color, VibrationModel? vibrationModel}) {
    if (color != null) {
      _color = color;
    }
    if (vibrationModel != null) {
      _vibrationModel = vibrationModel;
    }
    notifyListeners();
  }
}

class VibrationModel {
  final int _duration;
  final int _intensity;

  VibrationModel({int duration = 100, int intensity = 50})
    : _duration = duration,
      _intensity = intensity;

  void doVibrate() {
    Vibration.hasVibrator();
    Vibration.vibrate(duration: _duration, amplitude: _intensity);
  }
}

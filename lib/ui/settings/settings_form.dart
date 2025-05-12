import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sports_toolbox/models/settings_model.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({super.key});

  static void openSettingsForm(
    BuildContext context, {
    bool allowVibration = false,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) => const SettingsForm(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, -1.0); // Slide from top
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  bool _deviceAllowVibration = false;
  late bool _useVibration;
  late Color _selectedColor;
  late int _vibrationDuration;
  late int _vibrationIntensity;

  static const List<Color> _colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.purple,
  ];

  @override
  void initState() {
    super.initState();
    final currentSettings = context.read<SettingsModel>();
    _selectedColor = currentSettings.color;
    switch (currentSettings.vibration) {
      case VibrationWithSettings(
        duration: final duration,
        intensity: final intensity,
      ):
        _vibrationDuration = duration;
        _vibrationIntensity = intensity;
        _useVibration = true;
        break;
      case NoVibration():
        _vibrationDuration = 50;
        _vibrationIntensity = 10;
        _useVibration = false;
        break;
    }

    currentSettings.vibration.hasVibrator.then(
      (onValue) => setState(() => _deviceAllowVibration = onValue),
    );
  }

  void _updateColor(Color color) {
    setState(() => _selectedColor = color);
    Provider.of<SettingsModel>(context, listen: false).update(color: color);
  }

  void _toggleVibration(bool? value) {
    setState(() => _useVibration = value ?? false);
    Provider.of<SettingsModel>(context, listen: false).update(
      vibrationModel: _useVibration ? VibrationWithSettings() : NoVibration(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.read<SettingsModel>();
    final settingLabelTheme = TextTheme.of(context).labelLarge;
    final settingGroupTheme = TextTheme.of(
      context,
    ).titleLarge?.copyWith(fontWeight: FontWeight.bold);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Theme Color:', style: settingGroupTheme),
                    Wrap(
                      spacing: 16,
                      direction: Axis.horizontal,
                      children: List.generate(_colors.length, (index) {
                        final color = _colors[index];
                        return GestureDetector(
                          onTap: () => _updateColor(color),
                          child: CircleAvatar(
                            backgroundColor: color,
                            radius: 24,
                            child:
                                _selectedColor == color
                                    ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    )
                                    : null,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
                _deviceAllowVibration
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Vibration Settings:',
                              style: settingGroupTheme,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Enable vibration", style: settingLabelTheme),
                            Switch.adaptive(
                              value: _useVibration,
                              onChanged: _toggleVibration,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Duration (ms): $_vibrationDuration',
                              style: settingLabelTheme,
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 200),
                              child: Slider.adaptive(
                                value: _vibrationDuration.toDouble(),
                                min: 50,
                                max: 500,
                                divisions: 9,
                                label: '$_vibrationDuration ms',
                                onChanged:
                                    _useVibration
                                        ? (value) => setState(
                                          () =>
                                              _vibrationDuration =
                                                  value.toInt(),
                                        )
                                        : null,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Intensity: $_vibrationIntensity',
                              style: settingLabelTheme,
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 200),
                              child: Slider.adaptive(
                                value: _vibrationIntensity.toDouble(),
                                min: 10,
                                max: 100,
                                divisions: 9,
                                label: '$_vibrationIntensity',
                                onChanged:
                                    _useVibration
                                        ? (value) => setState(
                                          () =>
                                              _vibrationIntensity =
                                                  value.toInt(),
                                        )
                                        : null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                    : const SizedBox(height: 0),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                settings.update(
                  color: _selectedColor,
                  vibrationModel:
                      _useVibration
                          ? VibrationWithSettings(
                            duration: _vibrationDuration,
                            intensity: _vibrationIntensity,
                          )
                          : NoVibration(),
                );
                Navigator.pop(context);
              },
              child: const Text('Save Settings'),
            ),
          ],
        ),
      ),
    );
  }
}

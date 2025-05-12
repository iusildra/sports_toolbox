import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sports_toolbox/models/settings_model.dart';
import 'package:sports_toolbox/ui/settings/settings_form.dart';

import 'counter/points_counter_test.mocks.dart';

@GenerateMocks([NoVibration, VibrationWithSettings])
void main() {
  final colorButtons = find.byType(CircleAvatar);
  final checkIcon = find.byIcon(Icons.check);

  testWidgets(
    'Clicking on a color changes the theme and add a check mark in it',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => SettingsModel(),
          child: const MaterialApp(home: SettingsForm()),
        ),
      );

      final initialColor =
          Provider.of<SettingsModel>(
            tester.element(find.byType(SettingsForm)),
            listen: false,
          ).color;

      expect(colorButtons, findsNWidgets(5));
      expect(checkIcon, findsOne);
      expect(
        find.descendant(of: colorButtons.at(0), matching: checkIcon),
        findsOne,
      );

      await tester.tap(colorButtons.at(1));
      await tester.pumpAndSettle();

      final updatedSettings = Provider.of<SettingsModel>(
        tester.element(find.byType(SettingsForm)),
        listen: false,
      );

      expect(initialColor, isNot(equals(updatedSettings.color)));

      expect(
        find.descendant(of: colorButtons.at(1), matching: checkIcon),
        findsOne,
      );
    },
  );

  testWidgets('The vibration form uses the values from the current context', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create:
            (_) => SettingsModel(
              color: Colors.red,
              vibration: VibrationWithSettings(duration: 200, intensity: 100),
            ),
        child: const MaterialApp(home: SettingsForm()),
      ),
    );

    final settings = Provider.of<SettingsModel>(
      tester.element(find.byType(SettingsForm)),
      listen: false,
    );

    expect(settings.color, Colors.red);
    expect((settings.vibration as VibrationWithSettings).duration, 200);
    expect((settings.vibration as VibrationWithSettings).intensity, 100);
  });

  testWidgets('Toggling the vibration enables/disables it', (
    WidgetTester tester,
  ) async {
    final mockVibration = MockNoVibration();
    when(mockVibration.hasVibrator).thenAnswer((_) async => true);

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => SettingsModel(vibration: mockVibration),
        child: const MaterialApp(home: SettingsForm()),
      ),
    );
    await tester.pumpAndSettle();

    final vibrationSwitch = find.byType(Switch);
    final settings = Provider.of<SettingsModel>(
      tester.element(find.byType(SettingsForm)),
      listen: false,
    );

    expect(settings.vibration, isA<NoVibration>());
    expect(vibrationSwitch, findsOne);

    await tester.tap(vibrationSwitch);
    await tester.pumpAndSettle();

    expect(settings.vibration, isA<VibrationWithSettings>());
  });

  testWidgets('Toggling off the vibration enables it', (
    WidgetTester tester,
  ) async {
    final mockVibration = MockVibrationWithSettings();
    when(mockVibration.hasVibrator).thenAnswer((_) async => true);
    when(mockVibration.duration).thenReturn(200);
    when(mockVibration.intensity).thenReturn(100);

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => SettingsModel(vibration: mockVibration),
        child: const MaterialApp(home: SettingsForm()),
      ),
    );
    await tester.pumpAndSettle();

    final vibrationSwitch = find.byType(Switch);
    final settings = Provider.of<SettingsModel>(
      tester.element(find.byType(SettingsForm)),
      listen: false,
    );

    expect(settings.vibration, isA<VibrationWithSettings>());
    expect(vibrationSwitch, findsOne);

    await tester.tap(vibrationSwitch);
    await tester.pumpAndSettle();

    expect(settings.vibration, isA<NoVibration>());
  });
}

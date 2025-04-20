import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sports_toolbox/app/time/timer.dart';

void main() {
  final timeRegex = RegExp(r'^\d{2}:\d{2}:\d{2}$');
  final durations = find.descendant(
    of: find.byKey(Key("timers")),
    matching: find.textContaining(timeRegex),
  );

  final addButton = find.widgetWithText(ElevatedButton, 'Add timer');
  // final setButton = find.widgetWithText(ElevatedButton, 'Set timer');
  final removeButton = find.widgetWithText(ElevatedButton, 'Remove timer');
  final startButton = find.widgetWithText(ElevatedButton, 'Start');
  final pauseButton = find.widgetWithText(ElevatedButton, 'Pause');
  final resetButton = find.widgetWithText(ElevatedButton, 'Reset');

  testWidgets('Initial setup with one timer and remove timer button disabled', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: TimerPage()));

    expect(startButton, findsOneWidget);
    expect(durations, findsOne);

    expect(tester.widget<ElevatedButton>(removeButton).enabled, isFalse);
  });

  testWidgets(
    'Adding a timer should add it to the UI list in a lighter color, and enable the remove button',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: TimerPage()));

      expect(addButton, findsOneWidget);

      await tester.tap(addButton);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, "Set"));
      await tester.pumpAndSettle();

      expect(durations, findsNWidgets(2));
      expect(removeButton, findsOneWidget);
      expect(tester.widget<ElevatedButton>(removeButton).enabled, isTrue);

      final firstTimerColor = tester.widget<Text>(durations.first).style?.color;
      final secondTimerColor = tester.widget<Text>(durations.last).style?.color;
      expect(firstTimerColor, isNot(secondTimerColor));
    },
  );

  testWidgets('Starting/pausing the timer switch the "Pause"/"Start"', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: TimerPage()));

    await tester.tap(startButton);
    await tester.pumpAndSettle();

    expect(startButton, findsNothing);
    expect(pauseButton, findsOneWidget);

    await tester.tap(pauseButton);
    await tester.pumpAndSettle();

    expect(startButton, findsOneWidget);
    expect(pauseButton, findsNothing);
  });

  testWidgets('Pausing the timer cause the time to stop', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: TimerPage()));

    await tester.tap(startButton);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 2));
    await tester.tap(pauseButton);

    final startingValue = tester.widget<Text>(durations.first).data;
    expect(startingValue, startsWith("00:00:5"));

    await tester.pump(const Duration(seconds: 2));
    expect(tester.widget<Text>(durations.first).data, startingValue);
  });

  testWidgets(
    'Resetting the timer cause the timer to go back to its initial duration',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: TimerPage()));

      await tester.tap(startButton);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));
      await tester.tap(pauseButton);

      await tester.tap(resetButton);
      await tester.pumpAndSettle();

      final timerValue = tester.widget<Text>(durations.first).data;
      expect(timerValue, "00:01:00");
    },
  );
}

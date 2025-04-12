import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sports_toolbox/app/timer/Timer.dart';

void main() {
  testWidgets('Timer starts, pauses, resets, and sets duration correctly', (WidgetTester tester) async {
    // Build the TimerPage widget
    await tester.pumpWidget(const MaterialApp(home: TimerPage()));

    // Verify initial state
    expect(find.text('01:00'), findsOneWidget);
    expect(find.text('Start'), findsOneWidget);
    expect(find.text('Pause'), findsNothing);

    // Start the timer
    await tester.tap(find.text('Start'));
    await tester.pump();

    // Verify timer is running
    expect(find.text('Pause'), findsOneWidget);
    expect(find.text('Start'), findsNothing);

    // Wait for some time and verify elapsed time
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('00:58'), findsOneWidget);

    // Pause the timer
    await tester.tap(find.text('Pause'));
    await tester.pump();

    // Verify timer is paused
    expect(find.text('Start'), findsOneWidget);
    expect(find.text('Pause'), findsNothing);

    // Reset the timer
    await tester.tap(find.text('Reset'));
    await tester.pump();

    // Verify timer is reset
    expect(find.text('01:00'), findsOneWidget);

    // Set a new duration
    await tester.tap(find.text('Set Timer'));
    await tester.pumpAndSettle();

    // Select new duration in the dialog
    await tester.tap(find.text('02 min').first); // Select 2 minutes
    await tester.tap(find.text('30 sec').first); // Select 30 seconds
    await tester.tap(find.text('Set'));
    await tester.pump();

    // Verify new duration is set
    expect(find.text('02:30'), findsOneWidget);
  });
}
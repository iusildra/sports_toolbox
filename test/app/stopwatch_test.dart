import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sports_toolbox/app/stopwatch.dart';

void main() {
  final timeRegex = RegExp(r'^\d{2}:\d{2}\.\d{2}$');
  testWidgets('Stopwatch starts, stops, and resets correctly', (
    WidgetTester tester,
  ) async {
    // Build the StopwatchPage widget
    await tester.pumpWidget(const MaterialApp(home: StopwatchPage()));

    // Verify initial state
    expect(find.text('00:00.00'), findsOneWidget);
    expect(find.text('Start'), findsOneWidget);
    expect(find.text('Stop'), findsNothing);

    // Start the stopwatch
    await tester.tap(find.text('Start'));
    await tester.pump(const Duration(milliseconds: 100));

    // Verify stopwatch is running
    expect(find.text('Stop'), findsOneWidget);
    expect(find.text('Start'), findsNothing);
    final currentTime = find.textContaining(timeRegex);
    expect(currentTime, findsOneWidget);

    // Wait for some time and verify elapsed time
    await tester.pump(const Duration(seconds: 1));
    final timeAfterOneSecond = find.textContaining(timeRegex);
    expect(timeAfterOneSecond, findsOneWidget);

    expect(currentTime.evaluate().first, timeAfterOneSecond.evaluate().first);

    // Stop the stopwatch
    await tester.tap(find.text('Stop'));
    await tester.pump();

    // Verify stopwatch is stopped
    expect(find.text('Start'), findsOneWidget);
    expect(find.text('Stop'), findsNothing);

    // Reset the stopwatch
    await tester.tap(find.text('Reset'));
    await tester.pump();

    // Verify stopwatch is reset
    expect(find.text('00:00.00'), findsOneWidget);
  });
}

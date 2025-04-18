/* To test
 * Clicking on the setup button opens the setup dialog
 * Clicking on the penalty button opens the penalty dialog
 * In the penalty dialog, selecting a penalty type adds it to the athlete
 *   - The penalty type is displayed in the athlete's penalties list
 *   - The score is updated with the penalty
 *   - The score without the penalty is now displayed
*/

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sports_toolbox/app/counter/penalty.dart';
import 'package:sports_toolbox/app/counter/points_counter.dart';

void main() {
  Future<void> incrementZone(
    WidgetTester tester,
    int index, {
    int increment = 1,
  }) async {
    final incrementZone = find.byKey(PointsCounterPage.scoreBoxKey(index));
    for (int i = 0; i < increment; i++) {
      await tester.tap(incrementZone);
    }
    await tester.pumpAndSettle();
  }

  /* -------------------------------------------------------------------------- */
  /*                                   Scores                                   */
  /* -------------------------------------------------------------------------- */
  testWidgets('Counters start with initial score of 0', (
    WidgetTester tester,
  ) async {
    // Build the CounterPage widget
    await tester.pumpWidget(const MaterialApp(home: PointsCounterPage()));
    final penaltyButton = Icons.remove_circle_outline;
    final setupButton = Icons.settings;

    final scoreDisplay = find.descendant(
      of: find.byType(Expanded),
      matching: find.text("0"),
    );
    // Verify initial state
    expect(scoreDisplay, findsNWidgets(2));
    expect(find.textContaining("Athlete "), findsNWidgets(2));
    expect(find.byIcon(setupButton), findsNWidgets(2));
    expect(find.byIcon(penaltyButton), findsNWidgets(2));
  });

  testWidgets('Clicking on each of the increment zone increment the score', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: PointsCounterPage()));

    await incrementZone(tester, 0);
    await incrementZone(tester, 1);
    await tester.pumpAndSettle();

    // Verify that the score has incremented
    final scoreDisplay = find.descendant(
      of: find.byType(Expanded),
      matching: find.text("1"),
    );
    expect(scoreDisplay, findsNWidgets(2));
  });

  /* -------------------------------------------------------------------------- */
  /*                                  Penalties                                 */
  /* -------------------------------------------------------------------------- */
  testWidgets('Open the penalty selector', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: PointsCounterPage()));

    // Ensure the dialog is not displayed
    expect(find.byType(AlertDialog), findsNothing);

    // Simulate a tap on the penalty button
    await tester.tap(
      find.descendant(
        of: find.byKey(PointsCounterPage.columnKey(0)),
        matching: find.widgetWithIcon(IconButton, Icons.remove_circle_outline),
      ),
    );
    await tester.pumpAndSettle();

    // Verify that the penalty dialog is displayed
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.textContaining("Select a penalty for"), findsOneWidget);
  });

  testWidgets(
    'Adding a penalty removes points from score, show the total without penalties and add it\'s icon',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: PointsCounterPage()));

      final anyAthleteColumn = find.byKey(PointsCounterPage.columnKey(0));
      // Simulate a tap on the penalty button
      await tester.tap(
        find.descendant(
          of: anyAthleteColumn,
          matching: find.widgetWithIcon(
            IconButton,
            Icons.remove_circle_outline,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Simulate a tap on the penalty type
      await tester.tap(
        find.widgetWithText(ListTile, PenaltyType.simple.asString),
      );
      await tester.pumpAndSettle();

      // Verify that the score has been updated
      final scoreDisplay = find.descendant(
        of: anyAthleteColumn,
        matching: find.text("-1"),
      );
      final scoreWithoutPenalties = find.descendant(
        of: anyAthleteColumn,
        matching: find.text("(0)"),
      );
      final penaltyIcon = find.descendant(
        of: anyAthleteColumn,
        matching: find.byIcon(Icons.highlight_remove),
      );
      expect(scoreDisplay, findsOne);
      expect(scoreWithoutPenalties, findsOne);
      expect(penaltyIcon, findsOne);
    },
  );

  /* -------------------------------------------------------------------------- */
  /*                                  Resetting                                 */
  /* -------------------------------------------------------------------------- */
  testWidgets('Resetting the score prompt for confirmation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: PointsCounterPage()));

    // Ensure the dialog is not displayed
    expect(find.byType(AlertDialog), findsNothing);

    await tester.tap(find.byKey(Key("reset-button")));
    await tester.pumpAndSettle();

    // Verify that the confirmation dialog is displayed
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text("Please confirm reset"), findsOneWidget);
  });

  testWidgets('Applying reset updates the scores to 0 for both athletes', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: PointsCounterPage()));

    // Simulate a match
    await incrementZone(tester, 0, increment: 2);
    await incrementZone(tester, 1);
    await tester.pumpAndSettle();

    // Simulate a tap on the reset button
    await tester.tap(find.byKey(Key("reset-button")));
    await tester.pumpAndSettle();

    final applyReset = find.widgetWithText(TextButton, "Reset");

    await tester.tap(applyReset);
    await tester.pumpAndSettle();

    // Verify that the scores have been reset to 0
    expect(find.text("0"), findsNWidgets(2));
  });
}

/* Tests ideas: => integrations tests with the counter
- Color dropdown menu (only available colors are shown)
- Athlete setup dialog
  - updates on change
  - closes when submit is pressed
  - closes when cancel is pressed
  - scores are reset when submitting
*/
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sports_toolbox/app/counter/athlete.dart';
import 'package:sports_toolbox/app/counter/counter_setup.dart';

void main() {
  final List<Color> availableColors = [
    Colors.blue.shade200,
    Colors.red.shade200,
    Colors.green.shade200,
    Colors.yellow.shade200,
    Colors.purple.shade200,
  ];

  final athlete = Athlete(
    key: 0,
    name: 'Athlete 1',
    setup: CounterSettings(color: availableColors[0]),
  );

  testWidgets(
    'Form is opened with athlete name and color pre-filled with current values',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CounterSetup(
              athlete: athlete,
              availableColors: availableColors,
            ),
          ),
        ),
      );

      final dialog = find.byType(Dialog);
      final nameField =
          tester.widget<TextFormField>(find.byKey(const Key('athlete-name-input')));
      final colorDropdown =
          tester.widget<DropdownButton<Color>>(find.byKey(const Key('color-dropdown')));
      // Verify that the name and color are pre-filled

      expect(dialog, findsOneWidget);
      expect(nameField.initialValue, athlete.name);
      expect(colorDropdown.value, athlete.setup.color);
    },
  );

  testWidgets(
    'Form validation should fail when the name is empty or made of spacing characters only',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CounterSetup(
              athlete: athlete,
              availableColors: availableColors,
            ),
          ),
        ),
      );

      final nameField = find.byKey(const Key('athlete-name-input'));
      final submitButton = find.byKey(const Key('submit-setup'));

      testValue(String value) async {
        await tester.enterText(nameField, value);
        await tester.tap(submitButton);
        await tester.pumpAndSettle();
        expect(find.text('Name cannot be empty'), findsOneWidget);
      }

      await testValue('');
      await testValue('   ');
      await testValue('   \n   ');
      await testValue('   \t   ');
      await testValue('   \r   ');
      // Ok, that was just for fun :)
    },
  );
}

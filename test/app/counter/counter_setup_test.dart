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
import 'package:sports_toolbox/data/models/athlete.dart';
import 'package:sports_toolbox/ui/counter/counter_setup.dart';

void main() {
  final athlete = Athlete(
    key: 0,
    name: 'Athlete 1',
    color: CounterSetup.availableColors[0],
  );

  testWidgets(
    'Form is opened with athlete name and color pre-filled with current values',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CounterSetup(athlete: athlete, usedColors: [athlete.color]),
          ),
        ),
      );

      final dialog = find.byType(Dialog);
      final nameField = tester.widget<TextFormField>(
        find.byKey(const Key('athlete-name-input')),
      );
      final colorDropdown = tester.widget<DropdownButton<Color>>(
        find.byKey(const Key('color-dropdown')),
      );
      // Verify that the name and color are pre-filled

      expect(dialog, findsOneWidget);
      expect(nameField.initialValue, athlete.name);
      expect(colorDropdown.value, athlete.color);
    },
  );

  testWidgets(
    'Form validation should fail when the name is empty or made of spacing characters only',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CounterSetup(athlete: athlete, usedColors: [athlete.color]),
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

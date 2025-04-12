import 'package:flutter/material.dart';
import 'package:sports_toolbox/models/theme_model.dart';
import 'package:test/test.dart';

void main() {
  test('Can switch colors and loop back to initial value', () {
    final theme = ThemeModel();
    final startingColor = theme.color;
    expect(startingColor, Colors.blue);

    var nbSwitch = 0;
    theme.addListener(() {
      nbSwitch++;
    });

    for (var i = 0; i < 4; i++) {
      theme.switchColor();
      expect(nbSwitch, i+1);
      expect(theme.color, isNot(startingColor));
    }

    theme.switchColor();
    expect(nbSwitch, 5);
    expect(theme.color, startingColor);
  });
}

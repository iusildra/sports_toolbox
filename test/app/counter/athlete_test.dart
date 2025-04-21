import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sports_toolbox/data/models/athlete.dart';
import 'package:sports_toolbox/data/models/penalty.dart';

void main() {
  test(
    'Adding a penalty to an athlete does not affect its score, but the score with penalties is updated',
    () {
      // Arrange
      final athlete = Athlete(key: 1, name: 'John Doe', color: Colors.blue);
      final penalty = PenaltyType.warning;

      // Act
      athlete.addPenalty(penalty);
      athlete.increment(inc: 3);

      // Assert
      expect(athlete.score, 3);
      expect(athlete.penalties.length, 1);
      expect(athlete.scoreWithPenalties, 0);
    },
  );
}

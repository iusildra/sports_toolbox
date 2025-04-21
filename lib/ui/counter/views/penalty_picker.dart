import 'package:flutter/material.dart';
import 'package:sports_toolbox/data/models/athlete.dart';
import 'package:sports_toolbox/data/models/penalty.dart';

class PenaltyPickerDialog extends StatelessWidget {
  const PenaltyPickerDialog({super.key, required this.athlete});

  final Athlete athlete;

  static void showPenaltyPickerDialog(
    BuildContext context,
    Athlete athlete,
    Function(Athlete, PenaltyType) onComplete,
  ) async {
    final penalty = await showDialog<PenaltyType>(
      context: context,
      builder: (context) => PenaltyPickerDialog(athlete: athlete),
    );
    if (penalty != null) {
      onComplete(athlete, penalty);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select a penalty for ${athlete.name}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children:
            PenaltyType.values.map((penalty) {
              return ListTile(
                title: Text(penalty.asString),
                onTap: () => Navigator.pop(context, penalty),
              );
            }).toList(),
      ),
    );
  }
}

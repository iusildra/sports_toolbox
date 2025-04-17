import 'package:flutter/material.dart';
import 'package:sports_toolbox/app/counter/athlete.dart';
import 'package:sports_toolbox/app/counter/penalty.dart';

class PenaltyPickerDialog extends StatelessWidget {
  const PenaltyPickerDialog({super.key, required this.athlete});

  final Athlete athlete;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select a Penalty for ${athlete.name}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children:
            PenaltyType.values.map((penalty) {
              return ListTile(
                title: Text("${penalty.label} (-${penalty.value})"),
                onTap: () => Navigator.pop(context, penalty),
              );
            }).toList(),
      ),
    );
  }
}

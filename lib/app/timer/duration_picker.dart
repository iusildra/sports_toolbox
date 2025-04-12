import 'package:flutter/material.dart';

class DurationPickerDialog extends StatefulWidget {
  final Duration initialDuration;

  const DurationPickerDialog({super.key, required this.initialDuration});

  @override
  State<DurationPickerDialog> createState() => _DurationPickerDialogState();
}

class _DurationPickerDialogState extends State<DurationPickerDialog> {
  late int _hours;
  late int _minutes;
  late int _seconds;

  @override
  void initState() {
    super.initState();
    _hours = widget.initialDuration.inHours;
    _minutes = widget.initialDuration.inMinutes % 60;
    _seconds = widget.initialDuration.inSeconds % 60 % 60;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set Timer Duration'),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton<int>(
            value: _hours,
            items:
                List.generate(24, (index) => index)
                    .map(
                      (value) => DropdownMenuItem(
                        value: value,
                        child: Text('$value h'),
                      ),
                    )
                    .toList(),
            onChanged: (value) => setState(() => _hours = value!),
          ),
          const SizedBox(width: 10),
          DropdownButton<int>(
            value: _minutes,
            items:
                List.generate(60, (index) => index)
                    .map(
                      (value) => DropdownMenuItem(
                        value: value,
                        child: Text('$value min'),
                      ),
                    )
                    .toList(),
            onChanged: (value) => setState(() => _minutes = value!),
          ),
          const SizedBox(width: 10),
          DropdownButton<int>(
            value: _seconds,
            items:
                List.generate(60, (index) => index)
                    .map(
                      (value) => DropdownMenuItem(
                        value: value,
                        child: Text('$value sec'),
                      ),
                    )
                    .toList(),
            onChanged: (value) => setState(() => _seconds = value!),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(
              context,
              Duration(minutes: _minutes, seconds: _seconds),
            );
          },
          child: const Text('Set'),
        ),
      ],
    );
  }
}

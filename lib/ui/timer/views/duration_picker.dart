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

  DropdownButton<int> _buildDropdownButton({
    required int inputValue,
    required int itemCount,
    required String suffix,
    required ValueChanged<int?> onChanged,
  }) {
    return DropdownButton<int>(
      value: inputValue,
      items: List.generate(
        itemCount,
        (index) =>
            DropdownMenuItem(value: index, child: Text('$index $suffix')),
      ),
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set timer duration'),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16,
        children: [
          _buildDropdownButton(
            inputValue: _hours,
            itemCount: 24,
            suffix: 'h',
            onChanged: (value) => setState(() => _hours = value!),
          ),
          _buildDropdownButton(
            inputValue: _minutes,
            itemCount: 60,
            suffix: 'min',
            onChanged: (value) => setState(() => _minutes = value!),
          ),
          _buildDropdownButton(
            inputValue: _seconds,
            itemCount: 60,
            suffix: 'sec',
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

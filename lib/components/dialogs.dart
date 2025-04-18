import 'package:flutter/material.dart';

class CustomDialogs {
  static AlertDialog confirmReset(
    BuildContext context,
    Key key,
    VoidCallback onReset,
  ) => AlertDialog(
    key: key,
    title: const Text('Please confirm reset'),
    content: const Text('Are you sure you want to reset?'),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () {
          onReset();
          Navigator.pop(context);
        },
        child: Text(
          'Reset',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    ],
  );
}

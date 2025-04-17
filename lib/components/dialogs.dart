import 'package:flutter/material.dart';

class CustomDialogs {
  static AlertDialog confirmReset(BuildContext context, VoidCallback onReset) =>
      AlertDialog(
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
            child: const Text('Reset'),
          ),
        ],
      );
}

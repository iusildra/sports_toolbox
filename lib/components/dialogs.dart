import 'package:flutter/material.dart';

class CustomDialogs {
  static AlertDialog confirmAction(
    BuildContext context,
    Key key,
    VoidCallback onReset,
    {required String title, required String content, required String action}
  ) => AlertDialog(
    key: key,
    title: Text(title),
    content: Text(content),
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
          action,
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    ],
  );
}

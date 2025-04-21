import 'package:flutter/material.dart';

class Borders {
  static surrounding(BuildContext context, {double width = 2, double radius = 8}) => BoxDecoration(
    border: Border.all(
      color: Theme.of(context).colorScheme.primary,
      style: BorderStyle.solid,
      width: width,
    ),
    borderRadius: BorderRadius.circular(radius),
  );
}

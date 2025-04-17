import 'package:flutter/material.dart';

enum PenaltyType {
  simple('Simple', 1, Icon(Icons.highlight_remove, color: Colors.yellowAccent)),
  warning(
    'Warning',
    3,
    Icon(Icons.warning_amber_rounded, color: Colors.red),
  );

  const PenaltyType(this.label, this.value, this.icon);
  final String label;
  final int value;
  final Icon icon;

  Container get asIcons => Container(
    margin: EdgeInsets.symmetric(horizontal: 8),
    child: icon,
  );
}

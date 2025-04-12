import 'package:flutter/material.dart';

abstract class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});
}

// Unused for now
class SimpleAppBar extends CustomAppBar {
  final String title;
  final List<Widget> actions;

  const SimpleAppBar({super.key, required this.title, this.actions = const []});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: actions,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    );
  }
}

class SimpleSliverAppBar extends CustomAppBar {
  final String title;
  final List<Widget> actions;

  const SimpleSliverAppBar({super.key, required this.title, this.actions = const []});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(title),
      actions: actions,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    );
  }
}
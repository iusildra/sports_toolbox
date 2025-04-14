import 'package:flutter/material.dart';
import 'package:sports_toolbox/app/counter/athlete.dart';

class CounterSetup extends StatefulWidget {
  final Athlete athlete;

  final Iterable<Color> availableColors;

  const CounterSetup({
    super.key,
    required this.athlete,
    required this.availableColors,
  });

  @override
  State<StatefulWidget> createState() => _CounterSetupState();
}

class _CounterSetupState extends State<CounterSetup> {
  late Color _color;
  late String _name;

  @override
  void initState() {
    super.initState();
    _color = widget.athlete.setup.color;
    _name = widget.athlete.name;

    print(widget.availableColors);
  }

  @override
  Widget build(BuildContext context) => Dialog(
    child: Container(
      padding: const EdgeInsets.all(20),
      width: 300,
      height: 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Counter Setup', style: TextTheme.of(context).headlineLarge),
          const SizedBox(height: 20),
          Expanded(
            child: Column(
              children: [
                TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Athlete Name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => setState(() => _name = value),
                ),
                const SizedBox(height: 20),
                DropdownButton<Color>(
                  value: _color,
                  items:
                      widget.availableColors
                          .map(
                            (color) => DropdownMenuItem(
                              value: color,
                              child: Container(
                                width: 100,
                                height: 20,
                                color: color,
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (value) => setState(() => _color = value!),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(
                context,
                Athlete(
                  key: widget.athlete.key,
                  name: _name,
                  setup: CounterSettings(color: _color),
                  score: 0,
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:sports_toolbox/app/counter/athlete.dart';
import 'package:sports_toolbox/components/divider.dart';

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
  }

  final _formKey = GlobalKey<FormState>();

  void onSubmit() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(
        context,
        Athlete(
          key: widget.athlete.key,
          name: _name,
          setup: CounterSettings(color: _color),
        ),
      );
    }
  }

  List<DropdownMenuItem<Color>> colorChoiceWidgets() =>
      widget.availableColors
          .map(
            (color) => DropdownMenuItem(
              value: color,
              child: Container(width: 100, height: 20, color: color),
            ),
          )
          .toList();

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
          CustomDividers.simple(context),
          Expanded(child: form()),
          CustomDividers.simple(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                child: const Text('Cancel'),
              ),
              FilledButton(key: Key("submit-setup"), onPressed: onSubmit, child: const Text('Save')),
            ],
          ),
        ],
      ),
    ),
  );

  Form form() => Form(
    key: _formKey,
    child: Column(
      children: [
        TextFormField(
          autofocus: true,
          key: const Key('athlete-name-input'),
          decoration: InputDecoration(
            labelText: 'Athlete Name',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Name cannot be empty';
            }
            return null;
          },
          initialValue: _name,
          onChanged: (value) => setState(() => _name = value),
        ),
        const SizedBox(height: 20),
        DropdownButton<Color>(
          key: const Key('color-dropdown'),
          value: _color,
          items: colorChoiceWidgets(),
          onChanged: (value) => setState(() => _color = value!),
        ),
      ],
    ),
  );
}

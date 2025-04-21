import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sports_toolbox/components/grid_tile.dart';
import 'package:sports_toolbox/ui/settings/settings_form.dart';
import 'package:sports_toolbox/ui/stopwatch/stopwatch.dart';
import 'package:sports_toolbox/ui/counter/views/counter_view.dart';
import 'package:sports_toolbox/ui/timer/views/timer.dart';
import 'package:sports_toolbox/models/settings_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init();
  runApp(
    ChangeNotifierProvider(
      create: (context) => SettingsModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsModel>(
      builder:
          (context, theme, child) => MaterialApp(
            title: 'Sports toolbox',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: theme.color),
            ),
            home: const HomePage(title: 'Sports Toolbox'),
          ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});

  final String title;

  static const _apps = [
    ('Stopwatch', Icons.access_alarm, StopwatchPage()),
    ('Timer', Icons.timer, TimerPage()),
    ('Score counter', Icons.sports_score, CounterPage()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            title: Text(title),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => SettingsForm.openSettingsForm(context),
              ),
            ],
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          SliverGrid.extent(
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            maxCrossAxisExtent: 128,
            childAspectRatio: 1.0,
            children:
                _apps
                    .map(
                      (app) => CustomGridTile(
                        appName: app.$1,
                        appIcon: app.$2,
                        app: app.$3,
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

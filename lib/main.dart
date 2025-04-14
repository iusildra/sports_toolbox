import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sports_toolbox/app/counter/points_counter_1v1.dart';
import 'package:sports_toolbox/app/grid_tile.dart';
import 'package:sports_toolbox/app/time/stopwatch.dart';
import 'package:sports_toolbox/app/time/timer.dart';
import 'package:sports_toolbox/models/theme_model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
      builder: (context, theme, child) {
        return MaterialApp(
          title: 'Sports toolbox',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: theme.color),
          ),
          home: const HomePage(title: 'Sports Toolbox'),
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  static const _apps = [
    ('Stopwatch', Icons.access_alarm, StopwatchPage()),
    ('Timer', Icons.timer, TimerPage()),
    ('1v1 counter', Icons.sports_score, PointsCounter1v1Page())
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
                icon: const Icon(Icons.color_lens),
                onPressed: () => context.read<ThemeModel>().switchColor(),
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

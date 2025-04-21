import 'package:flutter/material.dart';

class CustomGridTile extends StatelessWidget {
  const CustomGridTile({
    super.key,
    required this.appName,
    required this.appIcon,
    required this.app,
  });

  final String appName;

  final IconData appIcon;

  final Widget app;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: GridTile(
        child: GestureDetector(
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => app),
              ),
          child: Card(
            color: Theme.of(context).colorScheme.primary,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    appIcon,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: Theme.of(context).textTheme.displaySmall?.fontSize,
                  ),
                  Text(
                    appName,
                    style: TextTheme.of(context).labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

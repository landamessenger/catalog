import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';

import 'body_widget.dart';
import 'fab_widget.dart';

@Preview(
  id: 'MainScreenPreview',
  path: 'widgets/main_screen_widget',
  usesDummies: true,
  dummyParameters: [
    'title',
    'infoText',
    'counter',
    'incrementCounter',
  ],
)
class MainScreen extends StatelessWidget {
  final Function() incrementCounter;

  final String title;

  final String infoText;

  final int counter;

  const MainScreen({
    super.key,
    required this.infoText,
    required this.counter,
    required this.title,
    required this.incrementCounter,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: BodyWidget(
        infoText: infoText,
        counter: counter,
      ),
      floatingActionButton: FabWidget(
        incrementCounter: incrementCounter,
      ),
    );
  }
}

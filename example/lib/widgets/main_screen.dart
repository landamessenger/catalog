import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';

import 'screen/body_widget.dart';
import 'utils/bottom/fab_widget.dart';

@Preview(
  parameters: [
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

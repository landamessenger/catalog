import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';

@Preview(
  id: 'CounterWidgetPreview',
  path: 'widgets/counter_widget',
  description: 'Basic counter widget',
  parameters: [
    'counter',
  ],
)
class CounterWidget extends StatelessWidget {
  final int counter;

  const CounterWidget({super.key, required this.counter});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$counter',
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}

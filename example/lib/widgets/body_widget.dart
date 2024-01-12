import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';

import 'counter_widget.dart';

@Preview(
  id: 'BodyWidgetPreview',
  path: 'widgets/body_widget',
  description: 'Basic body widget',
  usesDummies: true,
  dummyParameters: [
    'infoText',
    'counter',
  ],
)
class BodyWidget extends StatelessWidget {
  final String infoText;

  final int counter;

  const BodyWidget({
    super.key,
    required this.counter,
    required this.infoText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            infoText,
          ),
          CounterWidget(counter: counter),
        ],
      ),
    );
  }
}

/// AUTOGENERATED FILE. DO NOT EDIT

import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';
import 'package:example/widgets/counter_widget.dart';
import 'dummy/counter_widget.dummy.dart';

@Preview(
  id: 'CounterWidgetPreview',
  path: 'widgets/counter_widget',
  description: 'Basic counter widget',
  usesDummies: true,
  dummyParameters: [
    'counter',
  ],
)
class CounterWidgetPreview extends PreviewWidget {
  const CounterWidgetPreview({super.key});

  @override
  Widget preview(BuildContext context) => CounterWidgetDummy().dummies.isEmpty
      ? Container()
      : ListView(
          children: [
            for (int i = 0; i < CounterWidgetDummy().dummies.length; i++)
              Center(
                child: Container(
                  constraints: const BoxConstraints(
                    maxHeight: 700,
                    maxWidth: 700,
                  ),
                  child: Builder(
                    builder: (context) {
                      var dummy = CounterWidgetDummy().dummies[i];
                      return Padding(
                        padding: const EdgeInsets.all(15),
                        child: CounterWidget(
                          counter: dummy.parameters['counter'],
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        );
}
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
class CounterWidgetPreview extends ParentPreviewWidget {
  const CounterWidgetPreview({super.key});

  @override
  Widget preview(BuildContext context) {
    Catalog().widgetBasicPreviewMap.clear();
    Catalog().widgetDevicePreviewMap.clear();

    if (CounterWidgetDummy().dummies.isEmpty) {
      return Container();
    }

    final deviceScreenshotsAvailable =
        CounterWidgetDummy().deviceScreenshotsAvailable;
    final screenshotsAvailable = CounterWidgetDummy().screenshotsAvailable;

    int basicScreenshots = screenshotsAvailable - deviceScreenshotsAvailable;

    return ListView(
      children: [
        Column(
          children: [
            if (basicScreenshots > 0)
              Center(
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 400,
                  ),
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      color: Colors.white,
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                '$basicScreenshots basic screenshots available',
                              ),
                            ),
                          ),
                          const IconButton(
                            onPressed: processBasicScreenshots,
                            icon: Icon(
                              Icons.screenshot,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            if (deviceScreenshotsAvailable > 0)
              Center(
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 400,
                  ),
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      color: Colors.white,
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                '$deviceScreenshotsAvailable device screenshots available',
                              ),
                            ),
                          ),
                          const IconButton(
                            onPressed: processDeviceScreenshots,
                            icon: Icon(
                              Icons.screenshot,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            for (int i = 0; i < CounterWidgetDummy().dummies.length; i++)
              PreviewBoundary(
                widgetKey: GlobalKey(),
                dummyBuilder: () => CounterWidgetDummy().dummies[i],
                builder: (BuildContext context, Dummy dummy) {
                  return CounterWidget(
                    counter: dummy.parameters['counter'],
                  );
                },
              ),
          ],
        )
      ],
    );
  }
}

/// AUTOGENERATED FILE. DO NOT EDIT

import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';
import 'package:example/widgets/main_screen.dart';
import '../dummy/main_screen.dummy.dart';

@Preview(
  parameters: [
    'title',
    'infoText',
    'counter',
    'incrementCounter',
  ],)
class MainScreenPreview extends ParentPreviewWidget {
  const MainScreenPreview({super.key});
    
  @override
  Widget preview(BuildContext context) {
    Catalog().widgetBasicPreviewMap.clear();
    Catalog().widgetDevicePreviewMap.clear();

    if (MainScreenDummy().dummies.isEmpty) {
      return Container();
    }

    final deviceScreenshotsAvailable =
        MainScreenDummy().deviceScreenshotsAvailable;
    final screenshotsAvailable = MainScreenDummy().screenshotsAvailable;

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
            for (int i = 0; i < MainScreenDummy().dummies.length; i++)
                PreviewBoundary(
    widgetKey: GlobalKey(),
    dummyBuilder: () => MainScreenDummy().dummies[i],
    builder: (BuildContext context, Dummy dummy) {
      return MainScreen(title: dummy.parameters['title'],infoText: dummy.parameters['infoText'],counter: dummy.parameters['counter'],incrementCounter: dummy.parameters['incrementCounter'],);
    },
  ),
  
          ],
        )
      ],
    );
  }
  
  
}
    
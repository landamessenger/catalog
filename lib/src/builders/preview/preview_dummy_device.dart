import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';

class PreviewDummyDevice extends StatelessWidget {
  final DeviceInfo deviceInfo;
  final Dummy dummy;
  final Widget Function(BuildContext context, Dummy dummy) builder;

  final Function() startCapturing;

  final GlobalKey widgetKey;

  const PreviewDummyDevice({
    super.key,
    required this.dummy,
    required this.builder,
    required this.deviceInfo,
    required this.startCapturing,
    required this.widgetKey,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.fromLTRB(15, 15, 15, 25),
        constraints: const BoxConstraints(
          maxWidth: 800,
        ),
        child: Column(
          children: [
            Card(
              clipBehavior: Clip.hardEdge,
              child: Container(
                padding: const EdgeInsets.all(15),
                color: Colors.white,
                constraints: const BoxConstraints(
                  maxWidth: 400,
                ),
                child: Row(
                  children: [
                    Center(
                      child: Text(
                        dummy.description,
                      ),
                    ),
                    IconButton(
                      onPressed: startCapturing,
                      icon: const Icon(
                        Icons.screenshot,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(7.5),
            ),
            RepaintBoundary(
              key: widgetKey,
              child: DeviceFrame(
                device: deviceInfo,
                orientation: dummy.orientation,
                screen: Container(
                  color: dummy.backgroundColor,
                  child: Builder(
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(0),
                        child: builder(context, dummy),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

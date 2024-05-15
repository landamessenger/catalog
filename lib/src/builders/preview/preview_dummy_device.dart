import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';

class PreviewDummyDevice extends StatelessWidget {
  final bool capturing;

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
    required this.capturing,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.fromLTRB(15, 15, 15, 25),
        constraints: BoxConstraints(
          maxWidth: capturing ? 1200 : 400,
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
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          dummy.description,
                        ),
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
                orientation: dummy.device.orientation,
                screen: Container(
                  color: dummy.device.backgroundColor,
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

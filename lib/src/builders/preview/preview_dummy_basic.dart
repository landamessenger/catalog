import 'package:catalog/src/builders/dummy.dart';
import 'package:flutter/material.dart';

class PreviewDummyBasic extends StatelessWidget {
  final Dummy dummy;

  final bool capturing;

  final Widget Function(BuildContext context, Dummy dummy) builder;

  final GlobalKey widgetKey;

  final Function() startCapturing;

  const PreviewDummyBasic({
    super.key,
    required this.dummy,
    required this.builder,
    required this.startCapturing,
    required this.widgetKey,
    required this.capturing,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
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
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            constraints: BoxConstraints(
              maxHeight: 700,
              maxWidth: capturing ? 900 : 400,
            ),
            child: Builder(
              builder: (context) {
                return Padding(
                  padding: const EdgeInsets.all(15),
                  child: RepaintBoundary(
                    key: widgetKey,
                    child: builder(context, dummy),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:catalog/src/builders/dummy.dart';
import 'package:flutter/material.dart';

class PreviewDummyBasic extends StatelessWidget {
  final Dummy dummy;

  final Widget Function(BuildContext context, Dummy dummy) builder;

  final GlobalKey widgetKey;

  final Function() startCapturing;

  const PreviewDummyBasic({
    super.key,
    required this.dummy,
    required this.builder,
    required this.startCapturing,
    required this.widgetKey,
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
          Container(
            constraints: const BoxConstraints(
              maxHeight: 700,
              maxWidth: 700,
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

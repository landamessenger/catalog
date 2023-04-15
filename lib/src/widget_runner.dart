import 'package:flutter/material.dart';

/// A Calculator.
class WidgetRunner extends StatelessWidget {
  final List<String> args;
  final Widget application;
  final Widget preview;

  const WidgetRunner({
    Key? key,
    required this.args,
    required this.application,
    required this.preview,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (args.contains('catalog')) {
      return preview;
    }
    return application;
  }
}

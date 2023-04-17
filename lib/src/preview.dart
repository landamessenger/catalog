import 'package:catalog/src/builders/preview_scaffold.dart';
import 'package:flutter/material.dart';

abstract class PreviewWidget extends StatelessWidget {
  Size get size => const Size(-1, -1);

  bool get center => true;

  const PreviewWidget({super.key});

  Widget preview(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return PreviewScaffold(
      title: runtimeType.toString(),
      child: Center(
        child: preview(context),
      ),
    );
  }
}

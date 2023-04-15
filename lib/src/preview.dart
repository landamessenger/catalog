import 'package:flutter/material.dart';

abstract class PreviewWidget extends StatelessWidget {
  Size get size => const Size(-1, -1);

  bool get center => true;

  const PreviewWidget({super.key});

  Widget preview(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return preview(context);
  }
}

import 'package:catalog/src/builders/catalog/preview_scaffold.dart';
import 'package:flutter/material.dart';

abstract class ParentPreviewWidget extends StatelessWidget {
  Size get size => const Size(-1, -1);

  bool get center => true;

  String get title => 'preview_page';

  String get basePath => '/catalog';

  const ParentPreviewWidget({super.key});

  Widget preview(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return PreviewScaffold(
      basePath: basePath,
      title: title,
      child: Center(
        child: preview(context),
      ),
    );
  }
}

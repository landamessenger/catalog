import 'package:catalog/catalog.dart';
import 'package:catalog/src/utils/svg.dart';
import 'package:flutter/material.dart';

import 'drawer_preview.dart';

class PreviewScaffold extends StatelessWidget {
  final Widget? drawer;
  final Widget child;
  final String? title;
  final void Function()? onBackPressed;
  final String basePath;

  const PreviewScaffold({
    super.key,
    required this.child,
    this.title,
    this.drawer,
    this.onBackPressed,
    required this.basePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SizedBox(
        width: 600.0,
        child: Drawer(
          child: DrawerPreview(
            basePath: basePath,
            onBackPressed: onBackPressed ?? Catalog().onBackPressed,
          ),
        ),
      ),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
        title: Text(title ?? ''),
      ),
      body: Stack(
        children: [
          Container(
            color: const Color(0xFFECE5DD),
          ),
          const Positioned.fill(
            child: Image(
              repeat: ImageRepeat.repeat,
              image: Svg(
                'ff',
                scale: 2,
                foregroundColor: Colors.white,
                size: Size(50, 50),
              ),
            ),
          ),
          Center(
            child: child,
          ),
        ],
      ),
    );
  }
}

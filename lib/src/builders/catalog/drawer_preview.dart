import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';

class DrawerPreview extends StatefulWidget {
  final void Function()? onBackPressed;
  final String basePath;

  const DrawerPreview({
    super.key,
    this.onBackPressed,
    required this.basePath,
  });

  @override
  DrawerPreviewState createState() => DrawerPreviewState();
}

class DrawerPreviewState extends State<DrawerPreview> {
  ComponentNode? node;

  @override
  void initState() {
    super.initState();
    Catalog().get(context).then((value) {
      if (value == null) return;
      node = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final n = node;
    if (n == null) {
      return Container();
    }
    var height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: 600,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (widget.onBackPressed != null) {
                      widget.onBackPressed!();
                    }
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                  ),
                ),
                const Text(
                  'Catalog',
                  style: TextStyle(
                    fontSize: 16,
                    letterSpacing: .3,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: height - 200,
            child: ListView(
              children: [
                buildTreeWidget(
                  context,
                  widget.basePath,
                  n,
                  0,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

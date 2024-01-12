/// AUTOGENERATED FILE. DO NOT EDIT

import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WidgetsPreviewPageDummy extends StatefulWidget {
  static String routeName = 'widgets';

  const WidgetsPreviewPageDummy({super.key});

  @override
  WidgetsPreviewPageDummyState createState() => WidgetsPreviewPageDummyState();
}

class WidgetsPreviewPageDummyState extends State<WidgetsPreviewPageDummy> {
  @override
  Widget build(BuildContext context) {
    return PreviewScaffold(
      child: ListView(
        children: [
          ListTile(
            title: const Text(
              'body_widget',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                letterSpacing: .3,
              ),
            ),
            onTap: () {
              context.go('/catalog/widgets/body_widget');
            },
          ),
          ListTile(
            title: const Text(
              'fab_widget',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                letterSpacing: .3,
              ),
            ),
            onTap: () {
              context.go('/catalog/widgets/fab_widget');
            },
          ),
          ListTile(
            title: const Text(
              'counter_widget',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                letterSpacing: .3,
              ),
            ),
            onTap: () {
              context.go('/catalog/widgets/counter_widget');
            },
          ),
        ],
      ),
    );
  }
}

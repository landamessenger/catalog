import 'package:flutter/material.dart';

class PreviewScaffold extends StatelessWidget {
  final Widget child;
  final String? title;

  const PreviewScaffold({
    Key? key,
    required this.child,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
        title: Text(title ?? ''),
      ),
      body: Container(
        color: Colors.white,
        child: child,
      ),
    );
  }
}

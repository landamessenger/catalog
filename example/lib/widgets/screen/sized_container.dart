import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';

@Preview(
  description: 'Container with a max width',
  parameters: ['width', 'child'],
)
class SizedContainer extends StatelessWidget {
  final double width;
  final Widget child;

  const SizedContainer({
    super.key,
    this.width = 500,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => Container(
        constraints: BoxConstraints(
          maxWidth: width,
        ),
        child: child,
      );
}

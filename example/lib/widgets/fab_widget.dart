import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';

@Preview(
  id: 'FabWidgetPreview',
  path: 'widgets/fab_widget',
  description: 'Basic fab widget',
  parameters: {
    'incrementCounter': 'void_function_snackbar',
  },
)
class FabWidget extends StatelessWidget {
  final Function() incrementCounter;

  const FabWidget({
    super.key,
    required this.incrementCounter,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: incrementCounter,
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    );
  }
}

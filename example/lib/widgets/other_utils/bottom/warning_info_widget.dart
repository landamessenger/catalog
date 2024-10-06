import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';

@Preview(
  description: 'Basic warning info text for alert',
  parameters: ['infoText'],
)
class WarningInfoWidget extends StatelessWidget {
  final String infoText;

  const WarningInfoWidget({
    super.key,
    required this.infoText,
  });

  @override
  Widget build(BuildContext context) {
    return Text(infoText);
  }
}

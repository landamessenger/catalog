import 'package:catalog/src/widget_runner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'adds one to input values',
    () {
      final calculator = WidgetRunner(
        args: const [],
        application: Container(),
        preview: Container(),
      );
      // expect(calculator.addOne(2), 3);
    },
  );
}

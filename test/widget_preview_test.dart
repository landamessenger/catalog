import 'package:catalog/src/catalog_runner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  test(
    'adds one to input values',
    () {
      final runner = CatalogRunner(
        args: const [],
        application: Container(),
        route: GoRoute(
          path: '/catalog',
        ),
      );
      // expect(calculator.addOne(2), 3);
    },
  );
}

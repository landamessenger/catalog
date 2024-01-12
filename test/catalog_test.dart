import 'package:catalog/src/catalog_runner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  test('Basic dummy test', () {
    final runner = CatalogRunner(
      application: Container(),
      route: GoRoute(
        path: '/catalog',
      ),
    );
    expect(runner.enabled, false);
  });
}

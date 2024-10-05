import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stringcare/stringcare.dart';

extension WidgetTestExt on WidgetTester {
  Future<void> test(Widget widget) async {
    await pumpWidget(
      MaterialApp(
        navigatorKey: Stringcare().navigatorKey,
        supportedLocales: Stringcare().locales,
        localizationsDelegates: Stringcare().delegates,
        home: widget,
      ),
    );
    await pumpAndSettle();
  }

  Future<void> setupContext() async {
    await pumpWidget(
      MaterialApp(
        navigatorKey: Stringcare().navigatorKey,
        supportedLocales: Stringcare().locales,
        localizationsDelegates: Stringcare().delegates,
        home: Container(),
      ),
    );
    await pumpAndSettle();
  }
}

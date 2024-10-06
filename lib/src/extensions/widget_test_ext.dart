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
        home: Center(child: widget),
      ),
    );
    await pumpAndSettle();
  }

  /// The original unencrypted resources are used on test.
  /// Uses `dart:io` under the hood.
  Future<void> setupTestContext() => _setupContext(
        useEncrypted: false,
      );

  /// The encrypted resources are consumed.
  Future<void> setupIntegrationTestContext() => _setupContext(
        useEncrypted: true,
      );

  /// Disables the Stringcare native libs (.so and .dylib) and uses the Dart
  /// implementation. Also configures the encryption status.
  Future<void> _setupContext({
    required bool useEncrypted,
  }) async {
    Stringcare().disableNative = true;
    Stringcare().useEncrypted = useEncrypted;
    await pumpWidget(
      MaterialApp(
        navigatorKey: Stringcare().navigatorKey,
        supportedLocales: Stringcare().locales,
        localizationsDelegates: Stringcare().delegates,
        home: Container(),
      ),
    );
    await pumpAndSettle();
    await Stringcare().load();
  }
}

import 'package:catalog/catalog.dart';
import 'package:catalog/src/builders/screenshots/types/base/base_screenshot.dart';
import 'package:flutter/material.dart';

/// - IPAD_PRO_3GEN_129 -> 2048 x 2732
/// - IPAD_PRO_129 -> 2048 x 2732
/// - IPHONE_55 -> 1242 x 2208
/// - IPHONE_65 -> 1284 x 2778
///
class Screenshot {
  final List<BaseScreenshot> screenshots;
  final List<String> languages;

  const Screenshot({
    this.screenshots = const [],
    this.languages = const [],
  });
}

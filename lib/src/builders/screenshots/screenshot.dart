import 'dart:ui';

import 'package:catalog/src/builders/screenshots/types/base/base_screenshot.dart';

/// - IPAD_PRO_3GEN_129 -> 2048 x 2732
/// - IPAD_PRO_129 -> 2048 x 2732
/// - IPHONE_55 -> 1242 x 2208
/// - IPHONE_65 -> 1284 x 2778
///

class Screenshot {
  final List<BaseScreenshot> screenshots;

  final List<Locale> locales;

  final Future<String> Function(Locale? locale)? outputFolder;

  const Screenshot({
    this.screenshots = const [],
    this.locales = const [],
    this.outputFolder,
  });
}

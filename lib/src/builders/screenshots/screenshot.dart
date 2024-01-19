import 'dart:ui';

import 'package:catalog/src/builders/screenshots/types/base/base_screenshot.dart';

import 'background.dart';

class Screenshot {
  final List<BaseScreenshot> screenshots;

  final List<Locale> locales;

  final Future<String> Function(Locale? locale)? outputFolder;

  final Background background;

  const Screenshot({
    this.screenshots = const [],
    this.locales = const [],
    this.outputFolder,
    this.background = Background.blurHash,
  });
}

import 'dart:ui';

import 'package:catalog/src/builders/screenshots/types/base/base_screenshot.dart';
import 'package:catalog/src/extensions/locale_ext.dart';

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

  static Future<String> iOSFastlaneDirectory(Locale? locale) async {
    return 'ios/fastlane/screenshots/${locale?.appleStoreAdapter() ?? 'en-US'}';
  }

  static Future<String> macOSFastlaneDirectory(Locale? locale) async {
    return 'macos/fastlane/screenshots/${locale?.appleStoreAdapter() ?? 'en-US'}';
  }

  static Future<String> androidFastlaneDirectory(Locale? locale) async {
    return 'android/fastlane/metadata/android/${locale?.appleStoreAdapter() ?? 'en-US'}/images/phoneScreenshots';
  }
}

import 'package:catalog/src/builders/screenshots/screen_shot_size.dart';
import 'package:catalog/src/builders/screenshots/types/base/base_apple_screenshot.dart';

class MacOS extends BaseAppleScreenshot {
  MacOS({required super.index});

  @override
  String get imageName => '_APP_DESKTOP_';

  @override
  ScreenShotSize get size => ScreenShotSize(
        width: 2880.0,
        height: 1800.0,
      );
}

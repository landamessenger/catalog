import 'package:catalog/src/builders/screenshots/screen_shot_size.dart';
import 'package:catalog/src/builders/screenshots/types/base/base_apple_screenshot.dart';

class IPhone65 extends BaseAppleScreenshot {
  IPhone65({required super.index});

  @override
  String get imageName => '_APP_IPHONE_65_';

  @override
  ScreenShotSize get size => ScreenShotSize(
        width: 1284.0,
        height: 2778.0,
      );
}

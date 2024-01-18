import 'package:catalog/src/builders/screenshots/screen_shot_size.dart';
import 'package:catalog/src/builders/screenshots/types/base/base_apple_screenshot.dart';

class IPadPro3Gen extends BaseAppleScreenshot {
  IPadPro3Gen({required super.index});

  @override
  String get imageName => '_APP_IPAD_PRO_3GEN_129_';

  @override
  ScreenShotSize get size => ScreenShotSize(
        width: 2048.0,
        height: 2732.0,
      );
}

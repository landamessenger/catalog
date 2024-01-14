import 'package:catalog/src/builders/screenshots/screen_shot_size.dart';
import 'package:catalog/src/builders/screenshots/types/base/base_screenshot.dart';

class IPhone55 extends BaseScreenshot {
  @override
  String get imageName => '_APP_IPHONE_55_';

  @override
  ScreenShotSize get size => ScreenShotSize(
        width: 1242.0,
        height: 2208.0,
      );
}

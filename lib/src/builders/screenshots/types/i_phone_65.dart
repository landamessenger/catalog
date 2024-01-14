import 'package:catalog/src/builders/screenshots/screen_shot_size.dart';
import 'package:catalog/src/builders/screenshots/types/base/base_screenshot.dart';

class IPhone65 extends BaseScreenshot {
  @override
  String get imageName => '_APP_IPHONE_65_';

  @override
  ScreenShotSize get size => ScreenShotSize(
        width: 1284.0,
        height: 2778.0,
      );
}

import 'package:catalog/src/builders/screenshots/screen_shot_size.dart';
import 'package:catalog/src/builders/screenshots/types/base/base_android_screenshot.dart';

class AndroidPhone extends BaseAndroidScreenshot {
  AndroidPhone({required super.index});

  @override
  ScreenShotSize get size => ScreenShotSize(
        width: 1284.0,
        height: 2778.0,
      );
}

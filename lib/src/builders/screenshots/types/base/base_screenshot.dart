import 'package:catalog/src/builders/screenshots/screen_shot_size.dart';

abstract class BaseScreenshot {
  String get imageName;

  ScreenShotSize get size;
}

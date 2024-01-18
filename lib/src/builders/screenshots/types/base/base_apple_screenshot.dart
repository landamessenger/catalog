import 'package:catalog/src/builders/screenshots/types/base/base_screenshot.dart';

abstract class BaseAppleScreenshot extends BaseScreenshot {
  @override
  String get fileName => '$index$imageName$index.png';

  BaseAppleScreenshot({required super.index});
}

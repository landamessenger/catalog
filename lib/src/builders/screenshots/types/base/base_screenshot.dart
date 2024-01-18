import 'dart:ui';

import 'package:catalog/src/builders/screenshots/screen_shot_size.dart';

abstract class BaseScreenshot {
  Locale? locale;

  String get fileName;

  String get imageName;

  ScreenShotSize get size;

  int index;

  BaseScreenshot({required this.index});

  void setLocale(Locale? l) {
    locale = l;
  }
}

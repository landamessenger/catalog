import 'package:catalog/src/builders/screenshots/types/i_phone_55.dart';

import 'types/i_pad_pro.dart';
import 'types/i_pad_pro_3gen.dart';
import 'types/i_phone_65.dart';

class Screenshots {
  static final apple = AppleScreenshots();
}

class AppleScreenshots {
  static final ipad3gen = IPadPro3Gen();
  static final ipad = IPadPro();
  static final iphone55 = IPhone55();
  static final iphone65 = IPhone65();
}

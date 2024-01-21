import 'dummy.dart';

abstract class PreviewDummy {
  List<Dummy> get dummies;

  int get screenshotsAvailable => dummies.length;

  int get deviceScreenshotsAvailable {
    int index = 0;
    for (final d in dummies) {
      if (d.device.deviceInfo != null) {
        index++;
      }
    }
    return index;
  }
}

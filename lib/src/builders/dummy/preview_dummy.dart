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

  Dummy get(int index) {
    if (dummies.isEmpty) throw Exception('Empty dummies list');
    if (index >= dummies.length) return dummies.first;
    return dummies[index];
  }
}

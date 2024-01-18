import '../constants.dart';
import 'device/device.dart';
import 'screenshots/screenshot.dart';

/// - IPAD_PRO_3GEN_129 -> 2048 x 2732
/// - IPAD_PRO_129 -> 2048 x 2732
/// - IPHONE_55 -> 1242 x 2208
/// - IPHONE_65 -> 1284 x 2778
///
class Dummy {
  final String description;

  final Device device;

  final Screenshot screenshot;

  final List<dynamic> listParameters;

  final Map<String, dynamic> parameters;

  const Dummy({
    this.description = todoDescription,
    this.parameters = const {},
    this.device = const Device(),
    this.screenshot = const Screenshot(),
    this.listParameters = const [],
  });
}

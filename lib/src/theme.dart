import 'dart:ui';

String colorToHexStringNoAlpha(Color color) {
  if (color.value == 0) {
    return '#000000';
  }
  return '#${color.value.toRadixString(16).substring(2, 8).toUpperCase()}';
}

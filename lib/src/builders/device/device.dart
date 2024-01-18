import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';

class Device {
  final DeviceInfo? deviceInfo;
  final Orientation orientation;
  final Color backgroundColor;

  const Device({
    this.deviceInfo,
    this.orientation = Orientation.portrait,
    this.backgroundColor = Colors.white,
  });
}

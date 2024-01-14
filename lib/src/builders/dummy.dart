import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';

class Dummy {
  final String description;
  final DeviceInfo? deviceInfo;
  final Orientation orientation;
  final Color backgroundColor;
  final List<dynamic> listParameters;
  final Map<String, dynamic> parameters;

  const Dummy({
    this.description = todoDescription,
    this.parameters = const {},
    this.listParameters = const [],
    this.deviceInfo,
    this.orientation = Orientation.portrait,
    this.backgroundColor = Colors.white,
  });
}

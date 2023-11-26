import 'package:flutter/material.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/main_content.dart';

enum ScreenSize {
  small(300.0),
  normal(400.0),
  large(600.0),
  extraLarge(1000.0);

  final double size;

  const ScreenSize(this.size);
}

ScreenSize getScreenSize(BuildContext context) {
  double deviceWidth = MediaQuery.sizeOf(context).shortestSide;
  logger.d(deviceWidth); // Gives us the shortest side of the device
  if (deviceWidth >= ScreenSize.extraLarge.size) return ScreenSize.extraLarge;
  if (deviceWidth >= ScreenSize.large.size) return ScreenSize.large;
  if (deviceWidth >= ScreenSize.normal.size) return ScreenSize.normal;
  return ScreenSize.small;
}

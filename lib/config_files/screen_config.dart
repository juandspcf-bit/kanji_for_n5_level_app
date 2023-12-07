import 'package:flutter/material.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/main_content.dart';

enum ScreenSizeWidth {
  small(300.0),
  normal(400.0),
  large(600.0),
  extraLarge(1000.0);

  final double size;

  const ScreenSizeWidth(this.size);
}

enum ScreenSizeHeight {
  small(700.0),
  normal(800.0);

  final double size;

  const ScreenSizeHeight(this.size);
}

ScreenSizeWidth getScreenSizeWidth(BuildContext context) {
  double deviceWidth = MediaQuery.sizeOf(context).shortestSide;
  double deviceHeight = MediaQuery.sizeOf(context).longestSide;
  logger.d(
      'width:$deviceWidth , height:$deviceHeight'); // Gives us the shortest side of the device
  if (deviceWidth >= ScreenSizeWidth.extraLarge.size) {
    return ScreenSizeWidth.extraLarge;
  }
  if (deviceWidth >= ScreenSizeWidth.large.size) return ScreenSizeWidth.large;
  if (deviceWidth >= ScreenSizeWidth.normal.size) return ScreenSizeWidth.normal;
  return ScreenSizeWidth.small;
}

ScreenSizeHeight getScreenSizeHeight(BuildContext context) {
  double deviceWidth = MediaQuery.sizeOf(context).shortestSide;
  double deviceHeight = MediaQuery.sizeOf(context).longestSide;
  logger.d(
      'width:$deviceWidth , height:$deviceHeight'); // Gives us the shortest side of the device
  if (deviceHeight >= ScreenSizeHeight.normal.size) {
    return ScreenSizeHeight.normal;
  }
  return ScreenSizeHeight.small;
}

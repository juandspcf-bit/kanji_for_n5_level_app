import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  //double deviceHeight = MediaQuery.sizeOf(context).longestSide;
  // Gives us the shortest side of the device
  if (deviceWidth >= ScreenSizeWidth.extraLarge.size) {
    return ScreenSizeWidth.extraLarge;
  }
  if (deviceWidth >= ScreenSizeWidth.large.size) return ScreenSizeWidth.large;
  if (deviceWidth >= ScreenSizeWidth.normal.size) return ScreenSizeWidth.normal;
  return ScreenSizeWidth.small;
}

ScreenSizeHeight getScreenSizeHeight(BuildContext context) {
//  double deviceWidth = MediaQuery.sizeOf(context).shortestSide;
  double deviceHeight = MediaQuery.sizeOf(context).longestSide;

  if (deviceHeight >= ScreenSizeHeight.normal.size) {
    return ScreenSizeHeight.normal;
  }
  return ScreenSizeHeight.small;
}

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 96, 59, 181),
);

var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color(0xFF006687),
);

final darkTheme = ThemeData.dark();

ThemeData getDarkTheme(BuildContext context) {
  return darkTheme.copyWith(
    colorScheme: kDarkColorScheme,
    textTheme: GoogleFonts.latoTextTheme(darkTheme.textTheme),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kDarkColorScheme.primary,
        foregroundColor: kDarkColorScheme.onPrimary,
        textStyle: Theme.of(context).textTheme.bodyLarge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    /*       cardTheme: const CardTheme().copyWith(
          color: kDarkColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),

         appBarTheme: const AppBarTheme()
            .copyWith(backgroundColor: Color.fromARGB(255, 14, 46, 77)),*/
  );
}

ThemeData getLightTheme() {
  return ThemeData.light().copyWith(
    colorScheme: kColorScheme,
  );
}

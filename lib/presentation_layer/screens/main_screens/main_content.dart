import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/config_files/screen_config.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/navigation_rails/main_content_landscape.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/navigation_bottom/main_content_portrait.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/status_operations_dialogs.dart';

class MainContent extends ConsumerWidget with StatusDBStoringDialogs {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = MediaQuery.orientationOf(context);
    final sizeScreen = getScreenSizeWidth(context);
    var navigationBarMode = NavBarMode.bottom;
    switch ((orientation, sizeScreen)) {
      case (Orientation.landscape, _):
        {
          navigationBarMode = NavBarMode.rail;
        }
      case (_, ScreenSizeWidth.extraLarge):
        navigationBarMode = NavBarMode.bottom;
      case (_, ScreenSizeWidth.large):
        navigationBarMode = NavBarMode.bottom;
      case (_, _):
        navigationBarMode = NavBarMode.bottom;
    }

    return navigationBarMode == NavBarMode.bottom
        ? const MainContentPortrait()
        : const MainContentLandScape();
  }
}

enum NavBarMode {
  bottom,
  rail,
}

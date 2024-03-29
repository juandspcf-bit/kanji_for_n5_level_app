import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/config_files/screen_config.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/repositories/local_database/db_quiz_data_functions/db_quiz_data_functions.dart';
import 'package:kanji_for_n5_level_app/screens/account_details/account_details.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/navigation_rails/custom_navigation_rail.dart';
import 'package:kanji_for_n5_level_app/screens/navigation_bar_screens/bottom_navigation_bar.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/main_content_provider.dart';
import 'package:kanji_for_n5_level_app/screens/navigation_bar_screens/favorite_screen/kanjis_for_favorites_screen.dart';
import 'package:kanji_for_n5_level_app/screens/navigation_bar_screens/pogress_screen/progress_screen.dart';
import 'package:kanji_for_n5_level_app/screens/navigation_bar_screens/search_screen.dart';
import 'package:kanji_for_n5_level_app/screens/navigation_bar_screens/sections_screen/sections_screen.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/status_operations_dialogs.dart';

class MainContent extends ConsumerWidget with StatusDBStoringDialogs {
  const MainContent({super.key});

  Widget selectScreen(ScreenSelection selectedPageIndex) {
    getAllQuizSectionData(authService.user ?? '');

    switch (selectedPageIndex) {
      case ScreenSelection.kanjiSections:
        return const Column(
          children: [
            Expanded(
              child: Sections(),
            ),
          ],
        );
      case ScreenSelection.favoritesKanjis:
        return const KanjisForFavoritesScreen();
      case ScreenSelection.searchKanji:
        return SearchScreen();

      case ScreenSelection.progressTimeLine:
        return const ProgressScreen();
      default:
        return const Center(
          child: Text("no screen"),
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = MediaQuery.orientationOf(context);
    final sizeScreen = getScreenSizeWidth(context);
    bool bottomNavigationBar = true;
    switch ((orientation, sizeScreen)) {
      case (Orientation.landscape, _):
        {
          bottomNavigationBar = false;
        }
      case (_, ScreenSizeWidth.extraLarge):
        bottomNavigationBar = true;
      case (_, ScreenSizeWidth.large):
        bottomNavigationBar = true;
      case (_, _):
        bottomNavigationBar = true;
    }

    final mainScreenData = ref.watch(mainScreenProvider);
    final statusConnectionData = ref.watch(statusConnectionProvider);

    String scaffoldTitle = 'Welcome \n ${mainScreenData.fullName}';

    if (mainScreenData.selection == ScreenSelection.favoritesKanjis) {
      scaffoldTitle = "Favorites";
    }

    //final sizeScreen = getScreenSizeWidth(context);

    return Scaffold(
      appBar: bottomNavigationBar
          ? AppBar(
              title: Text(scaffoldTitle),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: statusConnectionData == ConnectivityResult.none
                      ? const Icon(Icons.cloud_off)
                      : const Icon(Icons.cloud_done_rounded),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) {
                      return const AccountDetails();
                    }));
                  },
                  child: LayoutBuilder(
                    builder: (ctx, constrains) {
                      final height = constrains.maxHeight;
                      return CachedNetworkImage(
                        width: height - 3,
                        height: height - 3,
                        fit: BoxFit.cover,
                        imageBuilder: (context, imageProvider) {
                          return CircleAvatar(
                            backgroundImage: imageProvider,
                          );
                        },
                        imageUrl: mainScreenData.avatarLink,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            Image.asset('assets/images/user.png'),
                      );
                    },
                  ),
                ),
              ],
            )
          : null,
      body: bottomNavigationBar
          ? selectScreen(mainScreenData.selection)
          : Row(
              children: [
                const CustomNavigationRail(),
                Expanded(
                  child: selectScreen(mainScreenData.selection),
                )
              ],
            ),
      bottomNavigationBar:
          bottomNavigationBar ? const CustomBottomNavigationBar() : null,
    );
  }
}

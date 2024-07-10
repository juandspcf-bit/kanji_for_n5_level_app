import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/repositories_layer/local_database/db_quiz_data_functions/db_quiz_data_functions.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/navigation_rails/custom_navigation_rail.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/main_content_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/list_favorite_kanjis_screen/kanjis_for_favorites_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/progress_screen/progress_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/search_screen/search_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/sections_screen/sections_screen.dart';

class MainContentLandScape extends ConsumerWidget {
  const MainContentLandScape({super.key});

  Widget selectScreen(ScreenSelection selectedPageIndex, WidgetRef ref) {
    getAllQuizSectionData(ref.read(authServiceProvider).userUuid ?? '');

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
    final mainScreenData = ref.watch(mainScreenProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Row(
        children: [
          const CustomNavigationRail(),
          Expanded(
            child: selectScreen(mainScreenData.selection, ref),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/l10n/localization.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/avatar_main_screen/avatar_main_screen_portrait.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/title_main_screen.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/repositories_layer/local_database/db_quiz_data_functions/db_quiz_data_functions.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/navigation_botton/bottom_navigation_bar.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/main_content_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/favorite_screen/kanjis_for_favorites_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/progress_screen/progress_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/search_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/sections_screen/sections_screen.dart';

class MainContentPortrait extends ConsumerWidget {
  const MainContentPortrait({super.key});

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
    final statusConnectionData = ref.watch(statusConnectionProvider);

    return Scaffold(
        appBar: AppBar(
          title: Builder(builder: (context) {
            if (mainScreenData.selection == ScreenSelection.favoritesKanjis) {
              return Text(context.l10n.favorites);
            } else if (mainScreenData.selection ==
                ScreenSelection.progressTimeLine) {
              return Text(context.l10n.progress);
            } else if (mainScreenData.selection ==
                ScreenSelection.searchKanji) {
              return Text(context.l10n.search_kanji);
            } else {
              return const TitleMainScreen();
            }
          }),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: statusConnectionData == ConnectionStatus.noConnected
                  ? const Icon(Icons.cloud_off)
                  : const Icon(Icons.cloud_done_rounded),
            ),
            const AvatarMainScreenPortrait(),
            const SizedBox(
              width: 5,
            ),
          ],
        ),
        body: selectScreen(mainScreenData.selection, ref),
        bottomNavigationBar: const CustomBottomNavigationBar());
  }
}

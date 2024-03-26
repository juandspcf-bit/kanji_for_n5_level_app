import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/config_files/screen_config.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/models/secction_model.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/error_fetching_kanjis.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/kanjis_list_provider.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/no_data_to_shown_screen.dart';
import 'package:kanji_for_n5_level_app/screens/navigation_bar_screens/favorite_screen/favorites_kanjis_provider.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/main_content_provider.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/kanji_item.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/shimmer_list.dart';

class BodyKanjisList extends ConsumerWidget {
  const BodyKanjisList({
    super.key,
    required this.statusResponse,
    required this.kanjisFromApi,
    required this.connectivityData,
    required this.mainScreenData,
  });

  final int statusResponse;
  final List<KanjiFromApi> kanjisFromApi;
  final ConnectivityResult connectivityData;
  final MainScreenData mainScreenData;

  Widget getKanjiItem(int index, WidgetRef ref) {
    if (mainScreenData.selection == ScreenSelection.kanjiSections) {
      return KanjiItem(
        key: ValueKey(kanjisFromApi[index].kanjiCharacter),
        kanjiFromApi: kanjisFromApi[index],
      );
    } else {
      return Dismissible(
        key: Key(kanjisFromApi[index].kanjiCharacter),
        child: KanjiItem(
          key: ValueKey(kanjisFromApi[index].kanjiCharacter),
          kanjiFromApi: kanjisFromApi[index],
        ),
        onDismissed: (direction) async {
          await ref
              .read(favoriteskanjisProvider.notifier)
              .dismissisFavorite(kanjisFromApi[index]);
        },
      );
    }
  }

  bool isAnyProcessingData() {
    try {
      kanjisFromApi.firstWhere(
        (element) =>
            element.statusStorage == StatusStorage.proccessingStoring ||
            element.statusStorage == StatusStorage.proccessingDeleting,
      );

      return true;
    } on StateError {
      return false;
    }
  }

  Widget _getListWidgets(
      Orientation orientation, ScreenSizeWidth widhtScreen, WidgetRef ref) {
    if (Orientation.portrait == orientation) {
      return ListView.builder(
        itemCount: kanjisFromApi.length,
        itemBuilder: (ctx, index) {
          return getKanjiItem(index, ref);
        },
      );
    } else if (Orientation.landscape == orientation &&
        (ScreenSizeWidth.large == widhtScreen ||
            ScreenSizeWidth.extraLarge == widhtScreen)) {
      return SafeArea(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio:
                mainScreenData.selection == ScreenSelection.favoritesKanjis
                    ? 9 / 3
                    : 10 / 3,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
          ),
          itemCount: kanjisFromApi.length,
          itemBuilder: (ctx, index) {
            return getKanjiItem(index, ref);
          },
        ),
      );
    } else if (Orientation.landscape == orientation &&
        (ScreenSizeWidth.large != widhtScreen ||
            ScreenSizeWidth.extraLarge != widhtScreen)) {
      return SafeArea(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio:
                mainScreenData.selection == ScreenSelection.favoritesKanjis
                    ? 6 / 3
                    : 8 / 3,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
          ),
          itemCount: kanjisFromApi.length,
          itemBuilder: (ctx, index) {
            return getKanjiItem(index, ref);
          },
        ),
      );
    } else {
      return ListView.builder(
        itemCount: kanjisFromApi.length,
        itemBuilder: (ctx, index) {
          return getKanjiItem(index, ref);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = MediaQuery.orientationOf(context);
    final widhtScreen = getScreenSizeWidth(context);
    final isAny = isAnyProcessingData();

    if (statusResponse == 0) {
      return SafeArea(
        child: ShimmerList(
          selection: mainScreenData.selection,
        ),
      );
    } else if (statusResponse == 1 && kanjisFromApi.isNotEmpty) {
      return (connectivityData == ConnectivityResult.none)
          ? _getListWidgets(orientation, widhtScreen, ref)
          : RefreshIndicator(
              notificationPredicate: isAny ? (_) => false : (_) => true,
              onRefresh: () async {
                if (mainScreenData.selection ==
                    ScreenSelection.favoritesKanjis) {
                  await ref
                      .read(favoriteskanjisProvider.notifier)
                      .fetchFavoritesOnRefresh();
                  return;
                }

                final kanjiListData = ref.read(kanjiListProvider);
                final sectionModel = listSections[kanjiListData.section - 1];
                ref.read(kanjiListProvider.notifier).fetchKanjis(
                      kanjisCharacters: sectionModel.kanjisCharacters,
                      sectionNumber: kanjiListData.section,
                    );
              },
              child: _getListWidgets(orientation, widhtScreen, ref));
    } else if (statusResponse == 2) {
      return ErrorFetchingKanjisScreen(mainScreenData: mainScreenData);
    } else /* if (statusResponse == 1 && kanjisFromApi.isEmpty) */ {
      return const NoDataToShownScreen();
    }
  }
}

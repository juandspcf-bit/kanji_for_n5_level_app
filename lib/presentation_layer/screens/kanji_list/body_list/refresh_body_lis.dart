import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/config_files/screen_config.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/models/secction_model.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/kanji_item.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/kanji_item_animated.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/kanjis_list_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/no_data_to_shown_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/main_content_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/favorite_screen/favorites_kanjis_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';

class RefreshBodyList extends ConsumerWidget {
  const RefreshBodyList({
    super.key,
    required this.statusResponse,
    required this.kanjisFromApi,
    required this.mainScreenData,
  });

  final int statusResponse;
  final List<KanjiFromApi> kanjisFromApi;
  final MainScreenData mainScreenData;

  bool isAnyProcessingData(List<KanjiFromApi> kanjisFromApi) {
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

  Widget getKanjiItem(
    List<KanjiFromApi> kanjisFromApi,
    MainScreenData mainScreenData,
    int index,
    WidgetRef ref,
  ) {
    if (mainScreenData.selection == ScreenSelection.kanjiSections) {
      return KanjiItemAnimated(
        statusStorage: kanjisFromApi[index].statusStorage,
        kanjiFromApi: kanjisFromApi[index],
        closedChild: KanjiItem(
          key: Key(kanjisFromApi[index].kanjiCharacter),
          kanjiFromApi: kanjisFromApi[index],
        ),
      );
    } else {
      return KanjiItemAnimated(
        statusStorage: kanjisFromApi[index].statusStorage,
        kanjiFromApi: kanjisFromApi[index],
        closedChild: Dismissible(
          key: Key(kanjisFromApi[index].kanjiCharacter),
          child: KanjiItem(
            key: Key(kanjisFromApi[index].kanjiCharacter),
            kanjiFromApi: kanjisFromApi[index],
          ),
          onDismissed: (direction) async {
            await ref
                .read(favoriteskanjisProvider.notifier)
                .dismissisFavorite(kanjisFromApi[index]);
          },
        ),
      );
    }
  }

  Widget _getListWidgets(
    BuildContext context,
    List<KanjiFromApi> kanjisFromApi,
    MainScreenData mainScreenData,
    Orientation orientation,
    ScreenSizeWidth widhtScreen,
    WidgetRef ref,
  ) {
    if (statusResponse == 1 && kanjisFromApi.isEmpty) {
      return ListView(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.3,
          ),
          const NoDataToShownScreen(),
        ],
      );
    } else if (Orientation.portrait == orientation) {
      return ListView.builder(
        itemCount: kanjisFromApi.length,
        itemBuilder: (ctx, index) {
          return getKanjiItem(
            kanjisFromApi,
            mainScreenData,
            index,
            ref,
          );
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
            return getKanjiItem(
              kanjisFromApi,
              mainScreenData,
              index,
              ref,
            );
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
            return getKanjiItem(
              kanjisFromApi,
              mainScreenData,
              index,
              ref,
            );
          },
        ),
      );
    } else {
      return ListView.builder(
        itemCount: kanjisFromApi.length,
        itemBuilder: (ctx, index) {
          return getKanjiItem(
            kanjisFromApi,
            mainScreenData,
            index,
            ref,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = MediaQuery.orientationOf(context);
    final widhtScreen = getScreenSizeWidth(context);
    final connectivityData = ref.watch(statusConnectionProvider);

    return RefreshIndicator(
      notificationPredicate: isAnyProcessingData(kanjisFromApi) ||
              connectivityData == ConnectivityResult.none
          ? (_) => false
          : (_) => true,
      onRefresh: () async {
        if (mainScreenData.selection == ScreenSelection.favoritesKanjis) {
          await ref
              .read(favoriteskanjisProvider.notifier)
              .fetchFavoritesOnRefresh();
          return;
        }

        final kanjiListData = ref.read(kanjiListProvider);
        final sectionModel = listSections[kanjiListData.section - 1];
        ref.read(kanjiListProvider.notifier).fetchKanjisOnRefresh(
              kanjisCharacters: sectionModel.kanjisCharacters,
              sectionNumber: kanjiListData.section,
            );
      },
      child: _getListWidgets(
        context,
        kanjisFromApi,
        mainScreenData,
        orientation,
        widhtScreen,
        ref,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/config_files/screen_config.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/models/section_model.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/kanji_details_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/kanji_details_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/list_tile/kanji_list_tile.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/list_tile/kanji_item_animated.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/kanjis_list_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/screens/refresh_body/no_data_to_shown_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/main_content_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/list_favorite_kanjis_screen/favorites_kanjis_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';

class RefreshBodyList extends ConsumerWidget {
  const RefreshBodyList({
    super.key,
    required this.statusResponse,
    required this.kanjisFromApi,
  });

  final int statusResponse;
  final List<KanjiFromApi> kanjisFromApi;

  bool isAnyProcessingData(List<KanjiFromApi> kanjisFromApi) {
    try {
      kanjisFromApi.firstWhere(
        (element) =>
            element.statusStorage == StatusStorage.processingStoring ||
            element.statusStorage == StatusStorage.processingDeleting,
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
    BuildContext context,
  ) {
    if (mainScreenData.selection == ScreenSelection.kanjiSections) {
      return GestureDetector(
        onTap: () {
          final isProcessingData = kanjisFromApi[index].statusStorage ==
                  StatusStorage.processingStoring ||
              kanjisFromApi[index].statusStorage ==
                  StatusStorage.processingDeleting;

          if (isProcessingData) return;

          ref
              .read(kanjiDetailsProvider.notifier)
              .initKanjiDetails(kanjisFromApi[index]);

          Navigator.of(context).push(
            PageRouteBuilder(
              transitionDuration: const Duration(seconds: 1),
              reverseTransitionDuration: const Duration(seconds: 1),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const KanjiDetails(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: Tween<double>(
                    begin: 0,
                    end: 1,
                  ).animate(
                    animation.drive(
                      CurveTween(
                        curve: Curves.easeInOutBack,
                      ),
                    ),
                  ),
                  child: child,
                );
              },
            ),
          );
        },
        child: KanjiListTile(
          key: Key(kanjisFromApi[index].kanjiCharacter),
          kanjiFromApi: kanjisFromApi[index],
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          final isProcessingData = kanjisFromApi[index].statusStorage ==
                  StatusStorage.processingStoring ||
              kanjisFromApi[index].statusStorage ==
                  StatusStorage.processingDeleting;

          if (isProcessingData) return;

          ref
              .read(kanjiDetailsProvider.notifier)
              .initKanjiDetails(kanjisFromApi[index]);

          Navigator.of(context).push(
            PageRouteBuilder(
              transitionDuration: const Duration(seconds: 1),
              reverseTransitionDuration: const Duration(seconds: 1),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const KanjiDetails(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: Tween<double>(
                    begin: 0,
                    end: 1,
                  ).animate(
                    animation.drive(
                      CurveTween(
                        curve: Curves.easeInOutBack,
                      ),
                    ),
                  ),
                  child: child,
                );
              },
            ),
          );
        },
        child: Dismissible(
          key: Key(kanjisFromApi[index].kanjiCharacter),
          child: KanjiListTile(
            key: Key(kanjisFromApi[index].kanjiCharacter),
            kanjiFromApi: kanjisFromApi[index],
          ),
          onDismissed: (direction) async {
            await ref
                .read(favoritesKanjisProvider.notifier)
                .dismissFavorite(kanjisFromApi[index]);
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
    ScreenSizeWidth widthScreen,
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
              kanjisFromApi, mainScreenData, index, ref, context);
        },
      );
    } else if (Orientation.landscape == orientation &&
        (ScreenSizeWidth.large == widthScreen ||
            ScreenSizeWidth.extraLarge == widthScreen)) {
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
                kanjisFromApi, mainScreenData, index, ref, context);
          },
        ),
      );
    } else if (Orientation.landscape == orientation &&
        (ScreenSizeWidth.large != widthScreen ||
            ScreenSizeWidth.extraLarge != widthScreen)) {
      return SafeArea(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio:
                mainScreenData.selection == ScreenSelection.favoritesKanjis
                    ? 6 / 4
                    : 8 / 3,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
          ),
          itemCount: kanjisFromApi.length,
          itemBuilder: (ctx, index) {
            return getKanjiItem(
                kanjisFromApi, mainScreenData, index, ref, context);
          },
        ),
      );
    } else {
      return ListView.builder(
        itemCount: kanjisFromApi.length,
        itemBuilder: (ctx, index) {
          return getKanjiItem(
              kanjisFromApi, mainScreenData, index, ref, context);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = MediaQuery.orientationOf(context);
    final widthScreen = getScreenSizeWidth(context);
    final connectivityData = ref.watch(statusConnectionProvider);
    final mainScreenData = ref.watch(mainScreenProvider);

    return RefreshIndicator(
      notificationPredicate: isAnyProcessingData(kanjisFromApi) ||
              connectivityData == ConnectionStatus.noConnected
          ? (_) => false
          : (_) => true,
      onRefresh: () async {
        if (mainScreenData.selection == ScreenSelection.favoritesKanjis) {
          await ref
              .read(favoritesKanjisProvider.notifier)
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
        widthScreen,
        ref,
      ),
    );
  }
}

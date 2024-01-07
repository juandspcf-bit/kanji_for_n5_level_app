import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/models/secction_model.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/screens/navigation_bar_screens/favorite_screen/favorites_kanjis_provider.dart';
import 'package:kanji_for_n5_level_app/providers/kanjis_list_provider.dart';
import 'package:kanji_for_n5_level_app/providers/main_screen_provider.dart';
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
      logger.d(kanjisFromApi[index].statusStorage);
      if (kanjisFromApi[index].statusStorage ==
              StatusStorage.proccessingStoring ||
          kanjisFromApi[index].statusStorage ==
              StatusStorage.proccessingDeleting) {
        return KanjiItem(
          key: ValueKey(kanjisFromApi[index].kanjiCharacter),
          kanjiFromApi: kanjisFromApi[index],
        );
      }
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAny = isAnyProcessingData();

    if (statusResponse == 0) {
      return const ShimmerList();
    } else if (statusResponse == 1 && kanjisFromApi.isNotEmpty) {
      return (connectivityData == ConnectivityResult.none)
          ? ListView.builder(
              itemCount: kanjisFromApi.length,
              itemBuilder: (ctx, index) {
                return getKanjiItem(index, ref);
              },
            )
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
              child: ListView.builder(
                itemCount: kanjisFromApi.length,
                itemBuilder: (ctx, index) {
                  return getKanjiItem(index, ref);
                },
              ),
            );
    } else if (statusResponse == 2) {
      return LayoutBuilder(
        builder: (contx, viewportConstraints) {
          return RefreshIndicator(
            onRefresh: () async {
              if (mainScreenData.selection == ScreenSelection.favoritesKanjis) {
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
            child: ListView(
              children: [
                ConstrainedBox(
                  constraints: viewportConstraints.copyWith(
                    minHeight: viewportConstraints.maxHeight,
                    maxHeight: double.infinity,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'An error has occurr',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.amber,
                            size: 80,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      );
    } else if (statusResponse == 1 && kanjisFromApi.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No data to show',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.data_usage,
                color: Theme.of(context).colorScheme.primary,
                size: 80,
              ),
            ],
          )
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No state to match',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.question_mark,
                color: Theme.of(context).colorScheme.primary,
                size: 80,
              ),
            ],
          )
        ],
      );
    }
  }
}

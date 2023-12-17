import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/models/secction_model.dart';
import 'package:kanji_for_n5_level_app/providers/favorites_kanjis_provider.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (statusResponse == 0) {
      return const ShimmerList();
    } else if (statusResponse == 1 && kanjisFromApi.isNotEmpty) {
      return connectivityData == ConnectivityResult.none
          ? ListView.builder(
              itemCount: kanjisFromApi.length,
              itemBuilder: (ctx, index) {
                return KanjiItem(
                  key: ValueKey(kanjisFromApi[index].kanjiCharacter),
                  kanjiFromApi: kanjisFromApi[index],
                );
              },
            )
          : RefreshIndicator(
              onRefresh: () async {
                if (connectivityData == ConnectivityResult.none) return;

                if (mainScreenData.selection == 1) {
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
                  return KanjiItem(
                    key: ValueKey(kanjisFromApi[index].kanjiCharacter),
                    kanjiFromApi: kanjisFromApi[index],
                  );
                },
              ),
            );
    } else if (statusResponse == 2) {
      return LayoutBuilder(
        builder: (contx, viewportConstraints) {
          final isAnyProcessingDataFunc =
              ref.read(kanjiListProvider.notifier).isAnyProcessingData;
          return RefreshIndicator(
            onRefresh: () async {
              if (connectivityData == ConnectivityResult.none ||
                  isAnyProcessingDataFunc()) return;

              if (mainScreenData.selection == 1) {
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

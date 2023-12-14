import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/models/secction_model.dart';
import 'package:kanji_for_n5_level_app/providers/error_storing_database_status.dart';
import 'package:kanji_for_n5_level_app/providers/favorites_kanjis_provider.dart';
import 'package:kanji_for_n5_level_app/providers/kanjis_list_provider.dart';
import 'package:kanji_for_n5_level_app/providers/listen_connection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/main_screen_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/kanji_item.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/shimmer_list.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/main_content.dart';

class BodyKanjisList extends ConsumerStatefulWidget {
  const BodyKanjisList({
    super.key,
    required this.statusResponse,
    required this.kanjisFromApi,
  });

  final int statusResponse;
  final List<KanjiFromApi> kanjisFromApi;

  @override
  ConsumerState<BodyKanjisList> createState() => _BodiKanjiListState();
}

class _BodiKanjiListState extends ConsumerState<BodyKanjisList> {
  Widget _dialogError(BuildContext buildContext) {
    return AlertDialog(
      title: const Text(
          'An issue happened when deleting this item, please go back to the section list and access the content again to see the updated content.'),
      content: const Icon(
        Icons.error_rounded,
        color: Colors.amberAccent,
        size: 70,
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              ref.read(errorStoringDatabaseStatus.notifier).setError(false);
              Navigator.of(buildContext).pop();
            },
            child: const Text("Okay"))
      ],
    );
  }

  void _scaleDialogError(BuildContext buildContext) {
    showGeneralDialog(
      context: buildContext,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: _dialogError(buildContext),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final connectivityData = ref.watch(statusConnectionProvider);
    final mainScreenData = ref.watch(mainScreenProvider);
    if (ref.watch(errorStoringDatabaseStatus)) {
      _scaleDialogError(context);
    }
    if (widget.statusResponse == 0) {
      return const ShimmerList();
    } else if (widget.statusResponse == 1 && widget.kanjisFromApi.isNotEmpty) {
      return connectivityData == ConnectivityResult.none
          ? ListView.builder(
              itemCount: widget.kanjisFromApi.length,
              itemBuilder: (ctx, index) {
                return KanjiItem(
                  key: ValueKey(widget.kanjisFromApi[index].kanjiCharacter),
                  kanjiFromApi: widget.kanjisFromApi[index],
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
                itemCount: widget.kanjisFromApi.length,
                itemBuilder: (ctx, index) {
                  return KanjiItem(
                    key: ValueKey(widget.kanjisFromApi[index].kanjiCharacter),
                    kanjiFromApi: widget.kanjisFromApi[index],
                  );
                },
              ),
            );
    } else if (widget.statusResponse == 2) {
      return RefreshIndicator(
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
        child: ListView(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Column(
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
              ),
            )
          ],
        ),
      );
    } else if (widget.statusResponse == 1 && widget.kanjisFromApi.isEmpty) {
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

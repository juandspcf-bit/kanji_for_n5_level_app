import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/Databases/db_computes_functions.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/favorite_screen_selection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/kanji_item.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/trailing_tile.dart';

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
  @override
  void initState() {
    super.initState();
  }

  void insertKanji(
    KanjiFromApi kanjiFromApi,
  ) {
    final selection =
        ref.read(favoriteScreenSelectionProvider.notifier).getSelection();
    final kanjiItemProcessingHelper =
        KanjiItemProcessingHelper(kanjiFromApi, selection, ref, context);
    kanjiItemProcessingHelper.updateKanjiItemStatusToProcessingStatus(
        StatusStorage.proccessingStoring);
    //kanjiItemProcessingHelper.insertKanjiToStorage();
    insertKanjiToStorageComputeVersion(kanjiFromApi, ref, selection);
  }

  void deleteKanji(KanjiFromApi kanjiFromApi) {
    final selection =
        ref.read(favoriteScreenSelectionProvider.notifier).getSelection();
    final kanjiItemProcessingHelper =
        KanjiItemProcessingHelper(kanjiFromApi, selection, ref, context);
    kanjiItemProcessingHelper.updateKanjiItemStatusToProcessingStatus(
        StatusStorage.proccessingDeleting);
    kanjiItemProcessingHelper.deleteKanjFromStorage();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.statusResponse == 0) {
      return const Center(child: CircularProgressIndicator());
    } else if (widget.statusResponse == 1 && widget.kanjisFromApi.isNotEmpty) {
      return ListView.builder(
          itemCount: widget.kanjisFromApi.length,
          itemBuilder: (ctx, index) {
            return KanjiItem(
              key: ValueKey(widget.kanjisFromApi[index].kanjiCharacter),
              kanjiFromApi: widget.kanjisFromApi[index],
              insertKanji: insertKanji,
              deleteKanji: deleteKanji,
            );
          });
    } else if (widget.statusResponse == 2) {
      return Column(
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
          )
        ],
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

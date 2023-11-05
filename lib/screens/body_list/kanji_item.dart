// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/favorite_screen_selection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/leading_tile.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/subtitle_tile.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/title_tile.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/trailing_tile.dart';
import 'package:kanji_for_n5_level_app/screens/kaji_details.dart';

class KanjiItem extends ConsumerStatefulWidget {
  const KanjiItem({
    super.key,
    required this.kanjiFromApi,
    required this.insertKanji,
    required this.deleteKanji,
  });

  final KanjiFromApi kanjiFromApi;
  final void Function(KanjiFromApi kanjiFromApi) insertKanji;
  final void Function(KanjiFromApi kanjiFromApi) deleteKanji;

  @override
  ConsumerState<KanjiItem> createState() => _KanjiItemState();
}

class _KanjiItemState extends ConsumerState<KanjiItem> {
  var accessToKanjiItemsButtons = true;

  void insertKanji(
    KanjiFromApi kanjiFromApi,
  ) {
    final selection =
        ref.read(favoriteScreenSelectionProvider.notifier).getSelection();
    final kanjiItemProcessingHelper =
        KanjiItemProcessingHelper(kanjiFromApi, selection, ref, context);
    kanjiItemProcessingHelper.updateKanjiItemStatusToProcessingStatus(
        StatusStorage.proccessingStoring);
    kanjiItemProcessingHelper.insertKanjiToStorage();
  }

  void navigateToKanjiDetails(
    BuildContext context,
    KanjiFromApi? kanjiFromApi,
  ) {
    if (kanjiFromApi == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) {
        return KanjiDetails(
          kanjiFromApi: kanjiFromApi,
          statusStorage: kanjiFromApi.statusStorage,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: accessToKanjiItemsButtons
          ? Theme.of(context).cardColor.withOpacity(1)
          : Theme.of(context).cardColor.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            LeadingTile(
              kanjiFromApi: widget.kanjiFromApi,
              navigateToKanjiDetails: navigateToKanjiDetails,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: widget.kanjiFromApi.accessToKanjiItemsButtons
                      ? () {
                          navigateToKanjiDetails(context, widget.kanjiFromApi);
                        }
                      : null,
                  child: Container(
                    color: Colors.transparent,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleTile(
                          kanjiFromApi: widget.kanjiFromApi,
                          navigateToKanjiDetails: navigateToKanjiDetails,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SubTitleTile(
                          kanjiFromApi: widget.kanjiFromApi,
                          navigateToKanjiDetails: navigateToKanjiDetails,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                child: TrailingTile(
                  kanjiFromApi: widget.kanjiFromApi,
                  insertKanji: widget.insertKanji,
                  deleteKanji: widget.deleteKanji,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/video_status_playing.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/leading_tile.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/subtitle_tile.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/title_tile.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/trailing_tile.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/kaji_details.dart';

class KanjiItem extends ConsumerStatefulWidget {
  const KanjiItem({
    super.key,
    required this.kanjiFromApi,
  });

  final KanjiFromApi kanjiFromApi;

  @override
  ConsumerState<KanjiItem> createState() => _KanjiItemState();
}

class _KanjiItemState extends ConsumerState<KanjiItem> {
  var accessToKanjiItemsButtons = true;

  void navigateToKanjiDetails(
    BuildContext context,
    KanjiFromApi? kanjiFromApi,
  ) {
    if (kanjiFromApi == null) return;
    ref.read(videoStatusPlaying.notifier).setSpeed(1.0);
    ref.read(videoStatusPlaying.notifier).setIsPlaying(true);
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
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
